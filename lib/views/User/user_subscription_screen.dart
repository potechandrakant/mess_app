import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mess_app/controllers/currentUser.dart';
import 'package:mess_app/views/User/payment_method.dart';

class UserSubscriptionScreen extends StatefulWidget {
  const UserSubscriptionScreen({super.key});

  @override
  State<UserSubscriptionScreen> createState() => _UserSubscriptionScreenState();
}

class _UserSubscriptionScreenState extends State<UserSubscriptionScreen> {
  String currentMeal = "Weekly";
  String currentPlan = "";

  String? messStartDate;
  String? messEndDate30;
  String? messEndDate15;
  String? messEndDate7;

  @override
  void initState() {
    super.initState();
    DateTime? now = DateTime.now();
    messStartDate = "${now.day}-${now.month}-${now.year}";
    DateTime? endDate30 = now.add(Duration(days: 30));
    messEndDate30 = "${endDate30.day}-${endDate30.month}-${endDate30.year}";
    DateTime? endDate15 = now.add(Duration(days: 30));
    messEndDate15 = "${endDate15.day}-${endDate15.month}-${endDate15.year}";
    DateTime? endDate7 = now.add(Duration(days: 30));
    messEndDate7 = "${endDate7.day}-${endDate7.month}-${endDate7.year}";

    loadUserData();
  }

  String? email;
  String currentUser = "";
  bool isLoading = true;

  Future<void> loadUserData() async {
    try {
      final data = await Currentuser.getUserData();
      log("User Data: $data");

      if (data['email'] != null) {
        email = data['email'];
        log("User Email: $email");

        // Fetch user name using email after it's set
        await fetchUserName(email!);
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log("Error loading user data: $e");
    }
  }

  Future<void> fetchUserName(String email) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("CustomerProfileData")
          .doc(email)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        currentUser = data['customerName'] ?? "";
        log("Current User Name: $currentUser");
      } else {
        log("User document not found in Firestore.");
      }
    } catch (error) {
      log("Error fetching username: $error");
    }
  }

  Future<void> subscripeUser({planName, amount, startDate, endDate}) async {
    if (currentUser.isEmpty) {
      log("Username empty — attendance not saved");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('Subscriptions').add({
        'username': currentUser,
        'email': email,
        'startDate': startDate,
        'endDate': endDate,
        'isSubscribed': true,
        'subscriptedTime': Timestamp.now(),
      });
      log("Attendance saved for $email");
    } catch (e) {
      log("Error saving attendance: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_rounded,
            size: 30,
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        title: Text(
          "Subscription",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(35, 22, 15, 1),
      ),

      backgroundColor: Color.fromRGBO(35, 22, 15, 1),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 15, 18, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose Your Plan",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 26,
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                "Save with a subscription and never miss a meal. Joined 10,000+ happy subscribers.",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
              ),

              const SizedBox(height: 16),

              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: Color.fromRGBO(220, 220, 220, 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: currentMeal == "Weekly"
                              ? Color.fromRGBO(61, 43, 35, 1)
                              : Color.fromRGBO(35, 22, 15, 1),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            currentMeal = "Weekly";
                            setState(() {});
                          },
                          child: Text(
                            "Mess Plan",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: currentMeal == "Weekly"
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(174, 174, 174, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              GestureDetector(
                onTap: () {
                  currentPlan = "Trial Plan";
                  setState(() {});
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromRGBO(61, 43, 35, 1),
                    border: Border.all(
                      width: 3,
                      color: currentPlan == "Trial Plan"
                          ? Color.fromRGBO(250, 111, 41, 1)
                          : Color.fromRGBO(35, 22, 15, 1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.15),
                        blurRadius: 6,
                        spreadRadius: 1,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Trial Plan",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: 35,
                              width: 120,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(250, 111, 41, 1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Text(
                                "Limited Time",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Icon(
                              Icons.currency_rupee_rounded,
                              size: 30,
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontWeight: FontWeight.w700,
                            ),
                            Text(
                              "800",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 30,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                " /week",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 28,
                              color: Color.fromRGBO(250, 111, 41, 1),
                            ),

                            const SizedBox(width: 12),

                            Text(
                              "7 meals per week",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 28,
                              color: Color.fromRGBO(250, 111, 41, 1),
                            ),

                            const SizedBox(width: 12),

                            Text(
                              "Cancel anytime",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: () async {
                            await subscripeUser(
                              planName: "Trial Plan",
                              amount: 800,
                              startDate: messStartDate!,
                              endDate: messEndDate7!,
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentMethod(
                                  totalCost: 800,
                                  startDate: messStartDate!,
                                  endDate: messEndDate7!,
                                ),
                              ),
                            );
                          },

                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: currentPlan == "Trial Plan"
                                  ? Color.fromRGBO(250, 111, 41, 1)
                                  : Color.fromRGBO(35, 22, 15, 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Try Now",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              GestureDetector(
                onTap: () {
                  currentPlan = "Monthly Plan";
                  setState(() {});
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(61, 43, 35, 1),
                    border: Border.all(
                      width: 2,
                      color: currentPlan == "Monthly Plan"
                          ? Color.fromRGBO(250, 111, 41, 1)
                          : Color.fromRGBO(35, 22, 15, 1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.15),
                        blurRadius: 6,
                        spreadRadius: 1,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Monthly Plan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),

                        Row(
                          children: [
                            Icon(
                              Icons.currency_rupee_rounded,
                              size: 30,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                            Text(
                              "3500",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 30,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                " /month",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 28,
                              color: Color.fromRGBO(250, 111, 41, 1),
                            ),

                            const SizedBox(width: 12),

                            Text(
                              "30 meals per week",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 28,
                              color: Color.fromRGBO(250, 111, 41, 1),
                            ),

                            const SizedBox(width: 12),

                            Text(
                              "Save 20%",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 28,
                              color: Color.fromRGBO(250, 111, 41, 1),
                            ),

                            const SizedBox(width: 12),

                            Text(
                              "Flexible delivery",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 28,
                              color: Color.fromRGBO(250, 111, 41, 1),
                            ),

                            const SizedBox(width: 12),

                            Text(
                              "Cancel anytime",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: () async {
                            await subscripeUser(
                              planName: "Monthly Plan",
                              amount: 3500,
                              startDate: messStartDate!,
                              endDate: messEndDate30!,
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentMethod(
                                  totalCost: 3500,
                                  startDate: messStartDate!,
                                  endDate: messEndDate30!,
                                ),
                              ),
                            );
                          },

                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: currentPlan == "Monthly Plan"
                                  ? Color.fromRGBO(250, 111, 41, 1)
                                  : Color.fromRGBO(35, 22, 15, 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Subscribe",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              GestureDetector(
                onTap: () {
                  currentPlan = "Weekly Plan";
                  setState(() {});
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(61, 43, 35, 1),
                    border: Border.all(
                      width: 2,
                      color: currentPlan == "Weekly Plan"
                          ? Color.fromRGBO(250, 111, 41, 1)
                          : Color.fromRGBO(35, 22, 15, 1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.15),
                        blurRadius: 6,
                        spreadRadius: 1,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "2 Weekly Plan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),

                        Row(
                          children: [
                            Icon(
                              Icons.currency_rupee_rounded,
                              size: 30,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                            Text(
                              "1500",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 30,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                " /2 week",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 28,
                              color: Color.fromRGBO(250, 111, 41, 1),
                            ),

                            const SizedBox(width: 12),

                            Text(
                              "15 meals per week",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 28,
                              color: Color.fromRGBO(250, 111, 41, 1),
                            ),

                            const SizedBox(width: 12),

                            Text(
                              "Flexible delivery",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              size: 28,
                              color: Color.fromRGBO(250, 111, 41, 1),
                            ),

                            const SizedBox(width: 12),

                            Text(
                              "Cancel anytime",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: () async {
                            await subscripeUser(
                              planName: "2 Weekly Plan",
                              amount: 1500,
                              startDate: messStartDate!,
                              endDate: messEndDate15!,
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentMethod(
                                  totalCost: 1500,
                                  startDate: messStartDate!,
                                  endDate: messEndDate15!,
                                ),
                              ),
                            );
                          },

                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: currentPlan == "Weekly Plan"
                                  ? Color.fromRGBO(250, 111, 41, 1)
                                  : Color.fromRGBO(35, 22, 15, 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Subscribe",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

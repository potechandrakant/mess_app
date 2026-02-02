import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mess_app/controllers/currentUser.dart';
import 'package:mess_app/views/Login_Screens/user_login_screen.dart';
import 'package:mess_app/views/User/user_edit_profile.dart';
import 'package:mess_app/views/common/user_bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> attendanceList = [];

  @override
  void initState() {
    super.initState();
    //loadUserData();
    fetchData();
    fetchAttendance();
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromRGBO(35, 22, 15, 1),
        title: const Text(
          "Logout Confirmation",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to log out?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // dismiss the dialog
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.orangeAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close the dialog first
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserLoginScreen(),
                ),
                (route) => false,
              );
            },
            child: const Text(
              "Yes, Logout",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  String? email;
  String? name;
  bool isLoading = true;
  // void loadUserData() async {
  //   final data = await Currentuser.getUserData();
  //   log("$data==========");
  //   setState(() {
  //     email = data['email'];
  //   });
  // }

  Future<void> fetchData() async {
    try {
      final data = await Currentuser.getUserData();
      email = data['email'];
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("CustomerProfileData")
          .doc(email)
          .get();

      if (doc.exists) {
        var data = await doc.data() as Map<String, dynamic>;
        name = data['customerName'];
        log("Name: ${data['customerName']}");
        log("Email: ${data['emailId']}");
      } else {
        log("Document not found!");
      }
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      log("Error fetching data : $error");
    }
  }

  Future<void> fetchAttendance() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Attendance')
          .where('email', isEqualTo: email)
          .get();

      setState(() {
        attendanceList = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        isLoading = false;
      });
    } catch (e) {
      log("Error fetching attendance: $e");
      setState(() => isLoading = false);
    }
  }

  // String formatDate(String timestamp) {
  //   return DateFormat(
  //     'dd MMM yyyy, hh:mm a',
  //   ).format(timestamp.toDate()).toString();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 22, 15, 1),
      //APP BAR
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 22, 15, 1),

        title: Text(
          "Profile",
          style: GoogleFonts.quicksand(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
          ),
          SizedBox(width: 15),

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
            child: GestureDetector(
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
              child: Icon(Icons.logout, size: 30, color: Colors.white),
            ),
          ),
        ],
      ),

      ///BODY
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsetsGeometry.all(12),
              child: Center(
                child: Column(
                  children: [
                    ///PROFILE IMAGE
                    ClipRRect(
                      borderRadius: BorderRadius.circular(120),

                      child: Image.network(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzR0bIMZ71HVeR5zF4PihQaDvTQQk6bsVERw&s",
                        height: 120,
                      ),
                    ),
                    SizedBox(height: 10),
                    //NAME
                    Text(
                      "$name",
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 3),

                    ///EMAIL ID
                    Text(
                      "$email",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Subscription Details",
                          style: GoogleFonts.poppins(
                            fontSize: 27,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    ///RAMAINING MEAL
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Remaining Meals ",
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            color: const Color.fromARGB(255, 194, 187, 187),
                          ),
                        ),
                        Text(
                          "28",
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    ///EXPIRY DATE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Expiry Date ",
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            color: const Color.fromARGB(255, 194, 187, 187),
                          ),
                        ),
                        Text(
                          "2025-12-5",
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 22),

                    ///PAST ATTENDANCE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Past Attendance",
                          style: GoogleFonts.poppins(
                            fontSize: 27,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    /// LUNCH CARDS
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: attendanceList.length,
                        itemBuilder: (context, index) {
                          final record = attendanceList[index];
                          return Container(
                            padding: EdgeInsets.all(10),
                            height: 75,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(94, 73, 65, 0.76),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /// FOOD IMAGE
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Image.asset(
                                        "assets/Spoon.jpeg",
                                        height: 45,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Row(
                                  children: [
                                    ///MEAL NAME
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          record['mealType'] ?? 'Unknown Meal',
                                          style: GoogleFonts.quicksand(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          record['time'],

                                          style: GoogleFonts.quicksand(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 100),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

      bottomNavigationBar: CurvedBottomNav(currentIndex: 4),
    );
  }
}

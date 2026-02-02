import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mess_app/controllers/currentUser.dart';
import 'package:mess_app/views/Login_Screens/user_login_screen.dart';
import 'package:mess_app/views/admin/attendance_log.dart';
import 'package:mess_app/views/admin/mess_profile_management_screen.dart';
import 'package:mess_app/views/admin/payments_revenue.dart';
import 'package:mess_app/views/common/aboutus.dart';
import 'package:mess_app/views/common/owner_bottom_nav.dart';

class Messprofile extends StatefulWidget {
  const Messprofile({super.key});

  @override
  State<Messprofile> createState() => _MessprofileState();
}

class _MessprofileState extends State<Messprofile> {
  String name = "";
  bool isLoading = true;

  String? email;
  String currentUser = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
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
          .collection("OwnerProfileData")
          .doc(email)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        currentUser = data['ownerName'] ?? "";
        log("Current User Name: $currentUser");
      } else {
        log("⚠️ User document not found in Firestore.");
      }
    } catch (error) {
      log("Error fetching username: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(35, 22, 15, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(35, 22, 15, 1),

        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),

        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },

            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 170,
                child: ClipOval(
                  child: Image.asset(
                    "assets/user_ Profile_img.jpeg",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Sharvil Mane",
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "$email",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Bussiness Summary",
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: MediaQuery.of(context).size.width * 0.42,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(61, 43, 35, 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Followers",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '1',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: MediaQuery.of(context).size.width * 0.48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(61, 43, 35, 1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.grey.shade500)],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Active Subscriptions",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  '1',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mess Management",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const MessProfilePage();
                            },
                          ),
                        );
                        log("Manage Mess profile");
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(61, 43, 35, 1),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.grey.shade200)],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.account_box,
                                color: Color.fromRGBO(250, 111, 41, 1),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                "Manage Mess Profile",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return AttendanceLog();
                            },
                          ),
                        );
                        log("Attendence log");
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(61, 43, 35, 1),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.grey.shade200)],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.fact_check,
                                color: Color.fromRGBO(250, 111, 41, 1),
                              ),
                              const SizedBox(width: 15),
                              Text(
                                "Attendence Log",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Text(
              //       "Account",
              //       style: GoogleFonts.poppins(
              //         fontSize: 24,
              //         fontWeight: FontWeight.w600,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 10),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: GestureDetector(
              //     onTap: () {
              //       log("Account setting");
              //     },
              //     child: Container(
              //       height: 50,
              //       decoration: BoxDecoration(
              //         color: const Color.fromRGBO(61, 43, 35, 1),
              //         borderRadius: BorderRadius.circular(10),
              //         boxShadow: [BoxShadow(color: Colors.grey.shade200)],
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Row(
              //           children: [
              //             const Icon(
              //               Icons.person,
              //               color: Color.fromRGBO(250, 111, 41, 1),
              //             ),
              //             const SizedBox(width: 15),
              //             Text(
              //               "Account Setting",
              //               style: GoogleFonts.poppins(
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.w600,
              //                 color: Colors.white,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AboutUsPage()),
                    );
                    log("About Us");
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(61, 43, 35, 1),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.grey.shade200)],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.help,
                            color: Color.fromRGBO(250, 111, 41, 1),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            "About Us",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const CurvedBottomNavOwner(currentIndex: 3),
    );
  }
}

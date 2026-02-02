import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mess_app/controllers/currentUser.dart';
import 'package:mess_app/views/SignUp_Screens/user_signUp.dart';
import 'package:mess_app/views/User_Home_Screens/homescreen.dart';
import 'package:mess_app/views/admin/menu_upload_screen.dart';
import 'package:mess_app/views/common/custom_snackbar.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({super.key});

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool passtext = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              height: 700,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(25),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromRGBO(73, 42, 12, 0.619),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.50),
                    blurRadius: 24,
                    spreadRadius: 7,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [],
                  ),

                  ///LOGO
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orangeAccent,

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 16,
                          spreadRadius: 1,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.restaurant_menu_rounded,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  /// EMAIL
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Enter email",
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: const Color.fromARGB(255, 137, 134, 134),
                      ),
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    style: TextStyle(
                      color: const Color.fromARGB(255, 250, 249, 249),
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 40),

                  ///PASSWORD
                  TextField(
                    controller: passwordController,
                    obscureText: passtext, // hides text when true
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      hintStyle: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 250, 249, 249),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fillColor: Colors.amber,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            passtext = !passtext; // toggle visibility
                          });
                        },
                        child: Icon(
                          passtext ? Icons.visibility_off : Icons.visibility,
                          color: const Color.fromARGB(255, 137, 134, 134),
                        ),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(height: 50),

                  /// CUSTOMER BUTTON
                  GestureDetector(
                    onTap: () async {
                      if (emailController.text.trim().isNotEmpty &&
                          passwordController.text.trim().isNotEmpty) {
                        try {
                          UserCredential userCredentialObj = await _firebaseAuth
                              .signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );

                          log("$userCredentialObj");

                          CustomSnackbar().showCustomSnackbar(
                            context,
                            "Login Successful !",
                            bgColor: Colors.green,
                          );

                          Currentuser.saveUserData(emailController.text);

                          // widget.currEml = emailController.text.trim();
                          //CLEAR CONTROLLERS
                          emailController.clear();
                          passwordController.clear();

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) {
                                return Homescreen();
                              },
                            ),
                          );
                        } on FirebaseAuthException catch (error) {
                          CustomSnackbar().showCustomSnackbar(
                            context,
                            error.message!,
                            bgColor: Colors.red,
                          );
                        }
                      } else {
                        CustomSnackbar().showCustomSnackbar(
                          context,
                          "Enter Valid Email",
                          bgColor: Colors.red,
                        );
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.065,
                      width: MediaQuery.of(context).size.width * 0.65,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color.fromARGB(255, 251, 250, 251),
                      ),
                      child: Text(
                        "Customer",
                        style: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  ///MESS OWNER BUTTON
                  GestureDetector(
                    onTap: () async {
                      if (emailController.text.trim().isNotEmpty &&
                          passwordController.text.trim().isNotEmpty) {
                        try {
                          UserCredential userCredentialObj = await _firebaseAuth
                              .signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              );

                          log("$userCredentialObj");

                          CustomSnackbar().showCustomSnackbar(
                            context,
                            "Login Successful !",
                            bgColor: Colors.green,
                          );

                          Currentuser.saveUserData(emailController.text);
                          //CLEAR CONTROLLERS
                          emailController.clear();
                          passwordController.clear();

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) {
                                return UploadMenuPage();
                              },
                            ),
                          );
                        } on FirebaseAuthException catch (error) {
                          CustomSnackbar().showCustomSnackbar(
                            context,
                            error.message!,
                            bgColor: const Color.fromARGB(189, 244, 27, 27),
                          );
                        }
                      } else {
                        CustomSnackbar().showCustomSnackbar(
                          context,
                          "Enter Valid Email",
                          bgColor: const Color.fromARGB(189, 244, 27, 27),
                        );
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.065,
                      width: MediaQuery.of(context).size.width * 0.65,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color.fromARGB(255, 229, 181, 6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Mess Owner",
                            style: GoogleFonts.quicksand(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.restaurant_menu_outlined),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 45),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an Account ? ",
                        style: GoogleFonts.quicksand(
                          fontSize: MediaQuery.of(context).size.width * 0.048,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return UserSignUpScreen();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: MediaQuery.of(context).size.width * 0.048,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Future<bool> checkCostomer() async {
    final docRef = FirebaseFirestore.instance
        .collection('CustomerProfileData')
        .doc(emailController.text.trim());

    final doc = await docRef.get();
    return doc.exists;
  }

  Future<bool> checkOwner() async {
    final docRef = FirebaseFirestore.instance
        .collection('OwnerProfileData')
        .doc(emailController.text.trim());

    final doc = await docRef.get();
    return doc.exists;
  }
}

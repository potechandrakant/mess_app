import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mess_app/views/common/custom_snackbar.dart';

class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({super.key});

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  File? _selectedImage; // at top of your class
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text(
                  "Take a Photo",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text(
                  "Choose from Gallery",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  bool isMessOwner = false;

  List<String> messTypes = [
    'Veg Mess',
    'Non-Veg Mess',
    'Jain Mess',
    'Special Combo Mess',
  ];

  // Initialize visibility state variables
  bool passwordVisible = false; // Start with password hidden
  bool confirmPasswordVisible = false; // Start with confirm password hidden

  String? selectedMessType; // For storing selected mess type
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController messNameController = TextEditingController();
  TextEditingController messLocationController = TextEditingController();
  TextEditingController messTimeController = TextEditingController();
  TextEditingController userAddressController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestoreObj = FirebaseFirestore.instance;

  void addOwnerProfileData() async {
    FocusScope.of(context).unfocus();

    if (nameController.text.trim().isNotEmpty &&
        mobileController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        messLocationController.text.trim().isNotEmpty &&
        messNameController.text.trim().isNotEmpty &&
        selectedMessType != null) {
      Map<String, dynamic> data = {
        "ownerName": nameController.text.trim(),
        "mobileNo": mobileController.text.trim(),
        "emailId": emailController.text.trim(),
        "messName": messNameController.text.trim(),
        "messLocation": messLocationController.text.trim(),
        "messType": selectedMessType,
        "messTime": messTimeController.text.trim(),
      };

      await _firebaseFirestoreObj
          .collection("OwnerProfileData")
          .doc(emailController.text.trim())
          .set(data);

      nameController.clear();
      mobileController.clear();
      emailController.clear();
      messNameController.clear();
      messLocationController.clear();
      messTimeController.clear();
    }
  }

  void addUserProfileData() async {
    FocusScope.of(context).unfocus();
    if (nameController.text.trim().isNotEmpty &&
        mobileController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty) {
      //DATA

      Map<String, dynamic> data = {
        "customerName": nameController.text,
        "mobileNo": mobileController.text,
        "emailId": emailController.text,
        "userAddress": userAddressController.text,
      };

      await _firebaseFirestoreObj
          .collection("CustomerProfileData")
          .doc(emailController.text.trim())
          .set(data);
      nameController.clear();
      mobileController.clear();
      emailController.clear();
      userAddressController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 1.2,
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(25),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromRGBO(0, 0, 0, 0.616),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(70, 69, 69, 1),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: isMessOwner
                  ? SafeArea(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics().applyTo(
                          const ClampingScrollPhysics(),
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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

                            ///NAME
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Name",
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: const Color.fromARGB(
                                    255,
                                    151,
                                    145,
                                    145,
                                  ),
                                ),
                                hintText: "Enter Name",
                                hintStyle: GoogleFonts.poppins(
                                  color: const Color.fromARGB(
                                    255,
                                    151,
                                    145,
                                    145,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                fillColor: Colors.amber,
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),

                            ///EMAIL
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),

                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: "Enter Email",
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: const Color.fromARGB(
                                    255,
                                    151,
                                    145,
                                    145,
                                  ),
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  color: const Color.fromARGB(
                                    255,
                                    151,
                                    145,
                                    145,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Password",
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),

                            TextField(
                              controller: passwordController,
                              obscureText:
                                  !passwordVisible, // true means password is hidden
                              decoration: InputDecoration(
                                hintText: "Enter Password",
                                hintStyle: GoogleFonts.poppins(
                                  color: const Color.fromARGB(
                                    255,
                                    151,
                                    145,
                                    145,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                fillColor: Colors.amber,
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                  child: Icon(
                                    !passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),

                            ///CONFIRM PASSWORD
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Confirm Password ",
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            TextField(
                              controller: confirmPasswordController,
                              obscureText:
                                  !confirmPasswordVisible, // true means password is hidden
                              decoration: InputDecoration(
                                hintText: "Confirm Password",
                                hintStyle: GoogleFonts.poppins(
                                  color: const Color.fromARGB(
                                    255,
                                    151,
                                    145,
                                    145,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                fillColor: Colors.amber,
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      confirmPasswordVisible =
                                          !confirmPasswordVisible;
                                    });
                                  },
                                  child: Icon(
                                    !confirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Mess Details",
                                  style: GoogleFonts.poppins(
                                    color: Colors.amber,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap:
                                  pickImage, // Tap to open image picker (camera/gallery)
                              child: Stack(
                                alignment: Alignment
                                    .bottomRight, // icon on bottom-right corner
                                children: [
                                  Container(
                                    height: 130,
                                    width: 130,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(255, 54, 71, 89),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: _selectedImage != null
                                          ? Image.file(
                                              _selectedImage!,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              "assets/Mess _image-1.jpeg",
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),

                                  // 📸 Small camera icon overlay
                                  Positioned(
                                    bottom: 5,
                                    right: 5,
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        color: Colors.orangeAccent,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(1, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ///MESS NAME
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Mess Name",
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),

                            TextField(
                              controller: messNameController,
                              decoration: InputDecoration(
                                hintText: "Enter mess name",

                                hintStyle: GoogleFonts.poppins(
                                  color: const Color.fromARGB(
                                    255,
                                    151,
                                    145,
                                    145,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),

                            // Mess Type
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Mess Type",
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: DropdownButtonFormField<String>(
                                value: selectedMessType,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.restaurant_menu,
                                    color: const Color.fromARGB(
                                      255,
                                      151,
                                      145,
                                      145,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                ),
                                dropdownColor: Colors.black,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                hint: Text(
                                  'Select Mess Type',
                                  style: GoogleFonts.poppins(
                                    color: const Color.fromARGB(
                                      255,
                                      151,
                                      145,
                                      145,
                                    ),
                                    fontSize: 20,
                                  ),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: 'Veg',
                                    child: Text(
                                      'Veg',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Non-Veg',
                                    child: Text(
                                      'Non-Veg',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Veg/Non-Veg',
                                    child: Text(
                                      'Veg/Non-Veg',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Jain',
                                    child: Text(
                                      'Jain',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedMessType = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Mess Open Time",
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),

                            TextField(
                              controller: messTimeController,
                              decoration: InputDecoration(
                                hintText: "Enter Mess Time",

                                hintStyle: GoogleFonts.poppins(
                                  color: const Color.fromARGB(
                                    255,
                                    151,
                                    145,
                                    145,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),

                            // Mess location
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Mess Location",
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),

                            TextField(
                              controller: messLocationController,
                              decoration: InputDecoration(
                                hintText: "Enter Mess Location",

                                hintStyle: GoogleFonts.poppins(
                                  color: const Color.fromARGB(
                                    255,
                                    151,
                                    145,
                                    145,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),

                            ///PASSWORD

                            ///MOBILE NUMBER
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Mobile ",
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            TextField(
                              controller: mobileController,
                              decoration: InputDecoration(
                                hintText: "Enter Mobile Number",
                                prefixIcon: Icon(
                                  Icons.call_outlined,
                                  color: const Color.fromARGB(
                                    255,
                                    151,
                                    145,
                                    145,
                                  ),
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  color: const Color.fromARGB(
                                    255,
                                    151,
                                    145,
                                    145,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                fillColor: Colors.amber,
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),

                            ///SIGN UP BUTTON
                            SizedBox(height: 80),
                            GestureDetector(
                              onTap: () async {
                                if (emailController.text.trim().isNotEmpty &&
                                    passwordController.text.trim().isNotEmpty) {
                                  try {
                                    UserCredential userCredentialObj =
                                        await _firebaseAuth
                                            .createUserWithEmailAndPassword(
                                              email: emailController.text,
                                              password: passwordController.text,
                                            );
                                    addOwnerProfileData();

                                    log("$userCredentialObj");

                                    CustomSnackbar().showCustomSnackbar(
                                      context,
                                      "Sign Up as Owner Successfully !",
                                      bgColor: Colors.lightGreen,
                                    );
                                    Navigator.of(context).pop();
                                  } on FirebaseAuthException catch (error) {
                                    if (error.code.toString() ==
                                        "Invalid Email") {
                                      CustomSnackbar().showCustomSnackbar(
                                        context,
                                        "Enter valid Email Id",
                                        bgColor: Colors.red,
                                      );
                                    } else {
                                      CustomSnackbar().showCustomSnackbar(
                                        context,
                                        error.message!,
                                        bgColor: Colors.red,
                                      );
                                    }
                                  }
                                } else {
                                  CustomSnackbar().showCustomSnackbar(
                                    context,
                                    "Enter Valid Data !",
                                    bgColor: Colors.red,
                                  );
                                }
                              },
                              child: Container(
                                height: 40,
                                width: 200,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromARGB(255, 229, 181, 6),
                                ),
                                child: Text(
                                  "Sign Up",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 35),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Signup for Mess Owner?",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isMessOwner
                                          ? isMessOwner = false
                                          : isMessOwner = true;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: 80,
                                    height:
                                        MediaQuery.of(context).size.width *
                                        0.02,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: isMessOwner
                                          ? Colors.greenAccent.shade400
                                          : Colors.grey,
                                    ),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: isMessOwner
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            isMessOwner ? "" : "",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account !",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),

                                ///SIGN IN BUTTON
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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

                          ///NAME
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Name",
                                style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: const Color.fromARGB(255, 151, 145, 145),
                              ),
                              hintText: "Enter Name",
                              hintStyle: GoogleFonts.poppins(
                                color: const Color.fromARGB(255, 151, 145, 145),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              fillColor: Colors.amber,
                            ),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),

                          ///EMAIL
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Email",
                                style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),

                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: "Enter Email",
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: const Color.fromARGB(255, 151, 145, 145),
                              ),
                              hintStyle: GoogleFonts.poppins(
                                color: const Color.fromARGB(255, 151, 145, 145),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),

                          ///PASSWORD
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Password",
                                style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),

                          TextField(
                            controller: passwordController,
                            obscureText:
                                passwordVisible, // hides text when true
                            decoration: InputDecoration(
                              hintText: "Enter Password",
                              hintStyle: GoogleFonts.poppins(
                                color: const Color.fromARGB(255, 151, 145, 145),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              fillColor: Colors.amber,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    passwordVisible =
                                        !passwordVisible; // toggle visibility
                                    // toggle visibility
                                  });
                                },
                                child: Icon(
                                  passwordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),

                          ///CONFIRM PASSWORD
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Confirm Password ",
                                style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          TextField(
                            controller: confirmPasswordController,
                            obscureText:
                                confirmPasswordVisible, // hides text when true
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              hintStyle: GoogleFonts.poppins(
                                color: const Color.fromARGB(255, 151, 145, 145),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              fillColor: Colors.amber,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    confirmPasswordVisible =
                                        !confirmPasswordVisible; // toggle visibility
                                  });
                                },
                                child: Icon(
                                  confirmPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),

                          ///MOBILE NUMBER
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Mobile ",
                                style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          TextField(
                            controller: mobileController,
                            decoration: InputDecoration(
                              hintText: "Enter Mobile Number",
                              prefixIcon: Icon(
                                Icons.call_outlined,
                                color: const Color.fromARGB(255, 151, 145, 145),
                              ),
                              hintStyle: GoogleFonts.poppins(
                                color: const Color.fromARGB(255, 151, 145, 145),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              fillColor: Colors.amber,
                            ),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Address ",
                                style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          TextField(
                            controller: userAddressController,
                            decoration: InputDecoration(
                              hintText: "Enter Your Address",
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: const Color.fromARGB(255, 151, 145, 145),
                              ),
                              hintStyle: GoogleFonts.poppins(
                                color: const Color.fromARGB(255, 151, 145, 145),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              fillColor: Colors.amber,
                            ),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),

                          ///SIGN UP BUTTON
                          SizedBox(height: 80),
                          GestureDetector(
                            onTap: () async {
                              if (emailController.text.trim().isNotEmpty &&
                                  passwordController.text.trim().isNotEmpty) {
                                try {
                                  UserCredential userCredentialObj =
                                      await _firebaseAuth
                                          .createUserWithEmailAndPassword(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          );
                                  addUserProfileData();

                                  log("$userCredentialObj");

                                  CustomSnackbar().showCustomSnackbar(
                                    context,
                                    "Sign Up as User Successfully !",
                                    bgColor: Colors.lightGreen,
                                  );
                                  Navigator.of(context).pop();
                                } on FirebaseAuthException catch (error) {
                                  if (error.code.toString() ==
                                      "Invalid Email") {
                                    CustomSnackbar().showCustomSnackbar(
                                      context,
                                      "Enter valid Email Id",
                                      bgColor: Colors.red,
                                    );
                                  } else {
                                    CustomSnackbar().showCustomSnackbar(
                                      context,
                                      error.message!,
                                      bgColor: Colors.red,
                                    );
                                  }
                                }
                              } else {
                                CustomSnackbar().showCustomSnackbar(
                                  context,
                                  "Enter Valid Data !",
                                  bgColor: Colors.red,
                                );
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 200,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 229, 181, 6),
                              ),
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 35),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Signup for Mess Owner?",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isMessOwner
                                        ? isMessOwner = false
                                        : isMessOwner = true;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 80,
                                  height: 40,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: isMessOwner
                                        ? Colors.greenAccent.shade400
                                        : Colors.grey,
                                  ),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: isMessOwner
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          isMessOwner ? "" : "",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account !",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),

                              ///SIGN IN BUTTON
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
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
      ),
    );
  }
}

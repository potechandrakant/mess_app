import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mess_app/model/messprofilemodel.dart';
import 'package:mess_app/views/admin/menu_upload_screen.dart';
import 'package:mess_app/views/common/custom_snackbar.dart';

class MessProfileController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addData({required Map<String, dynamic> data}) async {
    await _firestore.collection("mess_profiles").add(data);
  }
}

class MessProfilePage extends StatefulWidget {
  const MessProfilePage({super.key});

  State<MessProfilePage> createState() => _MessProfilePageState();
}

class _MessProfilePageState extends State<MessProfilePage> {
  TextEditingController messNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController timingsController = TextEditingController();
  TextEditingController menuController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final MessProfileController messProfileController = MessProfileController();
  List<MessProfileModel> messList = [];
  bool isLoading = false;

  Future<void> saveMessProfile() async {
    try {
      isLoading = true;
      setState(() {});

      // STORE DATA TO DATABASE
      Map<String, dynamic> data = {
        "messName": messNameController.text.trim(),
        "description": descriptionController.text.trim(),
        "timings": timingsController.text.trim(),
        "menu": menuController.text.trim(),
        "contactNumber": contactNumberController.text.trim(),
        "address": addressController.text.trim(),
        "createdAt": Timestamp.now(),
      };

      await messProfileController.addData(data: data);

      CustomSnackbar().showCustomSnackbar(
        context,
        "Mess Profile Saved Successfully",
        bgColor: Colors.green,
      );

      // Clear inputs
      messNameController.clear();
      descriptionController.clear();
      timingsController.clear();
      menuController.clear();
      contactNumberController.clear();
      addressController.clear();

      // Navigate to next page
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const UploadMenuPage()));
    } catch (e) {
      log("Error saving data: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(35, 22, 15, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(35, 22, 15, 1),
        title: Text(
          "Update Your Mess Profile",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
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
                        child: Image.asset(
                          "assets/Mess _image-1.jpeg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Upload Logo/Image",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Business Details
                    Container(
                      // height: 310,
                      width: MediaQuery.of(context).size.width - 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromARGB(141, 8, 50, 71),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Business Details",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 22),
                            Text(
                              "Mess Name",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: messNameController,
                              decoration: InputDecoration(
                                hintText: "Enter Mess Name",
                                filled: true,
                                fillColor: const Color.fromRGBO(35, 22, 15, 1),
                                suffixIcon: const Icon(
                                  Icons.restaurant_menu_outlined,
                                  size: 25,
                                  color: Color.fromARGB(255, 130, 127, 127),
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  color: const Color.fromARGB(
                                    255,
                                    130,
                                    127,
                                    127,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Description",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                hintText: "Enter Description",
                                filled: true,
                                fillColor: const Color.fromRGBO(35, 22, 15, 1),
                                suffixIcon: const Icon(
                                  Icons.description_outlined,
                                  size: 25,
                                  color: Color.fromARGB(255, 130, 127, 127),
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  color: const Color.fromARGB(
                                    255,
                                    130,
                                    127,
                                    127,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Operational Info
                    Container(
                      height: 310,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromARGB(141, 8, 50, 71),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Operational Info",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 22),
                            Text(
                              "Timings",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: timingsController,
                              decoration: InputDecoration(
                                hintText: "e.g., 8am-10am, 12pm-2pm, 7pm",
                                filled: true,
                                fillColor: const Color.fromRGBO(35, 22, 15, 1),
                                suffixIcon: const Icon(
                                  Icons.watch_later_outlined,
                                  size: 25,
                                  color: Color.fromARGB(255, 130, 127, 127),
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  color: const Color.fromARGB(
                                    255,
                                    130,
                                    127,
                                    127,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Menu",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: menuController,
                              decoration: InputDecoration(
                                hintText: "e.g., North Indian, South Indian",
                                filled: true,
                                fillColor: const Color.fromRGBO(35, 22, 15, 1),
                                suffixIcon: const Icon(
                                  Icons.menu_book_outlined,
                                  size: 25,
                                  color: Color.fromARGB(255, 130, 127, 127),
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  color: const Color.fromARGB(
                                    255,
                                    130,
                                    127,
                                    127,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Contact Info
                    Container(
                      height: 430,
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromARGB(141, 8, 50, 71),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Contact Info",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 22),
                            Text(
                              "Email",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: "Enter Email",
                                filled: true,
                                fillColor: const Color.fromRGBO(35, 22, 15, 1),
                                suffixIcon: const Icon(
                                  Icons.email_outlined,
                                  size: 25,
                                  color: Color.fromARGB(255, 130, 127, 127),
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  color: const Color.fromARGB(
                                    255,
                                    130,
                                    127,
                                    127,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Contact Number",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: contactNumberController,
                              decoration: InputDecoration(
                                hintText: "Enter Contact Number",
                                filled: true,
                                fillColor: const Color.fromRGBO(35, 22, 15, 1),
                                suffixIcon: const Icon(
                                  Icons.phone_outlined,
                                  size: 25,
                                  color: Color.fromARGB(255, 130, 127, 127),
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  color: const Color.fromARGB(
                                    255,
                                    130,
                                    127,
                                    127,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Address",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: addressController,
                              decoration: InputDecoration(
                                hintText: "Enter Address",
                                filled: true,
                                fillColor: const Color.fromRGBO(35, 22, 15, 1),
                                suffixIcon: const Icon(
                                  Icons.map_outlined,
                                  size: 25,
                                  color: Color.fromARGB(255, 130, 127, 127),
                                ),
                                hintStyle: GoogleFonts.poppins(
                                  color: const Color.fromARGB(
                                    255,
                                    130,
                                    127,
                                    127,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // if (messNameController.text.trim().isNotEmpty &&
                    //     descriptionController.text.trim().isNotEmpty &&
                    //     timingsController.text.trim().isNotEmpty &&
                    //     menuController.text.trim().isNotEmpty &&
                    //     contactNumberController.text.trim().isNotEmpty &&
                    //     addressController.text.trim().isNotEmpty) {
                    saveMessProfile();

                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text("Please fill all fields"),
                    //       backgroundColor: Colors.red,
                    //     ),
                    //   );
                    // }
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.89,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF8C3B), Color(0xFFFFD33B)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Update Mess Profile",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mess_app/controllers/currentUser.dart';
import 'package:mess_app/controllers/menu_upload_controller.dart';
import 'package:mess_app/views/common/custom_snackbar.dart';
import 'package:mess_app/views/common/owner_bottom_nav.dart';

class UploadMenuPage extends StatefulWidget {
  const UploadMenuPage({super.key});

  @override
  State<UploadMenuPage> createState() => _UploadMenuPageState();
}

class _UploadMenuPageState extends State<UploadMenuPage> {
  final FirebaseFirestore _firebaseFirestoreObj = FirebaseFirestore.instance;
  TextEditingController mealNameController = TextEditingController();
  TextEditingController mealDescController = TextEditingController();
  TextEditingController mealPriceController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final TextEditingController menuController = TextEditingController();

  // Future<void> _sendMenuToUsers() async {
  //   if (menuController.text.trim().isEmpty) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Please enter today's menu")));
  //     return;
  //   }

  //   try {
  //     await FirebaseFirestore.instance.collection('daily_menu').add({
  //       'menuText': menuController.text.trim(),
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Menu sent successfully to users!")),
  //     );

  //     menuController.clear();
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Error sending menu: $e")));
  //   }
  // }

  String currentMeal = "Breakfast";
  String? email;

  void loadUserData() async {
    final data = await Currentuser.getUserData();
    log("$data");
    setState(() {
      email = data['email'];
    });
  }

  @override
  void initState() {
    super.initState();

    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_rounded, size: 30, color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(35, 22, 15, 1),
        centerTitle: true,
        title: Text(
          "Upload Daily Menu",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(35, 22, 15, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Date picker
            Text(
              "Select Date",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                suffixIcon: Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
                hintText: "Enter Date",
                hintStyle: GoogleFonts.quicksand(
                  color: Colors.grey.shade400,
                  fontSize: 16,
                ),
              ),
              style: TextStyle(
                color: const Color.fromARGB(255, 250, 249, 249),
                fontSize: 20,
              ),
              onTap: () async {
                DateTime today = DateTime.now();
                dateController.text = DateFormat.yMMMMd().format(today);
              },
            ),
            const SizedBox(height: 20),

            //meal tabs in row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    currentMeal = "Breakfast";
                    setState(() {});
                  },
                  child: Text(
                    "Breakfast",
                    style: GoogleFonts.quicksand(
                      color: currentMeal == "Breakfast"
                          ? Color.fromRGBO(250, 111, 41, 1)
                          : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.17),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentMeal = "Lunch";
                    });
                  },
                  child: Text(
                    "Lunch",
                    style: GoogleFonts.quicksand(
                      color: currentMeal == "Lunch"
                          ? Color.fromRGBO(250, 111, 41, 1)
                          : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.17),

                // SizedBox(width: 80),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentMeal = "Dinner";
                    });
                  },
                  child: Text(
                    "Dinner",
                    style: GoogleFonts.quicksand(
                      color: currentMeal == "Dinner"
                          ? Color.fromRGBO(250, 111, 41, 1)
                          : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (currentMeal == "Breakfast")
              mealFields(
                mealNameController: breakfastNameController,
                mealDescController: breakfastDescController,
                mealPriceController: breakfastPriceController,
              ),
            if (currentMeal == "Lunch")
              mealFields(
                mealNameController: lunchNameController,
                mealDescController: lunchDescController,
                mealPriceController: lunchPriceController,
              ),
            if (currentMeal == "Dinner")
              mealFields(
                mealNameController: dinnerNameController,
                mealDescController: dinnerDescController,
                mealPriceController: dinnerPriceController,
              ),
          ],
        ),
      ),

      bottomNavigationBar: CurvedBottomNavOwner(currentIndex: 0),
    );
  }

  //Meal Fields
  Widget mealFields({
    required TextEditingController mealNameController,
    required TextEditingController mealDescController,
    required TextEditingController mealPriceController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Meal Name",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: mealNameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromRGBO(38, 28, 28, 1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),

            hintText: "e.g., Aloo Paratha",
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
          ),
          style: TextStyle(
            color: const Color.fromARGB(255, 250, 249, 249),
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Description",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: mealDescController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromRGBO(38, 28, 28, 1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            hintText: "e.g., Served with curd and pickle",
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
          ),
          maxLines: 4,
          style: TextStyle(
            color: const Color.fromARGB(255, 250, 249, 249),
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Price",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: mealPriceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromRGBO(38, 28, 28, 1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            hintText: "₹ 0.00",
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
          ),
          style: TextStyle(
            color: const Color.fromARGB(255, 250, 249, 249),
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 40),

        // Save Button
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.06,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(250, 111, 41, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              if (mealNameController.text.trim().isNotEmpty &&
                  mealDescController.text.trim().isNotEmpty &&
                  mealPriceController.text.trim().isNotEmpty) {
                //DATA

                Map<String, dynamic> data = {
                  "mealName": mealNameController.text,
                  "mealDescription": mealDescController.text,
                  "mealPrice": mealPriceController.text,
                  "mealDate": dateController.text,
                  "messEmail": email,
                };

                await _firebaseFirestoreObj
                    .collection(currentMeal)
                    .doc(email)
                    .set(data);
                log("Email: $email");

                //send to 'daily_menu' collection
                await FirebaseFirestore.instance.collection('daily_menu').add({
                  'mealName': mealNameController.text,
                  'mealDescription': mealDescController.text,
                  'mealPrice': mealPriceController.text,
                  'mealDate': dateController.text,
                  'timestamp': FieldValue.serverTimestamp(),
                });

                // Clear fields
                mealNameController.clear();
                mealDescController.clear();
                mealPriceController.clear();
                dateController.clear();

                CustomSnackbar().showCustomSnackbar(
                  context,
                  "Data Added Successfully !",
                  bgColor: Colors.green,
                );
                setState(() {});
              } else {
                CustomSnackbar().showCustomSnackbar(
                  context,
                  "Enter valid Data",
                  bgColor: Colors.red,
                );
              }
            },

            child: Text(
              "Send Menu",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

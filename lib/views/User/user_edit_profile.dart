import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mess_app/controllers/currentUser.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mess_app/views/common/custom_snackbar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> loadUserData() async {
    try {
      final data = await Currentuser.getUserData();
      final email = data['email'];
      userEmail = email;

      final doc = await FirebaseFirestore.instance
          .collection("CustomerProfileData")
          .doc(email)
          .get();

      if (doc.exists) {
        final profileData = doc.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = profileData['customerName'] ?? '';
          emailController.text = profileData['emailId'] ?? email;
          phoneController.text = profileData['mobileNo'] ?? '';
        });
      } else {
        setState(() {
          emailController.text = email;
        });
      }
    } catch (e) {
      debugPrint("Error loading profile data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load profile details."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> saveChanges() async {
    if (nameController.text.trim().isEmpty &&
        phoneController.text.trim().isEmpty &&
        emailController.text.trim().isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (userEmail == null) return;

    try {
      setState(() => isLoading = true);

      await FirebaseFirestore.instance
          .collection("CustomerProfileData")
          .doc(userEmail)
          .set({
            'customerName': nameController.text.trim(),
            'emailId': emailController.text.trim(),
            'mobileNo': phoneController.text.trim(),
          }, SetOptions(merge: true));

      setState(() => isLoading = false);

      CustomSnackbar().showCustomSnackbar(
        context,
        "Profile updated successfully!",
        bgColor: Colors.green,
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() => isLoading = false);
      CustomSnackbar().showCustomSnackbar(
        context,
        "Error saving changes: $e",
        bgColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(35, 22, 15, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(35, 22, 15, 1),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.quicksand(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// PROFILE IMAGE
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(120),
                        child: _selectedImage != null
                            ? Image.file(
                                _selectedImage!,
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/user_ Profile_img.jpeg",
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// NAME FIELD
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
                    hintText: "Enter name",
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 151, 145, 145),
                    ),
                    hintStyle: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 151, 145, 145),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 15),

                /// EMAIL FIELD (DISABLED)
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
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Enter Email",
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color.fromARGB(255, 151, 145, 145),
                    ),
                    hintStyle: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 151, 145, 145),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 15),

                /// PHONE FIELD
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Phone No",
                      style: GoogleFonts.poppins(
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Enter Phone Number",
                    prefixIcon: const Icon(
                      Icons.phone,
                      color: Color.fromARGB(255, 151, 145, 145),
                    ),
                    hintStyle: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 151, 145, 145),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 35),

                /// SAVE BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(182, 46, 114, 169),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: isLoading ? null : saveChanges,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Save Changes",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

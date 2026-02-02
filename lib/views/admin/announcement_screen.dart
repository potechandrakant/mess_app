import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mess_app/views/common/custom_snackbar.dart';
import 'package:mess_app/views/common/owner_bottom_nav.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController announcementController = TextEditingController();

  /// Send FCM push notification excluding owner
  Future<void> sendPushNotification(String title, String message) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();
      List<String> tokens = snapshot.docs
          .map((doc) => doc.data()['fcm_token'] as String?)
          .where((token) => token != null)
          .cast<String>()
          .toList();

      // Exclude owner token
      const String ownerToken =
          "OWNER_FCM_TOKEN_HERE"; // Replace with actual owner FCM token
      tokens.remove(ownerToken);

      if (tokens.isEmpty) return;

      const String serverKey = "YOUR_SERVER_KEY_HERE";

      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode({
          "registration_ids": tokens,
          "notification": {"title": title, "body": message},
          "priority": "high",
        }),
      );

      log("📣 FCM Response: ${response.body}");
    } catch (e) {
      log("❌ Push notification failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(35, 22, 15, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(35, 22, 15, 1),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Announcements",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.5),
          child: Divider(color: Color.fromARGB(255, 88, 55, 38), height: 0.5),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Enter title here…",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: const Color.fromRGBO(38, 28, 28, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 16),
              Text(
                "Message",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(38, 28, 28, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: announcementController,
                  maxLines: 22,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(12),
                    hintText: "Type your announcement here…",
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.065,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(250, 111, 41, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () async {
                    final title = titleController.text.trim();
                    final message = announcementController.text.trim();

                    if (title.isEmpty || message.isEmpty) {
                      CustomSnackbar().showCustomSnackbar(
                        context,
                        "Enter valid data",
                        bgColor: Colors.red,
                      );
                      return;
                    }

                    try {
                      await FirebaseFirestore.instance
                          .collection('announcements')
                          .add({
                            'title': title,
                            'message': message,
                            'timestamp': FieldValue.serverTimestamp(),
                          });

                      await sendPushNotification(title, message);

                      titleController.clear();
                      announcementController.clear();

                      CustomSnackbar().showCustomSnackbar(
                        context,
                        "Announcement sent successfully!",
                        bgColor: Colors.green,
                      );
                    } catch (e) {
                      CustomSnackbar().showCustomSnackbar(
                        context,
                        "Failed to send: $e",
                        bgColor: Colors.red,
                      );
                    }
                  },
                  child: Text(
                    "Send Announcement",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedBottomNavOwner(currentIndex: 2),
    );
  }
}

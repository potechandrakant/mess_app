import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mess_app/controllers/currentUser.dart';
import 'package:mess_app/views/common/user_bottom_nav.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QrScan extends StatefulWidget {
  const QrScan({super.key});

  @override
  State<QrScan> createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  MobileScannerController qrCodeScanner = MobileScannerController();
  bool isLoading = true;

  String? email;
  String currentUser = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
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

  Future<void> saveAttendance(Map<String, String> qrMap) async {
    if (currentUser.isEmpty) {
      log("Username empty — attendance not saved");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('Attendance').add({
        'username': currentUser,
        'email': email,
        'date': qrMap['date'] ?? 'Unknown',
        'time': qrMap['time'] ?? 'Unknown',
        'mealType': qrMap['type'] ?? 'Unknown',
        'status': 'Present',
        'scannedAt': Timestamp.now(),
      });
      log("Attendance saved for ${qrMap['date']}");
    } catch (e) {
      log("Error saving attendance: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(35, 22, 15, 1),
        title: Text(
          "Qr Scan",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.fromLTRB(50, 200, 50, 200),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: MobileScanner(
                  controller: MobileScannerController(
                    detectionSpeed: DetectionSpeed.noDuplicates,
                    returnImage: true,
                  ),
                  onDetect: (capture) async {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      final qrValue = barcode.rawValue;
                      if (qrValue != null) {
                        log("QR Data: $qrValue");

                        // Convert "{key: value}" string into a map
                        final cleaned = qrValue.replaceAll(
                          RegExp(r'[\{\}]'),
                          '',
                        );
                        final pairs = cleaned.split(', ');
                        Map<String, String> qrMap = {};
                        for (var p in pairs) {
                          var keyVal = p.split(': ');
                          if (keyVal.length == 2) {
                            qrMap[keyVal[0]] = keyVal[1];
                          }
                        }

                        await saveAttendance(qrMap);

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Attendance Marked!"),
                              content: Text(
                                "Name: $currentUser\n"
                                "Meal: ${qrMap['type']}\n"
                                "Date: ${qrMap['date']}\n"
                                "Time: ${qrMap['time']}",
                                style: const TextStyle(fontSize: 18),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ),
      bottomNavigationBar: CurvedBottomNav(currentIndex: 2),
    );
  }
}

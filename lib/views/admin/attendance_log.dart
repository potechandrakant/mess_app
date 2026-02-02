import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AttendanceLog extends StatefulWidget {
  const AttendanceLog({super.key});

  @override
  State<AttendanceLog> createState() => _AttendanceLogState();
}

class _AttendanceLogState extends State<AttendanceLog> {
  String selectedTab = "Breakfast";
  TextEditingController search = TextEditingController();

  List<Map<String, dynamic>> attendanceList = [];

  bool isLoading = true;
  String? email;

  @override
  void initState() {
    super.initState();
    //loadUserData();
    // fetchData();
    fetchAttendance();
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

  //sample student data
  // Map<String, List<Map<String, String>>> studentData = {
  //   "Breakfast": [
  //     {"name": "John", "time": "8:15 am"},
  //     {"name": "Bob", "time": "8:25"},
  //     {"name": "Jay", "time": "10:00 am"},
  //   ],
  //   "Lunch": [
  //     {"name": "Yash", "time": "8:15 am"},
  //     {"name": "Ram", "time": "8:15 am"},
  //     {"name": "ABC", "time": "8:15 am"},
  //   ],
  //   "Dinner": [
  //     {"name": "XYZ", "time": "8:15 am"},
  //     {"name": "PQR", "time": "8:15 am"},
  //     {"name": "LMN", "time": "8:15 am"},
  //   ],
  // };

  @override
  Widget build(BuildContext context) {
    // List<Map<String, String>> currentList = studentData[selectedTab] ?? [];
    return Scaffold(
      backgroundColor: const Color.fromRGBO(35, 22, 15, 1),
      body: Column(
        children: [
          SizedBox(height: 10),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         setState(() {
          //           selectedTab = "Breakfast";
          //         });
          //         log("breakfast clickd");
          //       },
          //       child: Text(
          //         "Breakfast",
          //         style: GoogleFonts.quicksand(
          //           fontSize: 18,
          //           fontWeight: FontWeight.w600,
          //           color: selectedTab == "Breakfast"
          //               ? Colors.deepOrangeAccent
          //               : Colors.white,
          //         ),
          //       ),
          //     ),
          //     GestureDetector(
          //       onTap: () {
          //         setState(() {
          //           selectedTab = "Lunch";
          //         });
          //         log("Lunch clicked");
          //       },
          //       child: Text(
          //         "Lunch",
          //         style: GoogleFonts.quicksand(
          //           fontSize: 18,
          //           fontWeight: FontWeight.w600,
          //           color: selectedTab == "Lunch"
          //               ? Colors.deepOrangeAccent
          //               : Colors.white,
          //         ),
          //       ),
          //     ),

          //     GestureDetector(
          //       onTap: () {
          //         setState(() {
          //           selectedTab = "Dinner";
          //         });
          //         log("Dinner clicked");
          //       },
          //       child: Text(
          //         "Dinner",
          //         style: GoogleFonts.quicksand(
          //           fontSize: 18,
          //           fontWeight: FontWeight.w600,
          //           color: selectedTab == "Dinner"
          //               ? Colors.deepOrangeAccent
          //               : Colors.white,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: search,
              decoration: InputDecoration(
                hintText: "Search by Name",

                filled: true,
                fillColor: const Color.fromARGB(255, 55, 52, 52),
                hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(style: BorderStyle.none, width: 0),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.white),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: attendanceList.length,
              itemBuilder: (context, index) {
                // String name = currentList[index]["name"]!;
                // String time = currentList[index]["time"]!;
                final record = attendanceList[index];

                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // color: Colors.white,
                      color: const Color.fromRGBO(61, 43, 35, 1),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(120),
                                //color: Color.fromRGBO(46, 17, 3, 0.907),
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(40),
                                child: Icon(Icons.person),
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              children: [
                                Text(
                                  record['mealType'] ?? 'Unknown Meal',
                                  style: GoogleFonts.quicksand(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Checked In at ${record['time']}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

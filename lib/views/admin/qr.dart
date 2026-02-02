import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mess_app/views/common/owner_bottom_nav.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  String? qrData;

  String selectedTab = "Breakfast";
  // TextEditingController search = TextEditingController();

  // //sample student data
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
    DateTime currentDate = DateTime.now(); //gives current date
    String formattedTime = DateFormat(
      'hh:mm a',
    ).format(currentDate).replaceAll(" ", "");
    String formatedDate = DateFormat(
      'dd MMMM yyyy',
    ).format(currentDate).replaceAll(" ", "-");

    // List<Map<String, String>> currentList = studentData[selectedTab] ?? [];
    // log("currentList:$currentList");

    final qrText = {
      "date": formatedDate,
      "time": formattedTime,
      "type": selectedTab,
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
    }.toString();

    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 22, 15, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 22, 15, 1),
        title: Text(
          "QR Attendence",
          style: GoogleFonts.quicksand(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          // style: TextStyle(
          //   fontSize: 20,fontWeight:FontWeight.bold),
        ),
        centerTitle: true,

        // leading: GestureDetector(
        //   onTap: () {
        //     Navigator.of(context).pop();
        //   },
        //   child: Icon(Icons.arrow_back),
        // ),

        //Adds line below appbar below order text
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            color: Color.fromRGBO(238, 231, 231, 1),
            height: 0.1,
          ),
        ),
      ),

      body: Column(
        children: [
          SizedBox(height: 10),
          Text(
            "The Mess Hall",
            style: GoogleFonts.quicksand(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = "Breakfast";
                  });
                  log("breakfast clickd");
                },
                child: Text(
                  "Breakfast",
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: selectedTab == "Breakfast"
                        ? Colors.deepOrangeAccent
                        : Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = "Lunch";
                  });
                  log("Lunch clicked");
                },
                child: Text(
                  "Lunch",
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: selectedTab == "Lunch"
                        ? Colors.deepOrangeAccent
                        : Colors.white,
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = "Dinner";
                  });
                  log("Dinner clicked");
                },
                child: Text(
                  "Dinner",
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: selectedTab == "Dinner"
                        ? Colors.deepOrangeAccent
                        : Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: 310,
            width: MediaQuery.of(context).size.width - 100,
            padding: EdgeInsets.fromLTRB(35, 30, 35, 20),
            decoration: BoxDecoration(
              color: Color.fromRGBO(38, 28, 28, 1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Stack(
              children: [
                // TextField(
                //   decoration: InputDecoration(
                //     prefixText: 'https://',
                //     suffixText: '.com',
                //   ),
                //   style: TextStyle(
                //     fontWeight: FontWeight.w500,
                //     color: Color.fromRGBO(0, 0, 0, 1),
                //     fontSize: 22,
                //   ),
                //   onSubmitted: (value) {
                //     setState(() {
                //       qrData = value;
                //     });
                //   },
                // ),
                // const SizedBox(height: 20),
                if (qrData != null)
                  PrettyQrView.data(
                    data: qrData!,
                    decoration: const PrettyQrDecoration(
                      shape: PrettyQrSquaresSymbol(color: Colors.white),
                      background: Colors.black,
                    ),
                  ),

                Positioned(
                  bottom: 0,
                  right: 15,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        qrData = qrText;
                        log(qrText);
                      });
                    },
                    child: Container(
                      // height: 60,
                      // width: 100,
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(250, 111, 41, 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "Generate QR",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 20.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // SizedBox(height: 10),
          // SizedBox(height: 10),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     controller: search,
          //     decoration: InputDecoration(
          //       hintText: "Search by Name",

          //       filled: true,
          //       fillColor: const Color.fromARGB(255, 55, 52, 52),
          //       hintStyle: TextStyle(fontSize: 20, color: Colors.white),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(20),
          //         borderSide: BorderSide(style: BorderStyle.none, width: 0),
          //       ),
          //       prefixIcon: Icon(Icons.search, color: Colors.white),
          //     ),
          //   ),
          // ),

          // Expanded(
          //   child: ListView.builder(
          //     itemCount: currentList.length,
          //     itemBuilder: (context, index) {
          //       String name = currentList[index]["name"]!;
          //       String time = currentList[index]["time"]!;
          //       return Padding(
          //         padding: const EdgeInsets.all(12),
          //         child: Container(
          //           padding: EdgeInsets.all(10),
          //           alignment: Alignment.center,
          //           height: 80,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(20),
          //             // color: Colors.white,
          //             color: Color.fromRGBO(46, 17, 3, 0.907),
          //           ),
          //           child: Column(
          //             children: [
          //               Row(
          //                 children: [
          //                   Container(
          //                     height: 50,
          //                     width: 50,
          //                     decoration: BoxDecoration(
          //                       borderRadius: BorderRadius.circular(120),
          //                       //color: Color.fromRGBO(46, 17, 3, 0.907),
          //                       color: Colors.white,
          //                     ),
          //                     child: ClipRRect(
          //                       borderRadius: BorderRadiusGeometry.circular(40),
          //                       child: Icon(Icons.person),
          //                     ),
          //                   ),
          //                   SizedBox(width: 20),
          //                   Column(
          //                     children: [
          //                       Text(
          //                         name,
          //                         style: GoogleFonts.quicksand(
          //                           fontSize: 18,
          //                           color: Colors.white,
          //                           fontWeight: FontWeight.bold,
          //                         ),
          //                       ),
          //                       Text(
          //                         "Checked In at $time",
          //                         style: TextStyle(
          //                           fontSize: 18,
          //                           color: Colors.white,
          //                           fontWeight: FontWeight.w400,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),

          // const SizedBox(height: 8),
        ],
      ),

      bottomNavigationBar: CurvedBottomNavOwner(currentIndex: 1),
    );
  }
}

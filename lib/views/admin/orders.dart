import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mess_app/views/common/owner_bottom_nav.dart';

class OrderManagement extends StatefulWidget {
  const OrderManagement({super.key});

  @override
  State<OrderManagement> createState() => __OrderManagementState();
}

class __OrderManagementState extends State<OrderManagement> {
  String selectedTab = "Pending";
  TextEditingController searchController = TextEditingController();

  List<Map> orderList = [
    {
      "name": "John Doe",
      "orderId": "1234",
      "items": "Thali(2) ,Extra Roti(4)",
      "price": "₹250",
      "time": "10 min ago",
    },
    {
      "name": "Jane",
      "orderId": "12346",
      "items": "Special Thali(2) ,Extra Roti(4)",
      "price": "₹350",
      "time": "15 min ago",
    },
    {
      "name": "Mauli",
      "orderId": "123",
      "items": "PuranPoli",
      "price": "₹100",
      "time": "5 min ago",
    },
    {
      "name": "Pote",
      "orderId": "125",
      "items": "Pizza",
      "price": "₹350",
      "time": "10 min ago",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 22, 15, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 22, 15, 1),

        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_rounded, size: 30, color: Colors.white),
        ),
        title: Text(
          "Orders",
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),

      body: Container(
        child: Column(
          children: [
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search by Name or Order #",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 55, 52, 52),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(style: BorderStyle.none, width: 0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                ),
              ),
            ),
            //),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = "Pending";
                    });
                    log("Pending clicked");
                  },
                  child: Text(
                    "Pending",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: selectedTab == "Pending"
                          ? Colors.deepOrangeAccent
                          : Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = "Accepted";
                    });
                    log("Accepted clicked");
                  },
                  child: Text(
                    "Accepted",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: selectedTab == "Accepted"
                          ? Colors.deepOrangeAccent
                          : Colors.white,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTab = "Completed";
                    });
                    log("Completed clicked");
                  },
                  child: Text(
                    "Completed",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: selectedTab == "Completed"
                          ? Colors.deepOrangeAccent
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  final order = orderList[index];
                  return Card(
                    color: Color.fromRGBO(46, 17, 3, 0.907),
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order["name"],
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                order["price"],
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order["orderId"],
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.deepOrangeAccent,
                                ),
                              ),
                              Text(
                                order["time"],
                                style: TextStyle(
                                  color: Colors.deepOrangeAccent,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            order["items"],
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      log("order accepted");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "Accept",
                                      style: GoogleFonts.poppins(
                                        fontSize: 19,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      log("oredr declined");
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      "Decline",
                                      style: GoogleFonts.poppins(
                                        fontSize: 19,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
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
          ],
        ),
      ),

      bottomNavigationBar: CurvedBottomNavOwner(currentIndex: 1),
    );
  }
}

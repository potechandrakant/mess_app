import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mess_app/views/common/user_bottom_nav.dart';

class UserOrderHistory extends StatefulWidget {
  const UserOrderHistory({super.key});

  @override
  State<UserOrderHistory> createState() => _UserOrderHistoryState();
}

class _UserOrderHistoryState extends State<UserOrderHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order History",
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
            fontSize: 25,
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
        ),

        ///AppBar background color
        backgroundColor: Color.fromRGBO(35, 22, 15, 1),
      ),

      ///Body background color
      backgroundColor: Color.fromRGBO(35, 22, 15, 1),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ///Search bar for searching the order history by using mess
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromRGBO(61, 43, 35, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(style: BorderStyle.none, width: 0),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 26,
                  color: Color.fromRGBO(131, 130, 130, 1),
                ),
                hintText: "Search by mess",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color.fromRGBO(131, 130, 130, 1),
                ),
              ),
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),

            const SizedBox(height: 15),

            ///Order history list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return orderHistoryCard();
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: CurvedBottomNav(currentIndex: 1),
    );
  }

  ///Order History Card
  Widget orderHistoryCard() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 18),
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromRGBO(61, 43, 35, 1),
        // border: Border.all(color: Color.fromRGBO(250, 195, 168, 1)),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 36, 33, 33).withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ///Order Icon
          Container(
            height: MediaQuery.of(context).size.height * 0.075,
            width: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color.fromRGBO(35, 22, 15, 1),
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 30,
              color: Color.fromRGBO(255, 140, 83, 1),
            ),
          ),

          const SizedBox(width: 15),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Order Mess Name
              Text(
                "The Healthy Hub",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
              ),

              ///Order date
              Text(
                "October 1, 2025",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Color.fromRGBO(163, 162, 162, 1),
                ),
              ),
            ],
          ),

          Spacer(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ///Order Price
              Row(
                children: [
                  Icon(
                    Icons.currency_rupee_rounded,
                    size: 17,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                  Text(
                    "15.50",
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ],
              ),

              ///Order Complete or Pending or Reject
              Text(
                "• Completed",
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color.fromRGBO(0, 255, 0, 1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

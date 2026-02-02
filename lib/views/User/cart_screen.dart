import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mess_app/views/User/cartitem.dart';
import 'package:mess_app/views/User/itemScreen.dart';
import 'package:mess_app/views/User/menu_screen.dart';
import 'package:mess_app/views/User/payment_method.dart';

class AddCart extends StatefulWidget {
  // List<Map<String, dynamic>> cartItems;
  const AddCart({super.key});

  @override
  State<AddCart> createState() => _AddCartState();
}

class _AddCartState extends State<AddCart> {
  // num subTotal = 0;

  // num subToatalVal() {
  //   num total = 0;
  //   for (int i = 0; i < widget.cartItems.length; i++) {
  //     total += num.parse(widget.cartItems[i]['mealPrice'].toString());
  //   }
  //   return total;
  // }

  List<int> itemCounts = [];
  List<Map<String, dynamic>> cartList = [];

  String? messStartDate;
  String? messEndDate;

  @override
  void initState() {
    super.initState();
    cartList = List<Map<String, dynamic>>.from(CartItem.cartItems);
    itemCounts = List.filled(cartList.length, 1);
    DateTime? now = DateTime.now();
    messStartDate = "${now.day}-${now.month}-${now.year}";
    DateTime? endDate = now.add(Duration(days: 30));
    messEndDate = "${endDate.day}-${endDate.month}-${endDate.year}";
    log("$messStartDate");
    log("$messEndDate");
  }

  num getSubTotal() {
    num subTotal = 0;
    for (int i = 0; i < cartList.length; i++) {
      final price = num.parse(cartList[i]['mealPrice'].toString());
      subTotal += price * CartItem.cartItems[i]['mealCount'];
    }
    return subTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 22, 15, 1),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            setState(() {
              P.mealCount = CartItem.cartItems.length;
            });
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => UserMenuScreen(
                  cardIndex: P.cardIndex!,
                  messEmail: P.messEmail!,
                ),
              ),
            );
          },
          child: Icon(Icons.arrow_back_rounded, size: 30, color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(35, 22, 15, 1),
        centerTitle: true,
        title: Text(
          "Your Cart",
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                // physics: NeverScrollableScrollPhysics(),
                itemCount: itemCount(),
                itemBuilder: (context, index) {
                  // subToatal += num.parse(widget.cartItems[index]['mealPrice']);
                  final item = cartList[index];
                  final price = item['mealPrice'];
                  return Padding(
                    padding: const EdgeInsets.all(7),
                    child: Container(
                      alignment: Alignment.center,
                      height: 80,
                      width: MediaQuery.of(context).size.width * 0.1,
                      margin: EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(28, 9, 1, 0.556),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  width:
                                      MediaQuery.of(context).size.width * 0.12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromARGB(
                                      255,
                                      192,
                                      181,
                                      181,
                                    ),
                                  ),
                                  child: Image.asset(
                                    "mess_app/assets/food.jpg",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${item['mealName']}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   "1 x ",

                                    //   style: GoogleFonts.poppins(
                                    //     fontSize: 15,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: const Color.fromARGB(
                                    //       210,
                                    //       231,
                                    //       119,
                                    //       50,
                                    //     ),
                                    //   ),
                                    // ),
                                    Icon(
                                      Icons.currency_rupee_rounded,
                                      size: 15,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                        210,
                                        231,
                                        119,
                                        50,
                                      ),
                                    ),
                                    Text(
                                      price.toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,

                                        color: const Color.fromARGB(
                                          210,
                                          231,
                                          119,
                                          50,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // SizedBox(width: 20),
                            Spacer(),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      log("${CartItem.cartItems}");
                                      if (CartItem
                                              .cartItems[index]['mealCount'] >=
                                          1) {
                                        CartItem
                                            .cartItems[index]['mealCount']--;
                                      } else if (CartItem
                                              .cartItems[index]['mealCount'] ==
                                          0) {
                                        CartItem.cartItems.removeAt(index);
                                        // itemCounts.removeAt(index);
                                      }
                                      P.mealCount = CartItem.cartItems.length;
                                    });
                                  },
                                  child: Icon(
                                    Icons.remove_circle_outline_sharp,
                                    size: 30,
                                    color: const Color.fromARGB(
                                      210,
                                      231,
                                      119,
                                      50,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "${CartItem.cartItems[index]['mealCount']}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      CartItem.cartItems[index]['mealCount']++;
                                    });
                                  },
                                  child: Icon(
                                    color: const Color.fromARGB(
                                      210,
                                      231,
                                      119,
                                      50,
                                    ),
                                    Icons.add_circle_outlined,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Subtotal",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.currency_rupee_sharp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  Text(
                    "${getSubTotal()}",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PaymentMethod(
                      totalCost: double.parse(getSubTotal().toString()),
                      startDate: messStartDate!,
                      endDate: messEndDate!,
                    ),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: const Color.fromARGB(230, 255, 119, 7),
                ),
                child: Text(
                  "Proceed to Payment",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int? itemCount() {
    int count = CartItem.cartItems.length;
    return count;
  }
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mess_app/controllers/todays_menu_controller.dart';
import 'package:mess_app/models/todays_menu_model.dart';
import 'package:mess_app/views/User/cart_screen.dart';
import 'package:mess_app/views/User/cartitem.dart';
import 'package:mess_app/views/User/itemScreen.dart';

class UserMenuScreen extends StatefulWidget {
  final int cardIndex;
  final String messEmail;

  const UserMenuScreen({
    super.key,
    required this.cardIndex,
    required this.messEmail,
  });

  @override
  State<UserMenuScreen> createState() => _UserMenuScreenState();
}

class _UserMenuScreenState extends State<UserMenuScreen> {
  int? itemCount;
  final TodaysMenuController todaysMenuControllerObj = TodaysMenuController();
  List<TodaysMenuModel> breakFastMenuList = [];
  List<TodaysMenuModel> dinnerMenuList = [];
  List<TodaysMenuModel> lunchMenuList = [];

  bool isLoading = true;

  bool isAddBreakFast = false;
  bool isAddDinner = false;
  bool isAddLunch = false;

  @override
  void initState() {
    super.initState();
    getTodaysMenuList();
  }

  Future<void> getTodaysMenuList() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("Breakfast")
          .get();

      final querySnapshotDinner = await FirebaseFirestore.instance
          .collection("Dinner")
          .get();

      final querySnapshotLunch = await FirebaseFirestore.instance
          .collection("Lunch")
          .get();

      final List<TodaysMenuModel> breakFastData = await querySnapshot.docs
          .map((doc) => TodaysMenuModel.fromMap(doc.data(), doc.id))
          .toList();

      final List<TodaysMenuModel> dinnerData = await querySnapshotDinner.docs
          .map((doc) => TodaysMenuModel.fromMap(doc.data(), doc.id))
          .toList();

      final List<TodaysMenuModel> lunchData = await querySnapshotLunch.docs
          .map((doc) => TodaysMenuModel.fromMap(doc.data(), doc.id))
          .toList();

      setState(() {
        mealCount();
        for (var item in breakFastData) {
          if (item.id == widget.messEmail) {
            breakFastMenuList.add(item);
          }
        }

        for (var item in lunchData) {
          if (item.id == widget.messEmail) {
            lunchMenuList.add(item);
          }
        }

        for (var item in dinnerData) {
          if (item.id == widget.messEmail) {
            dinnerMenuList.add(item);
          }
        }
        log("$breakFastMenuList");
        log("$dinnerMenuList");
        log("$lunchMenuList");
        //  userList = customerData;
        isLoading = false;
      });
    } catch (error) {
      log("Error fetching data : $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 22, 15, 1),

      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 45, 15, 10),
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.orange))
            : (breakFastMenuList.isEmpty &&
                  lunchMenuList.isEmpty &&
                  dinnerMenuList.isEmpty)
            ? Center(
                child: Text(
                  "No Menu Found",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
                ),
              )
            : Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back_sharp,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "30 August 2025",
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Today's Menu",
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),

                      const SizedBox(height: 15),

                      ///For Breakfast Menu list
                      Text(
                        "Breakfast",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),

                      const SizedBox(height: 12),

                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: breakFastMenuList.length,
                        itemBuilder: (context, int index) {
                          final menu = breakFastMenuList[index];
                          return breakFastItemCard(menu);
                        },
                      ),

                      const SizedBox(height: 20),

                      ///For Lunch Menu list
                      Text(
                        "Lunch",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),

                      const SizedBox(height: 12),

                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: lunchMenuList.length,
                        itemBuilder: (context, int index) {
                          final menu = lunchMenuList[index];
                          return lunchItemCard(menu);
                        },
                      ),

                      const SizedBox(height: 20),

                      ///For Dinner Menu list
                      Text(
                        "Dinner",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),

                      const SizedBox(height: 12),

                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: dinnerMenuList.length,
                        itemBuilder: (context, int index) {
                          final TodaysMenuModel menu = dinnerMenuList[index];
                          return dinnerItemCard(menu);
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),

      ///Floating action button for add to cart item list
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddCart();
              },
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFFF9F1C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 11,
                left: 11,
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 30,
                  color: Color.fromRGBO(0, 0, 0, 1),
                ),
              ),

              if (CartItem.cartItems.isNotEmpty)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    height: 18,
                    width: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(35, 22, 15, 1),
                    ),
                    child: Text(
                      "${mealCount()}",
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  //BreakFast Menu Card
  Widget breakFastItemCard(TodaysMenuModel menu) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(61, 43, 35, 1),
        borderRadius: BorderRadius.circular(15),
        // border: Border.all(color: Color.fromRGBO(250, 195, 168, 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.15),
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Food Item Price in rupees
                Row(
                  children: [
                    Icon(
                      Icons.currency_rupee_rounded,
                      size: 20,
                      color: Color.fromRGBO(170, 170, 170, 1),
                    ),
                    Text(
                      menu.mealPrice,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color.fromRGBO(170, 170, 170, 1),
                      ),
                    ),
                  ],
                ),

                ///Food item name
                Text(
                  menu.mealName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 21,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),

                ///Food item description
                Text(
                  menu.mealDesc,
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color.fromRGBO(170, 170, 170, 1),
                  ),
                ),

                const SizedBox(height: 10),

                ///Add button for add the item to the cart
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAddBreakFast
                          ? CartItem.cartItems.removeWhere(
                              (item) => item['mealName'] == menu.mealName,
                            )
                          : CartItem.cartItems.add({
                              'mealName': menu.mealName,
                              'mealPrice': menu.mealPrice,
                              'mealCount': 1,
                            });

                      isAddBreakFast = !isAddBreakFast;
                      log("Item added to cart: ${menu.mealName}");
                      log("Current cart items: ${CartItem.cartItems}");
                      P.mealCount = CartItem.cartItems.length;
                    });
                  },

                  child: Container(
                    height: 40,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(35, 22, 15, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      isAddBreakFast ? "Added" : "Add +",
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: isAddBreakFast
                            ? Color.fromRGBO(0, 255, 0, 1)
                            : Color.fromRGBO(243, 89, 89, 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),

          ///Food item image
          Container(
            height: 120,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.amber,
            ),
            // child: Image.network(
            //   "https://www.gohomely.com/assets/img/web/new_home_hero_img.png",
            // ),
          ),
        ],
      ),
    );
  }

  //Lunch Menu Card
  Widget lunchItemCard(TodaysMenuModel menu) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(61, 43, 35, 1),
        borderRadius: BorderRadius.circular(15),
        // border: Border.all(color: Color.fromRGBO(250, 195, 168, 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.15),
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Food Item Price in rupees
                Row(
                  children: [
                    Icon(
                      Icons.currency_rupee_rounded,
                      size: 20,
                      color: Color.fromRGBO(170, 170, 170, 1),
                    ),
                    Text(
                      menu.mealPrice,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color.fromRGBO(170, 170, 170, 1),
                      ),
                    ),
                  ],
                ),

                ///Food item name
                Text(
                  menu.mealName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 21,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),

                ///Food item description
                Text(
                  menu.mealDesc,
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color.fromRGBO(170, 170, 170, 1),
                  ),
                ),

                const SizedBox(height: 10),

                ///Add button for add the item to the cart
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAddLunch
                          ? CartItem.cartItems.removeWhere(
                              (item) => item['mealName'] == menu.mealName,
                            )
                          : CartItem.cartItems.add({
                              'mealName': menu.mealName,
                              'mealPrice': menu.mealPrice,
                              'mealCount': 1,
                            });

                      isAddLunch = !isAddLunch;
                      log("Item added to cart: ${menu.mealName}");
                      log("Current cart items: ${CartItem.cartItems}");
                      P.mealCount = CartItem.cartItems.length;
                    });
                  },

                  child: Container(
                    height: 40,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(35, 22, 15, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      isAddLunch ? "Added" : "Add +",
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: isAddLunch
                            ? Color.fromRGBO(0, 255, 0, 1)
                            : Color.fromRGBO(243, 89, 89, 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),

          ///Food item image
          Container(
            height: 120,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.amber,
            ),
            // child: Image.network(
            //   "https://www.gohomely.com/assets/img/web/new_home_hero_img.png",
            // ),
          ),
        ],
      ),
    );
  }

  //Dinner Menu Card
  Widget dinnerItemCard(TodaysMenuModel menu) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(5, 0, 5, 20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(61, 43, 35, 1),
        borderRadius: BorderRadius.circular(15),
        // border: Border.all(color: Color.fromRGBO(250, 195, 168, 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.15),
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Food Item Price in rupees
                Row(
                  children: [
                    Icon(
                      Icons.currency_rupee_rounded,
                      size: 20,
                      color: Color.fromRGBO(170, 170, 170, 1),
                    ),
                    Text(
                      menu.mealPrice,
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Color.fromRGBO(170, 170, 170, 1),
                      ),
                    ),
                  ],
                ),

                ///Food item name
                Text(
                  menu.mealName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 21,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),

                ///Food item description
                Text(
                  menu.mealDesc,
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Color.fromRGBO(170, 170, 170, 1),
                  ),
                ),

                const SizedBox(height: 10),

                ///Add button for add the item to the cart
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAddDinner
                          ? CartItem.cartItems.removeWhere(
                              (item) => item['mealName'] == menu.mealName,
                            )
                          : CartItem.cartItems.add({
                              'mealName': menu.mealName,
                              'mealPrice': menu.mealPrice,
                              'mealCount': 1,
                            });

                      isAddDinner = !isAddDinner;
                      log("Item added to cart: ${menu.mealName}");
                      log("Current cart items: ${CartItem.cartItems}");
                      P.mealCount = CartItem.cartItems.length;
                    });
                  },

                  child: Container(
                    height: 40,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(35, 22, 15, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      isAddDinner ? "Added" : "Add +",
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: isAddDinner
                            ? Color.fromRGBO(0, 255, 0, 1)
                            : Color.fromRGBO(243, 89, 89, 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),

          ///Food item image
          Container(
            height: 120,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.amber,
            ),
            // child: Image.network(
            //   "https://www.gohomely.com/assets/img/web/new_home_hero_img.png",
            // ),
          ),
        ],
      ),
    );
  }

  int? mealCount() {
    setState(() {
      P.mealCount = CartItem.cartItems.length;
    });
    return P.mealCount;
  }
}

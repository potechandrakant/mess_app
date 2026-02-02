import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mess_app/controllers/currentUser.dart';
import 'package:mess_app/controllers/messprofilecontroller.dart';
import 'package:mess_app/model/messprofilemodel.dart';
import 'package:mess_app/views/User/cartitem.dart';
import 'package:mess_app/views/User/itemScreen.dart';
import 'package:mess_app/views/User/menu_screen.dart';
import 'package:mess_app/views/User/user_subscription_screen.dart';
import 'package:mess_app/views/User/write_review.dart';

class MessInfoScreen extends StatefulWidget {
  final MessProfileModel mess;
  final int index;

  const MessInfoScreen({super.key, required this.mess, required this.index});

  @override
  State<MessInfoScreen> createState() => _MessInfoScreenState();
}

class _MessInfoScreenState extends State<MessInfoScreen> {
  final MessProfileController messProfileController = MessProfileController();
  List<MessProfileModel> messList = [];
  String name = "";
  bool isLoading = true;
  bool isFollowing = true;

  @override
  void initState() {
    super.initState();
    // fetchData();
    loadUserData();
    log("${widget.mess.messName}");
  }

  String? email;

  void loadUserData() async {
    final data = await Currentuser.getUserData();
    log("$data==========");
    setState(() {
      email = data['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(35, 22, 15, 1),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_outlined, size: 30, color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(35, 22, 15, 1),
        centerTitle: true,
        title: Text(
          "${widget.mess.messName}",
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,

                      child: Row(
                        children: [
                          Container(
                            height: 180,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 199, 198, 193),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                "assets/Mess _image-1.jpeg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 7),
                          Container(
                            height: 180,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 199, 198, 193),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                "assets/Mess Kitchen.jpeg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 7),
                          Container(
                            height: 180,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 199, 198, 193),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                "assets/Mess_menu.jpeg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 7),
                          Container(
                            height: 180,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 199, 198, 193),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                "assets/Food_images.jpeg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Implement follow functionality here
                            followButton();
                          },
                          child: Container(
                            height: 40,
                            width: 150,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF8C3B), // Orange shade
                                  Color(0xFFFFD33B), // Yellow shade
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: Text(
                              isFollowing ? "Following" : "Follow +",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),

                    SizedBox(height: 15),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(76, 71, 71, 0.932),
                          ),
                          child: Icon(
                            Icons.location_on_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 18),

                        // for (var mess in messList)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.mess.address}",
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(76, 71, 71, 0.932),
                          ),
                          child: Icon(
                            Icons.watch_later_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 18),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.mess.messTime}",
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(76, 71, 71, 0.932),
                          ),
                          child: Icon(
                            Icons.restaurant_menu_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 18),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.mess.messType}",
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(width: 10),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(76, 71, 71, 0.932),
                          ),
                          child: Icon(
                            Icons.call_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 18),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.mess.contactNumber}",
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    //Adds line below appbar below order text
                    PreferredSize(
                      preferredSize: Size.fromHeight(1),
                      child: Container(
                        color: const Color.fromARGB(255, 183, 176, 176),
                        height: 1,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Customer Reviews & Ratings",
                          style: GoogleFonts.quicksand(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star_border_outlined,
                              size: 22,
                              color: Colors.amber,
                            ),
                            Icon(
                              Icons.star_border_outlined,
                              size: 22,
                              color: Colors.amber,
                            ),
                            Icon(
                              Icons.star_border_outlined,
                              size: 22,
                              color: Colors.amber,
                            ),
                            Icon(
                              Icons.star_border_outlined,
                              size: 22,
                              color: Colors.amber,
                            ),
                            Icon(
                              Icons.star_border_outlined,
                              size: 22,
                              color: const Color.fromARGB(255, 199, 187, 187),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "4.0 (250 reviews)",
                              style: GoogleFonts.quicksand(
                                fontSize: 17,
                                color: const Color.fromARGB(255, 181, 168, 168),
                              ),
                            ),
                          ],
                        ),

                        // ✅ Fixed "Write Review" Button with gradient background
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const WriteReviewScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF2E7D32), // Deep green
                                    Color(0xFF66BB6A), // Light green
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 5,
                                    offset: const Offset(2, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                "Write Review",
                                style: GoogleFonts.quicksand(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(77, 155, 224, 168),
                            ),
                            child: Text(
                              "All",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          SizedBox(width: 13),
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(60, 197, 202, 198),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "5",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.star_border_outlined,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 13),
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(60, 197, 202, 198),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "4",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.star_border_outlined,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 13),
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(60, 197, 202, 198),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "3",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.star_border_outlined,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 13),
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(60, 197, 202, 198),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "2",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.star_border_outlined,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 13),
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(60, 197, 202, 198),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "1",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.star_border_outlined,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    ///COMMENT SECTION
                    SizedBox(height: 20),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(25),

                              child: Image.asset(
                                "assets/man _images.jpeg",
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Sarah J.",
                                      style: GoogleFonts.quicksand(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 110),
                                    Text(
                                      "2 days ago",
                                      style: GoogleFonts.quicksand(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 7),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_border_outlined,
                                      color: Colors.amber,
                                      size: 19,
                                    ),
                                    Icon(
                                      Icons.star_border_outlined,
                                      color: Colors.amber,
                                      size: 19,
                                    ),
                                    Icon(
                                      Icons.star_border_outlined,
                                      color: Colors.amber,
                                      size: 19,
                                    ),
                                    Icon(
                                      Icons.star_border_outlined,
                                      color: Colors.amber,
                                      size: 19,
                                    ),
                                    Icon(
                                      Icons.star_border_outlined,
                                      color: Colors.amber,
                                      size: 19,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 90,
                                  child: Text(
                                    "The food is absolutely delicious, feel just like home. Highly recommended !",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    ///Comment section
                  ],
                ),
              ),
            ),

            SizedBox(height: 12),

            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    CartItem.cartItems.clear();
                    P.cardIndex = widget.index;
                    P.messEmail = widget.mess.emailId!;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return UserMenuScreen(
                            cardIndex: widget.index,
                            messEmail: widget.mess.emailId!,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    // height: 50,
                    // width: 180,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF8C3B), // Orange shade
                          Color(0xFFFFD33B), // Yellow shade
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: SizedBox(
                      width: 110,
                      child: Text(
                        "View Today's menu",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return UserSubscriptionScreen();
                        },
                      ),
                    );
                  },
                  child: Container(
                    // height: 50,
                    // width: 180,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF8C3B), // Orange shade
                          Color(0xFFFFD33B), // Yellow shade
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: SizedBox(
                      width: 110,
                      child: Text(
                        "View Mess Plan",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
  }

  void followButton() {
    setState(() {
      if (isFollowing) {
        FirebaseFirestore.instance
            .collection('followers')
            .doc(widget.mess.emailId)
            .set({"emailId": email});
      } else {
        FirebaseFirestore.instance
            .collection('followers')
            .doc(widget.mess.emailId)
            .delete();
      }

      isFollowing = !isFollowing;

      log("followed");
    });
  }
}

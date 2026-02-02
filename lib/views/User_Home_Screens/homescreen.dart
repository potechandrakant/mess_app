import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mess_app/controllers/currentUser.dart';
import 'package:mess_app/controllers/messprofilecontroller.dart';
import 'package:mess_app/model/customerProfileModel.dart';
import 'package:mess_app/model/messprofilemodel.dart';
import 'package:mess_app/views/User_Home_Screens/mess_info_screen.dart';
import 'package:mess_app/views/common/user_bottom_nav.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final MessProfileController messProfileController = MessProfileController();

  List<MessProfileModel> messList = [];
  List<MessProfileModel> filteredMessList = [];
  String name = "";
  String? email;
  bool isLoading = true;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void _filterMesses() {
    String query = searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        filteredMessList = messList; // show all when empty
      } else {
        filteredMessList = messList.where((mess) {
          return mess.messName!.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> fetchData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("OwnerProfileData")
          .get();

      final List<MessProfileModel> allData = await querySnapshot.docs
          .map((doc) => MessProfileModel.fromMap(doc.data(), doc.id))
          .toList();

      // log("$customerData");
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("CustomerProfileData")
          .doc(email)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        name = data['customerName'];
        log("Name: ${data['customerName']}");
        log("Email: ${data['emailId']}");
      } else {
        log("Document not found!");
      }

      setState(() {
        messList = allData;
        filteredMessList = allData;
        isLoading = false;
      });
    } catch (error) {
      log("Error fetching data: $error");
    }
  }

  void loadUserData() async {
    final data = await Currentuser.getUserData();
    log("$data==========");
    email = data['email'];
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(35, 22, 15, 1),
      appBar: AppBar(
        title: Text(
          "Hi $name",
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(35, 22, 15, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
        child: Center(
          child: Column(
            children: [
              //Search Bar
              TextField(
                controller: searchController,
                textInputAction: TextInputAction.done, //Show “Done” on keyboard
                onSubmitted: (value) {
                  _filterMesses(); //Trigger search on Enter/Done press
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromRGBO(44, 42, 42, 1),
                  prefixIcon: const Icon(
                    Icons.search_outlined,
                    size: 28,
                    color: Color.fromRGBO(139, 128, 128, 1),
                  ),
                  hintText: "Search for messes",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 143, 136, 136),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Nearby Messes",
                    style: GoogleFonts.poppins(
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              //Mess list
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      )
                    : filteredMessList.isEmpty
                    ? Center(
                        child: Text(
                          "No Mess Found",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredMessList.length,
                        itemBuilder: (context, index) {
                          final mess = filteredMessList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MessInfoScreen(mess: mess, index: index),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              height: 160,
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color.fromRGBO(36, 34, 34, 0.523),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(57, 55, 55, 0.902),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          mess.messName ?? "",
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star_border_purple500,
                                            color: Color.fromARGB(
                                              255,
                                              174,
                                              119,
                                              15,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            "4.5",
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              color: const Color.fromARGB(
                                                255,
                                                174,
                                                119,
                                                15,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 7),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        253,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        "assets/food.jpg",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
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
      ),
      bottomNavigationBar: CurvedBottomNav(currentIndex: 0),
    );
  }

  // Widget _buildFilterButton(String title) {
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         filterContainer = title;
  //       });
  //     },
  //     child: Container(
  //       height: 55,
  //       width: 150,
  //       alignment: Alignment.center,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(35),
  //         color: filterContainer == title
  //             ? Color.fromRGBO(237, 76, 40, 0.844)
  //             : Color.fromRGBO(243, 243, 243, 1),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text(
  //             title,
  //             style: GoogleFonts.quicksand(
  //               color: filterContainer == title ? Colors.white : Colors.black,
  //               fontSize: 20,
  //               fontWeight: FontWeight.w800,
  //             ),
  //           ),
  //           SizedBox(width: 8),
  //           Icon(
  //             Icons.arrow_drop_down,
  //             size: 28,
  //             color: filterContainer == title ? Colors.white : Colors.black,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

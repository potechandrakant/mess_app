import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mess_app/views/common/user_bottom_nav.dart';

class UserNotificationScreen extends StatefulWidget {
  const UserNotificationScreen({super.key});

  @override
  State<UserNotificationScreen> createState() => _UserNotificationScreenState();
}

class _UserNotificationScreenState extends State<UserNotificationScreen> {
  String selectedFilter = "All";

  List<QueryDocumentSnapshot> announcements = [];
  List<QueryDocumentSnapshot> menus = [];
  List<QueryDocumentSnapshot> orders = []; // empty for now

  @override
  void initState() {
    super.initState();
    _fetchAnnouncements();
    _fetchMenus();
  }

  Future<void> _fetchAnnouncements() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('announcements')
        .orderBy('timestamp', descending: true)
        .get();
    setState(() {
      announcements = snapshot.docs;
    });
  }

  Future<void> _fetchMenus() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('daily_menu')
        .orderBy('mealDate', descending: true)
        .get();
    setState(() {
      menus = snapshot.docs;
    });
  }

  Future<Map<String, List<QueryDocumentSnapshot>>> _fetchAllData() async {
    final announcementsSnap = await FirebaseFirestore.instance
        .collection('announcements')
        .orderBy('timestamp', descending: true)
        .get();

    final menusSnap = await FirebaseFirestore.instance
        .collection('daily_menu')
        .orderBy('mealDate', descending: true)
        .get();

    return {'announcements': announcementsSnap.docs, 'menus': menusSnap.docs};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(35, 22, 15, 1),
        centerTitle: true,
        title: Text(
          "Notifications",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(35, 22, 15, 1),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton("All"),
                  const SizedBox(width: 10),
                  _buildFilterButton("Mess Menu"),
                  const SizedBox(width: 10),
                  _buildFilterButton("Announcements"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Notification list
            Expanded(
              child: FutureBuilder<Map<String, List<QueryDocumentSnapshot>>>(
                future: _fetchAllData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(
                      child: Text(
                        "No notifications yet",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  final dataMap = snapshot.data!;
                  final announcements = dataMap['announcements']!;
                  final menus = dataMap['menus']!;

                  List<QueryDocumentSnapshot> dataList;

                  if (selectedFilter == "Announcements") {
                    dataList = announcements;
                  } else if (selectedFilter == "Mess Menu") {
                    dataList = menus;
                  } else if (selectedFilter == "Orders") {
                    dataList = [];
                  } else {
                    dataList = [...announcements, ...menus];
                  }

                  if (dataList.isEmpty) {
                    return Center(
                      child: Text(
                        "No notifications found",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final data =
                          dataList[index].data() as Map<String, dynamic>;
                      final isMenu = data.containsKey('mealName');

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(38, 28, 28, 1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔹 Icon box
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(250, 111, 41, 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isMenu ? Icons.restaurant_menu : Icons.campaign,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 14),

                            // 🔹 Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isMenu
                                        ? "Today's Menu"
                                        : "New Announcement",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isMenu
                                        ? (data['mealDate'] ?? '')
                                        : (data['timestamp'] != null
                                              ? (data['timestamp'] as Timestamp)
                                                    .toDate()
                                                    .toString()
                                                    .substring(0, 16)
                                              : ''),
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey.shade400,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    isMenu
                                        ? "${data['mealName']} - ${data['mealDescription']} (₹${data['mealPrice']})"
                                        : (data['message'] ?? ''),
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey.shade300,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: CurvedBottomNav(currentIndex: 3),
    );
  }

  Widget _buildFilterButton(String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Color.fromRGBO(250, 111, 41, 1)
              : Color.fromRGBO(35, 22, 15, 1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : Colors.grey.shade400,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

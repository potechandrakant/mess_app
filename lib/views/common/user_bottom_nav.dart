import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/views/User/qr_scan.dart';
import 'package:mess_app/views/User/user_notification_screen.dart';
import 'package:mess_app/views/User/user_order_history.dart';
import 'package:mess_app/views/User_Home_Screens/homescreen.dart';
import 'package:mess_app/views/profile_screen.dart';

class CurvedBottomNav extends StatelessWidget {
  final int currentIndex;

  const CurvedBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      height: 65,
      index: currentIndex,
      backgroundColor: Colors.transparent,
      color: Color.fromRGBO(250, 111, 41, 1),
      buttonBackgroundColor: Colors.transparent,
      animationDuration: const Duration(milliseconds: 300),
      items: [
        Icon(Icons.home_outlined, size: 30, color: Colors.white), //Home
        Icon(
          Icons.receipt_long_outlined,
          size: 30,
          color: Colors.white,
        ), //Orders
        Icon(Icons.qr_code_scanner, size: 30, color: Colors.white), //scanner
        Icon(
          Icons.notifications_none,
          size: 30,
          color: Colors.white,
        ), //Notifications
        Icon(Icons.person_outline, size: 30, color: Colors.white), //Profile
      ],
      onTap: (index) {
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Homescreen(), //Home Screen
              ),
            );

          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const UserOrderHistory(), //Orders Screen
              ),
            );

          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const QrScan(), //Scanner
              ),
            );

          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const UserNotificationScreen(), //Notifications Screen
              ),
            );

          case 4:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(), // Profile Screen
              ),
            );
        }
      },
    );
  }
}

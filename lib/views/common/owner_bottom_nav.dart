import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/views/admin/announcement_screen.dart';
import 'package:mess_app/views/admin/menu_upload_screen.dart';
import 'package:mess_app/views/admin/messprofile.dart';
import 'package:mess_app/views/admin/orders.dart';
import 'package:mess_app/views/admin/qr.dart';

class CurvedBottomNavOwner extends StatelessWidget {
  final int currentIndex;

  const CurvedBottomNavOwner({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      backgroundColor: Colors.transparent,
      color: Color.fromRGBO(250, 111, 41, 1),
      buttonBackgroundColor: Colors.transparent,
      animationDuration: const Duration(milliseconds: 300),
      items: [
        Icon(
          Icons.restaurant_menu_rounded,
          size: 30,
          color: Colors.white,
        ), //Home
        // Icon(
        //   Icons.receipt_long_outlined,
        //   size: 30,
        //   color: Colors.white,
        // ), //Orders
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
                builder: (context) => const UploadMenuPage(), //Home Screen
              ),
            );

          // case 1:
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => const OrderManagement(), //Orders Screen
          //     ),
          //   );

          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const QRScreen(), //Scanner
              ),
            );

          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const AnnouncementsPage(), //Notifications Screen
              ),
            );

          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Messprofile(), // Profile Screen
              ),
            );
        }
      },
    );
  }
}

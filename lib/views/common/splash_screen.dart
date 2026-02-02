import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/views/Login_Screens/user_login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// ✅ Background message handler (runs when app is closed or background)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("📩 Background message received: ${message.notification?.title}");
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _isSmall = true;
  late AnimationController _textController;
  late Animation<Offset> _textOffsetAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initFirebaseMessaging();
  }

  // ✅ Initialize animation controller
  void _initializeAnimations() {
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _textOffsetAnimation =
        Tween<Offset>(begin: const Offset(-1.5, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutExpo),
        );

    _textController.forward();
  }

  // ✅ Initialize Firebase Messaging
  Future<void> _initFirebaseMessaging() async {
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request notification permission (for Android 13+ and iOS)
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission();
    log("🔔 Notification permission status: ${settings.authorizationStatus}");

    // Get FCM token
    String? token = await FirebaseMessaging.instance.getToken();
    log("🔑 FCM Token: $token");

    // Foreground message listener (when app is open)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("📬 Foreground message received: ${message.notification?.title}");
    });

    // Background tap listener (when notification tapped)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("📲 Notification tapped: ${message.notification?.title}");
    });

    // Navigate after delay
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserLoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(255, 107, 53, 1),
              Color.fromRGBO(255, 159, 28, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 🔹 Center Section
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder(
                    tween: Tween<double>(
                      begin: _isSmall ? 0.9 : 1.1,
                      end: _isSmall ? 1.1 : 0.9,
                    ),
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    onEnd: () => setState(() => _isSmall = !_isSmall),
                    builder: (context, scale, child) {
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 16,
                            spreadRadius: 1,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.restaurant_menu_rounded,
                          color: Colors.black,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      SlideTransition(
                        position: _textOffsetAnimation,
                        child: const Text(
                          'MealHub',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SlideTransition(
                        position: _textOffsetAnimation,
                        child: const Text(
                          'Mess & Tiffin made simple',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 🔹 Bottom tagline
            Positioned(
              left: 0,
              right: 0,
              bottom: 36,
              child: Text(
                'Fresh meals • Smart subscriptions • QR attendance',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.95),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

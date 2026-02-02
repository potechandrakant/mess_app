import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class Currentuser {
  ///SET USER DATA
  static Future<void> saveUserData(String email) async {
    log(email);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);

    await prefs.setBool('isLoggedIn', true);
  }

  ///GET USER DATA
  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // log("${prefs.getString('email')}");
    return {
      'email': prefs.getString('email'),

      'isLoggedIn': prefs.getBool("isLoggedIn") ?? false,
    };
    // print('Email: $email, Name: $name, Logged In: $isLoggedIn');
  }

  ///CLEAR USER DATA
  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // removes everything
    // or use remove('key') to remove a single key
  }
}

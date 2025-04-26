import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_box/Screens/Onboarding_screen/Splash_screen.dart';

void handleLogout(BuildContext context) async {
  // Clear any saved session or token
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('login_status', 'false');
  await prefs.clear();

  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => SplashScreen()),
  );
}

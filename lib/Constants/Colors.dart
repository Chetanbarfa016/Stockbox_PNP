import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';

// class ColorValues {
//   // static const Color Splash_bg_color1 = Color(0xFF1E2761);
//   // static const Color Splash_bg_color2 = Color(0xFF7A2048);
//
//   static const Color Splash_bg_color1 = Color(0xFFe8870d);
//   static const Color Splash_bg_color2 = Color(0xFF014399);
//   static const Color Splash_bg_color3 = Color(0xFFED2775);
//   static const Color Splash_bg_color4 = Color(0xffFF7448);
//
//   static Color line_color = const Color(0xff393737);
// }

class ColorValues {
  static Color Splash_bg_color1 = Color(0xFF1E2761);
  static Color Splash_bg_color2 = Color(0xFF7A2048);
  static Color Splash_bg_color3 = Color(0xFF1E2761);
  static Color Splash_bg_color4 = Color(0xFF1E2761);

  static void initializeFromApi(Map<String, dynamic> data) {
    Splash_bg_color1 = _parseColor(data['color1']) ?? Splash_bg_color1;
    Splash_bg_color2 = _parseColor(data['color2']) ?? Splash_bg_color2;
    Splash_bg_color3 = _parseColor(data['color3']) ?? Splash_bg_color3;
    Splash_bg_color4 = _parseColor(data['color4']) ?? Splash_bg_color4;
  }

  static Color? _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) return null;
    try {
      return Color(int.parse(colorString));
    } catch (e) {
      debugPrint('Error parsing color: $e');
      return null;
    }
  }
}
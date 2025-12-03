import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeHelper {
  static const String _themeKey = 'isDarkMode';
  
  // Get saved theme preference
  static Future<bool> getThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }
  
  // Save theme preference
  static Future<void> setThemePreference(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }
  
  // Telegram-style light theme
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF517DA2),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Color(0xFF517DA2),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 19,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: const Color(0xFF517DA2),
        secondary: const Color(0xFF6EC6E0),
        surface: Colors.white,
        background: Colors.white,
        error: const Color(0xFFE53935),
      ),
      cardColor: Colors.white,
      dividerColor: const Color(0xFFE0E0E0),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF517DA2),
      ),
    );
  }
  
  // Telegram-style dark theme
  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF2B5278),
      scaffoldBackgroundColor: const Color(0xFF0E1621),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Color(0xFF17212B),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 19,
        ),
      ),
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF2B5278),
        secondary: const Color(0xFF6EC6E0),
        surface: const Color(0xFF17212B),
        background: const Color(0xFF0E1621),
        error: const Color(0xFFE53935),
      ),
      cardColor: const Color(0xFF17212B),
      dividerColor: const Color(0xFF2B3842),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF2B5278),
      ),
    );
  }
  
  // Get message bubble colors based on theme
  static Color getSentMessageColor(bool isDark) {
    return isDark ? const Color(0xFF2B5278) : const Color(0xFFE1FFC7);
  }
  
  static Color getReceivedMessageColor(bool isDark) {
    return isDark ? const Color(0xFF17212B) : Colors.white;
  }
  
  static Color getMessageTextColor(bool isDark) {
    return isDark ? Colors.white : Colors.black87;
  }
  
  static Color getChatBackgroundColor(bool isDark) {
    return isDark ? const Color(0xFF0E1621) : const Color(0xFFE4DDD4);
  }
}

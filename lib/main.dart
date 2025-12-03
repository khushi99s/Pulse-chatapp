import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';

import 'firebase_options.dart';
import 'helper/theme_helper.dart';
import 'screens/splash_screen.dart';

//global object for accessing device screen size
late Size mq;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //enter full-screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await _initializeFirebase();

  //for setting orientation to portrait only
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final isDark = await ThemeHelper.getThemePreference();
    if (mounted) {
      setState(() {
        _isDarkMode = isDark;
      });
    }
  }

  void toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await ThemeHelper.setThemePreference(_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'We Chat',
        debugShowCheckedModeBanner: false,
        theme: ThemeHelper.getLightTheme(),
        darkTheme: ThemeHelper.getDarkTheme(),
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: SplashScreen(onThemeToggle: toggleTheme));
  }
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var result = await FlutterNotificationChannel().registerNotificationChannel(
      description: 'For Showing Message Notification',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats');

  log('\nNotification Channel Result: $result');
}

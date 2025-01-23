import 'package:flutter/material.dart';
// import 'dart:ui' as ui;
import 'package:spin/screens/homeScreen/home_screen.dart';

class AppConfig {
  final String appName;
  final String flavorName;
  final double appVersion;
  final String apiBaseUrl;

  AppConfig({
    required this.appName,
    required this.flavorName,
    required this.appVersion,
    required this.apiBaseUrl,
  });
}

void main() {
  const String baseUrl = String.fromEnvironment(
    'https://wheel.servey.tech',
    defaultValue: 'http://localhost',
  );
  AppConfig(
    appName: 'KINAN',
    flavorName: 'KINAN',
    appVersion: 1.0,
    apiBaseUrl: baseUrl,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KINAN',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
    );
  }
}

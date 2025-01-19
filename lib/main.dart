import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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
  const String baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost');
  dynamic configuredApp = AppConfig(
    appName: 'Flutter',
    flavorName: 'development',
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
      title: 'Weel of fortune',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
    );
  }
}

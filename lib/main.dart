import 'package:flutter/material.dart';
import 'package:neatflix/screens/screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Neatflix',
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.blue,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: LoginPage(),
    );
  }
}

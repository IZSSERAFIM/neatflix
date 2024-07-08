import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:neatflix/screens/screens.dart';
import 'package:neatflix/utils/utils.dart';

Future<void> login(
    BuildContext context, String username, String password) async {
  final url = Uri.parse("$baseURL/api/auth/login");
  print('URL: $url');
  print('Request body: ${jsonEncode({
        'username': username,
        'password': password
      })}');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Login successful: $data");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NavScreen(),
        ),
      );
    } else {
      print("Login failed: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }
  } catch (e, stacktrace) {
    print('Error: $e');
    print('Stacktrace: $stacktrace');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred')),
    );
  }
}

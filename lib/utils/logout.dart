import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:neatflix/utils/utils.dart';
import 'package:neatflix/user/user.dart';

Future<void> Logout(BuildContext context) async {
  final url = Uri.parse("$baseURL/api/auth/logout");
  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${token}',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logged out')),
      );
    } else {
      print("Failed to logout: ${response.body}");
      throw Exception("Failed to logout");
    }
  } catch (e, stacktrace) {
    print('Error: $e');
    print('Stacktrace: $stacktrace');
    throw Exception("Error logging out: $e");
  }
}

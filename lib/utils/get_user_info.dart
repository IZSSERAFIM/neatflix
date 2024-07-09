import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:neatflix/user/user_info.dart';
import 'package:neatflix/utils/utils.dart';
import 'package:neatflix/user/user.dart';

Future<void> getUserInfo(BuildContext context) async {
  final url = Uri.parse("$baseURL/api/auth/user");
  try {
    final response = await http.get(
      url,
      headers: token,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("User info: $data");
      userName = data['username'];
      userEmail = data['email'];
      userAvatar = data['avatar'];
    } else {
      print("Failed to get user info: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get user info')),
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

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:neatflix/utils/utils.dart';
import 'package:neatflix/user/user.dart';

Future<void> updateUserInfo(
  BuildContext context, {
  required String newName,
  required String newEmail,
}) async {
  final url = Uri.parse("$baseURL/api/user/reviseUserInfo");
  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nickName': newName,
        'userEmail': newEmail,
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    } else {
      print("Failed to update profile: ${response.body}");
      throw Exception("Failed to update profile");
    }
  } catch (e, stacktrace) {
    print('Error: $e');
    print('Stacktrace: $stacktrace');
    throw Exception("Error updating profile: $e");
  }
}

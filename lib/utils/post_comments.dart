import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:neatflix/utils/utils.dart';
import 'package:neatflix/user/user.dart';

Future<void> postComments(BuildContext context, value) async {
  final url = Uri.parse("$baseURL/api/comment/postComments");
  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        value,
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comment posted')),
      );
    } else {
      print("Failed to get contents: ${response.body}");
      throw Exception("Failed to post comment");
    }
  } catch (e, stacktrace) {
    print('Error: $e');
    print('Stacktrace: $stacktrace');
    throw Exception("Error post comments: $e");
  }
}

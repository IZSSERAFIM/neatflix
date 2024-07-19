import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:neatflix/models/comment_model.dart';
import 'dart:convert';
import 'package:neatflix/utils/utils.dart';
import 'package:neatflix/user/user.dart';
import 'package:neatflix/models/models.dart';

Future<void> postComments(
  BuildContext context,
  String message,
  int videoId,
  String date,
) async {
  final url = Uri.parse("$baseURL/api/comment/addComment");
  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'message': message,
        'videoId': videoId,
        'date': date,
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

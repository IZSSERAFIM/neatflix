import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:neatflix/utils/utils.dart';

Future<void> getContents(BuildContext context) async {
  final url = Uri.parse("$baseURL/api/video/all");
  print('URL: $url');

  try {
    final response = await http.get(url);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Contents: $data");
    } else {
      print("Failed to get contents: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get contents')),
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

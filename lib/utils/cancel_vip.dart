import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:neatflix/utils/utils.dart';
import 'package:neatflix/user/user.dart';
import 'package:neatflix/user/user_info.dart';

Future<void> cancelVip(BuildContext context) async {
  final url = Uri.parse("$baseURL/api/user/cancelVIP");
  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      isVip = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('VIP status updated')),
      );
    } else {
      print("Failed to get contents: ${response.body}");
      throw Exception("Failed to load content");
    }
  } catch (e, stacktrace) {
    print('Error: $e');
    print('Stacktrace: $stacktrace');
    throw Exception("Error fetching content: $e");
  }
}

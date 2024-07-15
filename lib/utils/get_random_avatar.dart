import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:neatflix/utils/utils.dart';
import 'package:neatflix/user/user.dart';

Future<String> getRandomAvatar() async {
  final url = Uri.parse("$baseURL/api/user/randomAvatar");
  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      print("Failed to get avatar: ${response.body}");
      throw Exception("Failed to load avatar");
    }
  } catch (e, stacktrace) {
    print('Error: $e');
    print('Stacktrace: $stacktrace');
    throw Exception("Error fetching avatar: $e");
  }
}

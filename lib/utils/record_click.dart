import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:neatflix/utils/utils.dart';
import 'package:neatflix/user/user.dart';

Future<void> recordClick(int videoId) async {
  final url = Uri.parse("$baseURL/api/video/recordClick");
  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id': videoId,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      print("Contents: $data");
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

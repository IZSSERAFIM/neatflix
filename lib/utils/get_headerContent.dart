import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:neatflix/models/content_model.dart';
import 'package:neatflix/utils/utils.dart';

Future<Content> getHeader() async {
  final url = Uri.parse("$baseURL/api/video/header");
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Contents: $data");
      return Content.fromJson(data);
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

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:neatflix/models/content_model.dart';
import 'package:neatflix/utils/utils.dart';

Future<List<Content>> Search(String text) async {
  final url = Uri.parse("$baseURL/api/video/search");
  try {
    final response = await http.post(
      url,
      body: {"title": text},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      print("Contents: $data");
      return data.map((content) => Content.fromJson(content)).toList();
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

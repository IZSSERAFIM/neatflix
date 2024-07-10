import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:neatflix/models/content_model.dart';
import 'package:neatflix/utils/utils.dart';

Future<List<Content>> searchCategory(String text) async {
  if (text.isEmpty) {
    return [];
  }
  final url = Uri.parse("$baseURL/api/video/category");
  try {
    final response = await http.post(
      url,
      body: {"categoryName": text},
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

Future<List<String>> getCategories() async {
  final url = Uri.parse("$baseURL/api/video/category");
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      print("Categories: $data");
      return data
          .map((category) => category['categoryName'].toString())
          .toList();
    } else {
      print("Failed to get categories: ${response.body}");
      throw Exception("Failed to load categories");
    }
  } catch (e, stacktrace) {
    print('Error: $e');
    print('Stacktrace: $stacktrace');
    throw Exception("Error fetching categories: $e");
  }
}

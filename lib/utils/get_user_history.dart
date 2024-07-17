import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:neatflix/models/content_model.dart';
import 'package:neatflix/utils/utils.dart';
import 'package:neatflix/user/user.dart';

Future<List<Content>> getUserHistory() async {
  final url = Uri.parse("$baseURL/api/video/historyVideos");
  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${token}',
        "Content-Type": "application/json"
      },
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

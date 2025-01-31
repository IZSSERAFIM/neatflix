import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:neatflix/utils/utils.dart';

Future<List<dynamic>> getComments(int videoId, int page) async {
  final url = Uri.parse("$baseURL/api/comment/getComments");
  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "videoId": videoId,
        "page": page,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      print("Comments: $data");
      return data;
    } else {
      print("Failed to get contents: ${response.body}");
      throw Exception("Failed to load comments");
    }
  } catch (e, stacktrace) {
    print('Error: $e');
    print('Stacktrace: $stacktrace');
    throw Exception("Error fetching comments: $e");
  }
}

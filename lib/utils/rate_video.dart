import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:neatflix/utils/utils.dart';

Future<void> rateVideo(int videoId, double rating) async {
  final url = Uri.parse("$baseURL/api/video/rateVideo");

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "id": videoId,
        "rating": rating,
      }),
    );
    if (response.statusCode == 200) {
      print("Video rated successfully");
    } else {
      print("Failed to rate video: ${response.body}");
      throw Exception("Failed to rate video");
    }
  } catch (e, stacktrace) {
    print('Error: $e');
    print('Stacktrace: $stacktrace');
    throw Exception("Error rating video: $e");
  }
}

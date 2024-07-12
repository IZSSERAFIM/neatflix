import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:neatflix/user/user_info.dart';
import 'package:neatflix/utils/utils.dart';
import 'package:neatflix/user/user.dart';

Future<void> getUserInfo() async {
  final url = Uri.parse("$baseURL/api/user/userInfo");
  try {
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${token}',
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("User info: $data");
      userName = data['nickName'];
      userEmail = data['userEmail'];
      userAvatar = data['userAvatar'];
    } else {
      print("Failed to get user info: ${response.body}");
    }
  } catch (e, stacktrace) {
    print('Error: $e');
    print('Stacktrace: $stacktrace');
  }
}

import 'package:flutter/material.dart';

class Comment {
  final String name;
  final String pic;
  final String? message;
  final String? date;

  const Comment({
    required this.name,
    required this.pic,
    required this.message,
    required this.date,
  });

  factory Comment.fromJson(Map<String, dynamic> data) {
    return Comment(
      name: data['name'],
      pic: data['pic'],
      message: data['message'],
      date: data['date'].toString().substring(0, 19).replaceAll('T', ' '),
    );
  }
}

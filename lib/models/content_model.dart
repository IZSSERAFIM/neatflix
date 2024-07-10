import 'package:flutter/material.dart';

class Content {
  final String name;
  final String imageUrl;
  final String? titleImageUrl;
  final String? videoUrl;
  final String? description;
  final Color? color;
  final int? id;

  const Content({
    required this.name,
    required this.imageUrl,
    this.titleImageUrl,
    this.videoUrl,
    this.description,
    this.color,
    this.id,
  });

  factory Content.fromJson(Map<String, dynamic> data) {
    return Content(
      name: data['name'],
      imageUrl: data['imageUrl'],
      titleImageUrl: data['titleImageUrl'],
      videoUrl: data['videoUrl'],
      description: data['description'],
      color: _parseColor(data['color']),
      id: data['id'],
    );
  }

  static Color _parseColor(String? colorString) {
    if (colorString == null || colorString.isEmpty) {
      return Colors.transparent; // 或者你可以返回一个默认颜色
    }
    if (colorString.startsWith('#')) {
      colorString = colorString.substring(1);
    }
    // 将颜色字符串解析为整数
    return Color(int.parse(colorString, radix: 16) + 0xFF000000);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Content otherContent = other as Content;
    return name == otherContent.name &&
        imageUrl == otherContent.imageUrl &&
        titleImageUrl == otherContent.titleImageUrl &&
        videoUrl == otherContent.videoUrl &&
        description == otherContent.description &&
        color == otherContent.color &&
        id == otherContent.id;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      imageUrl,
      titleImageUrl,
      videoUrl,
      description,
      color,
      id,
    );
  }
}

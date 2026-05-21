import 'package:flutter/material.dart';

class BannerItem {
  final String title;
  final String description;
  final Color color;
  final IconData icon;
  final String? imageUrl;

  const BannerItem({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
    this.imageUrl,
  });
}

class DiagnoseItem {
  final String id;
  final String diseaseName;
  final String imagePath;
  final double confidence;
  final DateTime date;
  final String severity;

  const DiagnoseItem({
    required this.id,
    required this.diseaseName,
    required this.imagePath,
    required this.confidence,
    required this.date,
    required this.severity,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'diseaseName': diseaseName,
    'imagePath': imagePath,
    'confidence': confidence,
    'date': date.toIso8601String(),
    'severity': severity,
  };

  factory DiagnoseItem.fromJson(Map<String, dynamic> json) {
    return DiagnoseItem(
      id: json['id'] as String,
      diseaseName: json['diseaseName'] as String,
      imagePath: json['imagePath'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      severity: json['severity'] as String,
    );
  }
}
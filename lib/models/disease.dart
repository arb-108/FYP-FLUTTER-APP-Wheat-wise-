import 'package:flutter/material.dart';

enum Severity { low, medium, high }

class Disease {
  final String name;
  final String description;
  final Severity severity;
  final String imagePath;

  const Disease({
    required this.name,
    required this.description,
    required this.severity,
    required this.imagePath,
  });

  Color get severityColor {
    switch (severity) {
      case Severity.low:
        return const Color(0xFF4CAF50);
      case Severity.medium:
        return const Color(0xFFFFA726);
      case Severity.high:
        return const Color(0xFFEF5350);
    }
  }

  String get severityLabel {
    switch (severity) {
      case Severity.low:
        return 'Low';
      case Severity.medium:
        return 'Medium';
      case Severity.high:
        return 'High';
    }
  }
}

/// Matches the 14 labels from labels.txt
class DiseaseData {
  static const List<Disease> all = [
    Disease(
      name: 'Aphid',
      description: 'Small sap-sucking insects that cause leaf curling, stunting, and can transmit viruses.',
      severity: Severity.medium,
      imagePath: 'assets/img/aphid.png',
    ),
    Disease(
      name: 'Black Rust',
      description: 'Caused by Puccinia graminis. Produces black pustules on stems and leaves, severely affecting yield.',
      severity: Severity.high,
      imagePath: 'assets/img/black_rust.png',
    ),
    Disease(
      name: 'Blast',
      description: 'Fungal disease causing diamond-shaped lesions on leaves and can affect grain heads.',
      severity: Severity.high,
      imagePath: 'assets/img/blast.png',
    ),
    Disease(
      name: 'Brown Rust',
      description: 'Caused by Puccinia triticina. Shows as orange-brown pustules on leaves.',
      severity: Severity.high,
      imagePath: 'assets/img/brown_rust.png',
    ),
    Disease(
      name: 'Common Root Rot',
      description: 'Soil-borne disease causing browning and decay of roots, leading to poor plant vigor.',
      severity: Severity.high,
      imagePath: 'assets/img/common_root_rot.png',
    ),
    Disease(
      name: 'Fusarium Head Blight',
      description: 'Caused by Fusarium species. Bleaches spikelets and produces harmful mycotoxins.',
      severity: Severity.high,
      imagePath: 'assets/img/fusarium_head_blight.png',
    ),
    Disease(
      name: 'Healthy',
      description: 'No disease detected. The plant is in good condition.',
      severity: Severity.low,
      imagePath: 'assets/img/healthy.png',
    ),
    Disease(
      name: 'Leaf Blight',
      description: 'Causes necrotic lesions on leaves, reducing photosynthetic capacity.',
      severity: Severity.medium,
      imagePath: 'assets/img/leaf_blight.png',
    ),
    Disease(
      name: 'Mildew',
      description: 'Fungal disease causing white or gray powdery coating on leaf surfaces.',
      severity: Severity.medium,
      imagePath: 'assets/img/mildew.png',
    ),
    Disease(
      name: 'Mite',
      description: 'Tiny arachnids that feed on plant tissue, causing stippling and discoloration.',
      severity: Severity.low,
      imagePath: 'assets/img/mite.png',
    ),
    Disease(
      name: 'Septoria',
      description: 'Caused by Zymoseptoria tritici. Produces tan lesions with dark pycnidia.',
      severity: Severity.medium,
      imagePath: 'assets/img/septoria.png',
    ),
    Disease(
      name: 'Smut',
      description: 'Fungal disease replacing grain with masses of dark spores, causing foul odor.',
      severity: Severity.medium,
      imagePath: 'assets/img/smut.png',
    ),
    Disease(
      name: 'Stem Fly',
      description: 'Insect pest whose larvae bore into stems, causing wilting and lodging.',
      severity: Severity.medium,
      imagePath: 'assets/img/stem_fly.png',
    ),
    Disease(
      name: 'Tan Spot',
      description: 'Caused by Pyrenophora tritici-repentis. Tan oval lesions with yellow halos.',
      severity: Severity.medium,
      imagePath: 'assets/img/tan_spot.png',
    ),
  ];
  static Disease getByName(String name) {
    final disease = all.firstWhere(
          (disease) => disease.name.toLowerCase() == name.toLowerCase(),
      orElse: () => throw Exception('Disease not found: $name'),
    );
    return disease;
  }
}
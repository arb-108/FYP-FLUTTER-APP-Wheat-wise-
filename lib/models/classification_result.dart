class ClassificationResult {
  final String label;
  final double confidence;
  final DateTime timestamp;
  final String? imagePath;

  ClassificationResult({
    required this.label,
    required this.confidence,
    DateTime? timestamp,
    this.imagePath,
  }) : timestamp = timestamp ?? DateTime.now();

  // Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'label': label,
    'confidence': confidence,
    'timestamp': timestamp.toIso8601String(),
    'imagePath': imagePath,
  };

  // Create from JSON
  factory ClassificationResult.fromJson(Map<String, dynamic> json) {
    return ClassificationResult(
      label: json['label'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      imagePath: json['imagePath'] as String?,
    );
  }

  // Copy with method for updates
  ClassificationResult copyWith({
    String? label,
    double? confidence,
    DateTime? timestamp,
    String? imagePath,
  }) {
    return ClassificationResult(
      label: label ?? this.label,
      confidence: confidence ?? this.confidence,
      timestamp: timestamp ?? this.timestamp,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
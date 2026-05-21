class AppConstants {
  // Model paths
  static const String modelPath = 'assets/model/wheats_model.tflite';
  static const String labelsPath = 'assets/model/labels.txt';

  // Image settings
  static const int imageSize = 224;
  static const int imageChannels = 3;

  // Classification thresholds
  static const double confidenceThreshold = 0.5;
  static const double highConfidenceThreshold = 0.8;

  // UI constants
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 12.0;
  static const double defaultPadding = 16.0;

  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);

  // History settings
  static const int maxHistoryItems = 50;
  static const int recentItemsCount = 3;

  // Banner settings
  static const Duration bannerAutoPlayDuration = Duration(seconds: 3);
  static const double bannerHeight = 180.0;

  // App info
  static const String appName = 'Plantia';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Plant Disease Detection App';
}
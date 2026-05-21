import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/classification_result.dart';
import '../utils/app_constants.dart';

class ClassifierService {
  Interpreter? _interpreter;
  List<String>? _labels;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // Initialize the TFLite model
  Future<void> initialize() async {
    try {
      // Load model
      _interpreter = await Interpreter.fromAsset(
        AppConstants.modelPath,
        options: InterpreterOptions()..threads = 4,
      );

      // Load labels
      final labelData = await rootBundle.loadString(AppConstants.labelsPath);
      _labels = labelData
          .split('\n')
          .map((label) => label.trim())
          .where((label) => label.isNotEmpty)
          .toList();

      _isInitialized = true;
      print('✅ Model loaded successfully');
      print('📊 Labels: ${_labels?.length}');
    } catch (e) {
      _isInitialized = false;
      print('❌ Error loading model: $e');
      throw Exception('Failed to load model: $e');
    }
  }

  // Classify image
  Future<ClassificationResult> classifyImage(File imageFile) async {
    if (!_isInitialized || _interpreter == null || _labels == null) {
      throw Exception('Classifier not initialized');
    }

    try {
      // Preprocess image
      final input = await _preprocessImage(imageFile);

      // Get output shape
      final outputShape = _interpreter!.getOutputTensor(0).shape;

      // Prepare output buffer
      final output = List.generate(
        outputShape[1],
            (index) => 0.0,
      ).reshape([1, outputShape[1]]);

      // Run inference
      _interpreter!.run(input, output);

      // Get results
      final probabilities = output[0] as List<double>;

      // Find max probability
      double maxProb = probabilities[0];
      int maxIndex = 0;
      for (int i = 1; i < probabilities.length; i++) {
        if (probabilities[i] > maxProb) {
          maxProb = probabilities[i];
          maxIndex = i;
        }
      }

      // Get label
      final label = _labels![maxIndex];

      return ClassificationResult(
        label: label,
        confidence: maxProb,
        imagePath: imageFile.path,
      );
    } catch (e) {
      print('❌ Classification error: $e');
      throw Exception('Classification failed: $e');
    }
  }

  // Preprocess image
  Future<List<List<List<List<double>>>>> _preprocessImage(File imageFile) async {
    try {
      // Read image
      final imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize image to model input size (usually 224x224)
      final inputShape = _interpreter!.getInputTensor(0).shape;
      final inputSize = inputShape[1]; // Assuming square input

      image = img.copyResize(
        image,
        width: inputSize,
        height: inputSize,
      );

      // Convert to normalized float values
      final input = List.generate(
        1,
            (batch) => List.generate(
          inputSize,
              (y) => List.generate(
            inputSize,
                (x) => List.generate(
              3,
                  (c) {
                final pixel = image!.getPixel(x, y);
                if (c == 0) return pixel.r / 255.0; // Red
                if (c == 1) return pixel.g / 255.0; // Green
                return pixel.b / 255.0; // Blue
              },
            ),
          ),
        ),
      );

      return input;
    } catch (e) {
      print('❌ Preprocessing error: $e');
      throw Exception('Image preprocessing failed: $e');
    }
  }

  // Dispose resources
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _labels = null;
    _isInitialized = false;
  }
}
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/classifier_service.dart';
import '../models/classification_result.dart';

class ScanProvider extends ChangeNotifier {
  final ClassifierService _classifierService = ClassifierService();
  final ImagePicker _picker = ImagePicker();

  bool _isInitialized = false;
  bool _isCameraLoading = false;
  bool _isGalleryLoading = false;
  bool _isProcessing = false;
  String? _error;
  File? _selectedImage;
  ClassificationResult? _lastResult;

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isCameraLoading => _isCameraLoading;
  bool get isGalleryLoading => _isGalleryLoading;
  bool get isProcessing => _isProcessing;
  String? get error => _error;
  File? get selectedImage => _selectedImage;
  ClassificationResult? get lastResult => _lastResult;

  // Initialize the classifier
  Future<void> initialize() async {
    try {
      await _classifierService.initialize();
      _isInitialized = true;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to initialize: $e';
      _isInitialized = false;
      notifyListeners();
    }
  }

  // Open camera and classify
  Future<void> openCamera(BuildContext context) async {
    _isCameraLoading = true;
    _error = null;
    notifyListeners();

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        _selectedImage = File(image.path);
        await _classifyImage(context);
      }
    } catch (e) {
      _error = 'Camera error: $e';
    } finally {
      _isCameraLoading = false;
      notifyListeners();
    }
  }

  // Open gallery and classify
  Future<void> openGallery(BuildContext context) async {
    _isGalleryLoading = true;
    _error = null;
    notifyListeners();

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        _selectedImage = File(image.path);
        await _classifyImage(context);
      }
    } catch (e) {
      _error = 'Gallery error: $e';
    } finally {
      _isGalleryLoading = false;
      notifyListeners();
    }
  }

  // Classify the selected image
  Future<void> _classifyImage(BuildContext context) async {
    if (_selectedImage == null) return;

    _isProcessing = true;
    notifyListeners();

    try {
      final result = await _classifierService.classifyImage(_selectedImage!);
      _lastResult = result;
      _error = null;

      // Navigate to result screen
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          '/result',
          arguments: result,
        );
      }
    } catch (e) {
      _error = 'Classification error: $e';
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  // Clear current selection
  void clearSelection() {
    _selectedImage = null;
    _lastResult = null;
    _error = null;
    notifyListeners();
  }

  // Dispose resources
  @override
  void dispose() {
    _classifierService.dispose();
    super.dispose();
  }
}
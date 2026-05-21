import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/classification_result.dart';

class DiagnoseHistoryProvider extends ChangeNotifier {
  static const _storageKey = 'diagnose_history';
  final List<ClassificationResult> _history = [];
  final int _maxHistorySize = 50;
  bool _isLoaded = false;

  List<ClassificationResult> get history => List.unmodifiable(_history);
  int get historyCount => _history.length;
  bool get hasHistory => _history.isNotEmpty;

  DiagnoseHistoryProvider() {
    _loadHistory();
  }

  // Load history from SharedPreferences
  Future<void> _loadHistory() async {
    if (_isLoaded) return;
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      _history.addAll(
        jsonList.map((e) => ClassificationResult.fromJson(e as Map<String, dynamic>)),
      );
    }
    _isLoaded = true;
    notifyListeners();
  }

  // Save history to SharedPreferences
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_history.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  // Add a new diagnosis to history
  void addDiagnosis(ClassificationResult result) {
    _history.insert(0, result); // Add to beginning

    // Limit history size
    if (_history.length > _maxHistorySize) {
      _history.removeLast();
    }

    notifyListeners();
    _saveHistory();
  }

  // Get recent diagnoses
  List<ClassificationResult> getRecent(int count) {
    return _history.take(count).toList();
  }

  // Remove a diagnosis
  void removeDiagnosis(ClassificationResult result) {
    _history.remove(result);
    notifyListeners();
    _saveHistory();
  }

  // Clear all history
  void clearHistory() {
    _history.clear();
    notifyListeners();
    _saveHistory();
  }

  // Get diagnoses by disease name
  List<ClassificationResult> getDiagnosesByDisease(String diseaseName) {
    return _history
        .where((result) => result.label == diseaseName)
        .toList();
  }
}

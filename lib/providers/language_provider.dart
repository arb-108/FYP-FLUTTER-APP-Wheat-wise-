import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_strings.dart';

class LanguageProvider extends ChangeNotifier {
  static const _storageKey = 'app_language';
  String _currentLang = AppStrings.en;
  bool _isLoaded = false;

  String get currentLang => _currentLang;
  bool get isUrdu => _currentLang == AppStrings.ur;
  bool get isEnglish => _currentLang == AppStrings.en;

  /// Font family based on language
  String get fontFamily => isUrdu ? 'JameelNooriNastaleeq' : 'Poppins';

  /// Text direction based on language
  TextDirection get textDirection =>
      isUrdu ? TextDirection.rtl : TextDirection.ltr;

  /// Locale based on language
  Locale get locale => isUrdu ? const Locale('ur') : const Locale('en');

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    if (_isLoaded) return;
    final prefs = await SharedPreferences.getInstance();
    _currentLang = prefs.getString(_storageKey) ?? AppStrings.en;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    _currentLang =
        _currentLang == AppStrings.en ? AppStrings.ur : AppStrings.en;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, _currentLang);
  }

  /// Get a UI string by key
  String get(String key) => AppStrings.get(key, _currentLang);

  /// Get disease name
  String diseaseName(String englishName) =>
      AppStrings.getDiseaseName(englishName, _currentLang);

  /// Get disease description
  String diseaseDescription(String englishName) =>
      AppStrings.getDiseaseDescription(englishName, _currentLang);

  /// Get severity label
  String severityLabel(String severity) =>
      AppStrings.getSeverityLabel(severity, _currentLang);
}

# Plantia — Flutter Project Structure

```
lib/
├── main.dart                          # App entry point → PlantiaApp
│
├── theme/
│   └── app_theme.dart                 # Colors & ThemeData
│
├── utils/
│   └── app_constants.dart             # Model paths, sizes, URLs
│
├── models/
│   ├── banner_item.dart               # BannerItem, DiagnoseItem data classes
│   └── classification_result.dart     # ClassificationResult data class
│
├── services/
│   └── classifier_service.dart        # TFLite load, preprocess, classify
│
├── widgets/                           # Reusable UI components
│   ├── app_bottom_nav_bar.dart        # Dark pill bottom nav
│   ├── banner_carousel.dart           # Auto-play image carousel
│   ├── diagnose_list_item.dart        # Recent diagnose row card
│   └── scan_section.dart             # "Scan Now" action card
│
└── screens/
    ├── home_screen.dart               # Main dashboard screen
    └── result_screen.dart             # Classification result screen
```

## Dependency Graph

```
main.dart
  └── PlantiaApp
        └── HomeScreen (screens/)
              ├── ClassifierService (services/)  ← AppConstants (utils/)
              ├── BannerCarousel (widgets/)       ← BannerItem (models/)
              ├── ScanSection (widgets/)          ← AppTheme (theme/)
              ├── DiagnoseListItem (widgets/)     ← AppTheme (theme/)
              ├── AppBottomNavBar (widgets/)      ← AppTheme (theme/)
              └── ResultScreen (screens/)
                    ├── ClassificationResult (models/)
                    └── AppTheme (theme/)
```

## Key Changes from Original

| Before | After |
|---|---|
| Single `main.dart` (~250 lines) | 10 focused files |
| Magic strings for paths/colors | `AppConstants` + `AppTheme` |
| `Map<String, dynamic>` for results | Typed `ClassificationResult` model |
| Classifier logic inside widget | `ClassifierService` (testable) |
| Inline UI blocks | Reusable widget classes |
| `WheatDiseaseApp` class name | `PlantiaApp` (matches brand) |

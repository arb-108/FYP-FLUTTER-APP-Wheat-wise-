#  WheatWise

Complete reference for the Flutter wheat plant disease detection app located in `D:\VS_Backup\Flutter\Come Back\zoro`. The folder is `zoro`, the pubspec name is `wheatwise`, the runtime app title is "Plantia", and the Android/iOS display name is "WheatWise". They all refer to the same app.

---

## 1. Identity & Versioning

| Field | Value | Source |
|---|---|---|
| Folder | `zoro` | filesystem |
| Pubspec name | `wheatwise` | [pubspec.yaml:1](pubspec.yaml) |
| Display name (Android) | WheatWise | `android/app/src/main/AndroidManifest.xml` |
| Display name (iOS) | WheatWise | `ios/Runner/Info.plist` (CFBundleDisplayName / CFBundleName) |
| Runtime `MaterialApp.title` | resolved from `appTitle` key → "WheatWise - Plant Disease Detection" | [main.dart:40](lib/main.dart) |
| Root widget class | `PlantiaApp` | [main.dart:26](lib/main.dart) |
| Description | WheatWise - Plant Disease Detection | [pubspec.yaml:2](pubspec.yaml) |
| Version | 1.0.0+1 | [pubspec.yaml:19](pubspec.yaml) |
| Android applicationId / namespace | `com.example.zoro` | `android/app/build.gradle.kts` |
| Dart SDK constraint | `^3.10.3` | [pubspec.yaml:22](pubspec.yaml) |
| Flutter constraint (lockfile) | `>=3.38.0` | `pubspec.lock` |
| Profile name shown in-app | Abdul Rehman (PUCIT student) | [app_strings.dart:49](lib/l10n/app_strings.dart) |
| Member since (hardcoded) | March 2024 | [home_screen.dart:668](lib/screens/home_screen.dart) |
| Profile chip initials | ARB | [home_screen.dart:105](lib/screens/home_screen.dart) |

---

## 2. Tech Stack

### Runtime dependencies
| Package | Purpose |
|---|---|
| `flutter` (SDK) | UI framework, Material 3 |
| `flutter_localizations` (SDK) | EN/UR localizations delegates |
| `cupertino_icons` ^1.0.8 | iOS-style icon set |
| `image_picker` | Camera + gallery image acquisition |
| `tflite_flutter` | On-device TensorFlow Lite inference |
| `image` | Decoding + resizing input bitmaps before inference |
| `provider` | `ChangeNotifier`-based state management |
| `carousel_slider` | Declared (banner currently uses native `PageView`) |
| `shared_preferences` | Persistence for history + language |

### Dev dependencies
| Package | Purpose |
|---|---|
| `flutter_test` (SDK) | Widget/unit tests |
| `flutter_lints` ^6.0.0 | Lint rule set |
| `flutter_launcher_icons` ^0.14.3 | Generates launcher icons from `assets/img/wheatwise_logo.png` |
| `flutter_native_splash` ^2.4.6 | Generates white splash for Android 12+ and legacy |

### Fonts
- **Poppins** (Light 300, Regular 400, Bold 700) — Latin script.
- **JameelNooriNastaleeq** (`Jameel Noori Nastaleeq Kasheeda.ttf`) — Urdu, RTL.

---

## 3. Project Layout

```
zoro/
├── lib/
│   ├── main.dart                     # PlantiaApp, MultiProvider, routes, locales
│   ├── l10n/
│   │   └── app_strings.dart          # AppStrings.get / disease names / severity labels
│   ├── models/
│   │   ├── banner_item.dart          # BannerItem (legacy) + DiagnoseItem (legacy JSON)
│   │   ├── classification_result.dart # label, confidence, timestamp, imagePath
│   │   └── disease.dart              # Disease + DiseaseData (14 entries) + Severity enum
│   ├── providers/
│   │   ├── scan_provider.dart        # camera/gallery + classifier orchestration
│   │   ├── navigation_provider.dart  # bottom-nav active index
│   │   ├── diagnose_history_provider.dart # persisted history (max 50)
│   │   └── language_provider.dart    # EN/UR toggle, font + locale + textDirection
│   ├── screens/
│   │   ├── home_screen.dart          # HomeScreen + Home/History/Profile tabs
│   │   ├── result_screen.dart        # Disease detail + treatment + risk bar
│   │   ├── history_screen.dart       # Standalone history screen (unused — superseded by Home tab 2)
│   │   └── disease_list_screen.dart  # Disease catalog with search + severity filter
│   ├── services/
│   │   └── classifier_service.dart   # TFLite Interpreter + preprocess + run
│   ├── theme/
│   │   └── app_theme.dart            # Light + dark Material 3 themes
│   ├── utils/
│   │   └── app_constants.dart        # Asset paths, thresholds, durations
│   └── widgets/
│       ├── app_bottom_nav_bar.dart   # Floating dark pill nav + scan bottom-sheet
│       ├── banner_carousel.dart      # 3-banner auto-cycling PageView (4s interval)
│       ├── diagnose_list_item.dart   # History row + detail bottom-sheet
│       ├── loading_overlay.dart      # Generic CircularProgressIndicator overlay
│       └── scan_section.dart         # Home "Scan Now" card + scan bottom-sheet
├── assets/
│   ├── fonts/                        # Poppins (Light/Regular/Bold), Jameel Noori Nastaleeq
│   ├── img/                          # 14 disease PNGs, 3 banner JPGs, logo, splash
│   └── model/
│       ├── wheats_model.tflite       # TFLite classifier
│       └── labels.txt                # 14 class labels (newline-separated)
├── android/ ios/ windows/ macos/ linux/ web/
├── test/
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
└── README.md  (default Flutter template — unchanged)
```

---

## 4. Application Bootstrap

`main()` in [main.dart](lib/main.dart) does three things:

1. `WidgetsFlutterBinding.ensureInitialized()`.
2. Sets system UI overlay style with **transparent** status bar and navigation bar.
3. Enables `SystemUiMode.edgeToEdge` (Flutter draws under the system bars).
4. Runs `PlantiaApp`.

`PlantiaApp` builds a `MultiProvider` over **four** `ChangeNotifierProvider`s, then wraps `MaterialApp` in a `Consumer<LanguageProvider>` so the entire app theme + font + locale rebuilds when the language toggles.

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ScanProvider()..initialize()),
    ChangeNotifierProvider(create: (_) => NavigationProvider()),
    ChangeNotifierProvider(create: (_) => DiagnoseHistoryProvider()),
    ChangeNotifierProvider(create: (_) => LanguageProvider()),
  ],
  child: Consumer<LanguageProvider>(...),
)
```

Key `MaterialApp` configuration:
- `debugShowCheckedModeBanner: false`
- `theme` / `darkTheme` rebuilt with `lang.fontFamily` so the font follows the language
- `themeMode: ThemeMode.system`
- `locale: lang.locale`
- `supportedLocales: [Locale('en'), Locale('ur')]`
- Localization delegates: `GlobalMaterialLocalizations`, `GlobalWidgetsLocalizations`, `GlobalCupertinoLocalizations`
- Routes:
  - `/` → `HomeScreen`
  - `/result` → `ResultScreen` (expects a `ClassificationResult` as `arguments`)
- `onUnknownRoute` → localized "Page not found" scaffold

---

## 5. Classification Pipeline

The end-to-end flow when a user scans:

```
User taps "Scan Now" / nav scan icon
   │
   ▼
ScanProvider.openCamera() or openGallery()
   │
   ▼  image_picker (max 1024×1024, quality 85)
File (selectedImage)
   │
   ▼
ClassifierService.classifyImage(file)
   │
   ├─ _preprocessImage()
   │     • decodeImage via package:image
   │     • copyResize to model input shape (typically 224×224)
   │     • normalize RGB to 0..1
   │     • produce shape [1, H, W, 3] List<List<List<List<double>>>>
   │
   ▼
Interpreter.run(input, output[1, 14])
   │
   ▼
argmax → labels[index]
   │
   ▼
ClassificationResult { label, confidence, timestamp, imagePath }
   │
   ├─ ScanProvider.lastResult
   │
   ▼
Navigator.pushNamed('/result', arguments: result)
   │
   ▼
ResultScreen.initState → DiagnoseHistoryProvider.addDiagnosis(result)
   │
   ▼
Render disease header, description, treatment tips, risk bar, note, actions
```

### Classifier service ([classifier_service.dart](lib/services/classifier_service.dart))
- `Interpreter.fromAsset(AppConstants.modelPath, options: ..threads = 4)` — multithreaded TFLite.
- Labels parsed by splitting `labels.txt` on `\n` and trimming.
- Input tensor shape is **read at runtime** from `getInputTensor(0).shape` (square input assumed → `inputSize = shape[1]`).
- Output tensor shape is read at runtime → `[1, N]` where N == number of labels (14).
- Returns a `ClassificationResult` with the top-1 label and confidence.
- `dispose()` closes interpreter and clears labels.

### Constants ([app_constants.dart](lib/utils/app_constants.dart))
| Constant | Value |
|---|---|
| `modelPath` | `assets/model/wheats_model.tflite` |
| `labelsPath` | `assets/model/labels.txt` |
| `imageSize` | 224 |
| `imageChannels` | 3 |
| `confidenceThreshold` | 0.5 |
| `highConfidenceThreshold` | 0.8 |
| `cardBorderRadius` | 12.0 |
| `buttonBorderRadius` | 12.0 |
| `defaultPadding` | 16.0 |
| `defaultAnimationDuration` | 300 ms |
| `splashDuration` | 2 s |
| `maxHistoryItems` | 50 |
| `recentItemsCount` | 3 |
| `bannerAutoPlayDuration` | 3 s (carousel actually uses 4 s) |
| `bannerHeight` | 180.0 |
| `appName` | "Plantia" |
| `appVersion` | "1.0.0" |

---

## 6. Disease Catalog (14 classes)

Defined in [disease.dart](lib/models/disease.dart) (`DiseaseData.all`). Order matches `labels.txt`.

| # | Label | Severity | Image | Description (English) |
|---|---|---|---|---|
| 1 | Aphid | Medium | `aphid.png` | Sap-sucking insects causing curling, stunting, virus transmission |
| 2 | Black Rust | High | `black_rust.png` | *Puccinia graminis* — black pustules on stems and leaves |
| 3 | Blast | High | `blast.png` | Diamond-shaped lesions; can hit grain heads |
| 4 | Brown Rust | High | `brown_rust.png` | *Puccinia triticina* — orange-brown leaf pustules |
| 5 | Common Root Rot | High | `common_root_rot.png` | Soil-borne; root browning & decay |
| 6 | Fusarium Head Blight | High | `fusarium_head_blight.png` | Bleached spikelets + mycotoxins |
| 7 | Healthy | Low | `healthy.png` | No disease |
| 8 | Leaf Blight | Medium | `leaf_blight.png` | Necrotic lesions reducing photosynthesis |
| 9 | Mildew | Medium | `mildew.png` | White/gray powdery coating |
| 10 | Mite | Low | `mite.png` | Stippling and discoloration from feeding mites |
| 11 | Septoria | Medium | `septoria.png` | *Zymoseptoria tritici* — tan lesions, dark pycnidia |
| 12 | Smut | Medium | `smut.png` | Grain replaced by dark spore masses, foul odor |
| 13 | Stem Fly | Medium | `stem_fly.png` | Larvae bore stems → wilting, lodging |
| 14 | Tan Spot | Medium | `tan_spot.png` | *Pyrenophora tritici-repentis* — tan lesions with yellow halos |

`Severity` enum and color map (`Disease.severityColor`):

| Severity | Color | Hex |
|---|---|---|
| Low | green | `#4CAF50` |
| Medium | amber | `#FFA726` |
| High | red | `#EF5350` |

`DiseaseData.getByName(name)` is a case-insensitive exact-match lookup; throws on unknown labels (callers in `ResultScreen` and `DiagnoseListItem` catch and show a fallback UI).

> **Note**: `labels.txt` uses lowercase `Stem fly` and `Tan spot`, while `DiseaseData` uses Title Case `Stem Fly` and `Tan Spot`. The model output goes through `getByName` which lowercases both sides, so this is harmless — but if you ever do a case-sensitive comparison (the history "Healthy" filter in `_HistoryStatsCard` is such a case at [home_screen.dart:477](lib/screens/home_screen.dart)), be aware.

---

## 7. State Management (Providers)

### `ScanProvider` ([scan_provider.dart](lib/providers/scan_provider.dart))
| Field | Type | Notes |
|---|---|---|
| `isInitialized` | bool | True once TFLite model loaded |
| `isCameraLoading` | bool | Disables UI while camera is being launched |
| `isGalleryLoading` | bool | Same for gallery |
| `isProcessing` | bool | True during inference |
| `error` | String? | Surfaced as `SnackBar` from `ScanSection` |
| `selectedImage` | File? | Latest picked file |
| `lastResult` | ClassificationResult? | Latest inference result |

Methods:
- `initialize()` — eagerly called in `MultiProvider` (`..initialize()`) so the model is ready before the user scans.
- `openCamera(BuildContext)` / `openGallery(BuildContext)` — pick → classify → push `/result`.
- `_classifyImage(BuildContext)` — internal; called by both pickers.
- `clearSelection()` — resets `selectedImage`, `lastResult`, `error`.
- `dispose()` — disposes the underlying `ClassifierService`.

### `NavigationProvider` ([navigation_provider.dart](lib/providers/navigation_provider.dart))
Single int `_currentIndex` and `setIndex(int)` that only notifies on change. Drives which tab `HomeScreen` shows.

Index mapping (see `AppBottomNavBar`):
- `0` → Home tab
- `1` → **opens scan bottom-sheet** (does not change the active tab)
- `2` → History tab
- `3` → Profile tab

### `DiagnoseHistoryProvider` ([diagnose_history_provider.dart](lib/providers/diagnose_history_provider.dart))
- Keeps up to **50** `ClassificationResult`s in memory (newest first).
- Persists to `SharedPreferences` under key `diagnose_history` as JSON.
- API:
  - `addDiagnosis(result)` — insert at index 0, trim tail, save.
  - `removeDiagnosis(result)`
  - `clearHistory()`
  - `getRecent(int count)`
  - `getDiagnosesByDisease(String name)`
  - getters: `history` (unmodifiable), `historyCount`, `hasHistory`
- Loaded once via `_loadHistory()` in the constructor (guarded by `_isLoaded`).

### `LanguageProvider` ([language_provider.dart](lib/providers/language_provider.dart))
- Persists `app_language` in `SharedPreferences` (`AppStrings.en` / `AppStrings.ur`).
- Derived getters: `isEnglish`, `isUrdu`, `fontFamily` (Poppins / JameelNooriNastaleeq), `textDirection`, `locale`.
- `toggleLanguage()` — swap and persist.
- Lookup helpers: `get(key)`, `diseaseName(en)`, `diseaseDescription(en)`, `severityLabel(s)`.

---

## 8. Models

### `ClassificationResult` ([classification_result.dart](lib/models/classification_result.dart))
```dart
class ClassificationResult {
  final String label;
  final double confidence;
  final DateTime timestamp;
  final String? imagePath;
}
```
- `toJson()` / `ClassificationResult.fromJson(Map)` is the persistence boundary used by `DiagnoseHistoryProvider`.
- `copyWith(...)` available.
- `timestamp` defaults to `DateTime.now()` if not provided.

### `Disease` + `DiseaseData` ([disease.dart](lib/models/disease.dart))
- `Disease { name, description, severity, imagePath }` + computed `severityColor` and `severityLabel`.
- `DiseaseData.all` is `const List<Disease>` of length 14.
- `DiseaseData.getByName(name)` lowercases both sides; throws on miss.

### `BannerItem` + `DiagnoseItem` ([banner_item.dart](lib/models/banner_item.dart))
**Legacy / unused.** The current banner carousel uses inline string keys instead of `BannerItem`, and the current history uses `ClassificationResult` instead of `DiagnoseItem`. Both classes are still in the codebase but have no active references — candidates for removal.

---

## 9. Screens

### `HomeScreen` ([home_screen.dart](lib/screens/home_screen.dart))
A single `Scaffold` whose body switches between three internal stateless tabs based on `NavigationProvider.currentIndex`:

#### `_HomeTab` (index 0)
1. `_ProfileHeader` — circular avatar (Icons.person), greeting `welcomeBack`, and a **language toggle pill** ("Eng" / "اردو") that calls `lang.toggleLanguage()`.
2. `BannerCarousel` — 3 auto-rotating banner cards (4-second timer, dot indicator).
3. `ScanSection` — green "eco" icon + title + outlined `Scan Now` button. Tap → bottom-sheet with Camera/Gallery options and a yellow disclaimer warning.
4. `_RecentDiagnosesSection` — shows last 3 diagnoses or an empty-state card (`_EmptyHistoryWidget`). Header has a `See All` link that switches to the History tab.

#### `_HistoryTab` (index 2)
- Header: "Diagnosis History" + total scans count + trash icon.
- Empty state: history icon + "Start Scanning" CTA that switches back to Home tab.
- Populated state:
  - `_HistoryStatsCard` — gradient (primary→secondary) card showing **total**, **healthy** count, **diseased** count. Healthy is computed by `r.label == 'Healthy'`.
  - All history items rendered as `DiagnoseListItem`s.
- Trash icon → `AlertDialog` confirming `clearHistory()`; success shows a floating `SnackBar`.

#### `_ProfileTab` (index 3)
- Header "Profile".
- Big circular avatar with primary→secondary gradient.
- Hardcoded name "Abdul Rehman" + "A PUCIT Student" tagline.
- Two `_ProfileInfoTile`s:
  - **Member Since**: hardcoded "March 2024".
  - **Scans Performed**: live count from `DiagnoseHistoryProvider.historyCount`.

### `ResultScreen` ([result_screen.dart](lib/screens/result_screen.dart))
Stateful — in `initState` schedules a post-frame callback that adds the route's `ClassificationResult` arg to `DiagnoseHistoryProvider`. If args are null, shows a "No result data" scaffold.

Sections:
1. **`_DiseaseHeaderCard`** — 64×64 thumbnail (prefers the user's picked image, falls back to the disease asset, then to a generic icon), localized disease name, "Wheat plant" subtitle, and a colored confidence pill `(confidence * 100).toStringAsFixed(0)%`.
2. **Description** — "<DiseaseName> on Wheat" header + localized description, or `noDetailedInfo` fallback.
3. **`_TreatmentSection`** (only if disease is known) — bulleted list of treatment tips. `_getTreatmentTips`:
   - For `Healthy`: `[maintenance, prevention]`.
   - Otherwise: `[fungicides, resistantVarieties, cropRotation]`.
4. **`_RiskPredictionBar`** — `LinearProgressIndicator` colored by severity:
   - Low → 0.2
   - Medium → 0.5
   - High → 0.85
5. **`_NoteCard`** — disclaimer with info icon ("This is an AI prediction…").
6. **`_ActionButtons`** — `Re-Generate` (outlined; clears selection and `Navigator.pop`) and `Share` (elevated; currently just shows a placeholder `SnackBar`).

### `HistoryScreen` ([history_screen.dart](lib/screens/history_screen.dart))
A **standalone** history screen with its own `AppBar`. **Superseded** by the History tab inside `HomeScreen` (it is no longer reachable via routes since the home tabs took over). Texts are hardcoded English here, while the in-Home version uses `LanguageProvider.get(...)`.

### `DiseaseListScreen` ([disease_list_screen.dart](lib/screens/disease_list_screen.dart))
Stateful catalog browser. **Not currently wired to a route** but fully functional:
- Header with localized title + "X wheat diseases catalogued".
- Search box filtering on both English `name` and English `description`.
- Horizontal severity-filter chips: All / Low / Medium / High.
- Each row is a `_DiseaseCard`: image + localized name + localized description (max 2 lines, ellipsis) + severity pill.
- Empty result shows a search-off icon and `noDiseaseFound`.
- Has its own `AppBottomNavBar` integration (index 1 selected; tapping 0 does `pushReplacementNamed('/')`).

---

## 10. Widgets

### `AppBottomNavBar` ([app_bottom_nav_bar.dart](lib/widgets/app_bottom_nav_bar.dart))
- Floating dark pill (`#1A1A1A`) with 20px horizontal margin and 12px + safe-area bottom offset.
- 4 items: Home / Scan / History / Profile.
- Active item is highlighted with primary-color pill and **shows its label**; inactive items are icon-only (animated 220 ms).
- Tapping **Scan (index 1)** opens a `showModalBottomSheet` with two big card buttons (Camera / Gallery), a 40×4 grabber, and a yellow disclaimer container — **does not** change the nav index.
- Constructor accepts overrides `currentIndex` and `onTap` for callers like `DiseaseListScreen`.

### `BannerCarousel` ([banner_carousel.dart](lib/widgets/banner_carousel.dart))
- 200 px tall.
- 3 static banner specs `(titleKey, subtitleKey, image)` referencing `app_strings.dart` keys.
- Auto-advances every **4 seconds** via `Timer.periodic` + `_pageController.animateToPage` (400 ms `Curves.easeInOut`).
- Each `_BannerCard` uses `ResizeImage(AssetImage(...), width: 800)` to reduce memory; precaches in `didChangeDependencies`.
- Frame builder / error builder both fall back to a primary→secondary gradient.
- Page-dot indicator below: active is 22 px wide, inactive 8 px (animated 250 ms).

### `ScanSection` ([scan_section.dart](lib/widgets/scan_section.dart))
- Card with eco-icon + `scanTitle` + `scanSubtitle` + outlined "Scan Now" button.
- Button disabled while loading or `!isInitialized`; shows a circular spinner during loading.
- Post-frame `SnackBar` surfaces any `scanProvider.error`.
- Opens the same Camera/Gallery bottom-sheet (duplicated implementation with `AppBottomNavBar`).

### `DiagnoseListItem` ([diagnose_list_item.dart](lib/widgets/diagnose_list_item.dart))
- 48×48 disease asset thumbnail + localized name + relative time ("3m ago", "2h ago", "5d ago") + severity-colored confidence pill.
- Tapping opens `_showDiagnoseDetail` (a bottom-sheet with the full disease info).

### `LoadingOverlay` ([loading_overlay.dart](lib/widgets/loading_overlay.dart))
- Reusable barrier widget that overlays a centered `CircularProgressIndicator` over its `child` when `isLoading` is true.

---

## 11. Theming ([app_theme.dart](lib/theme/app_theme.dart))

Earthy sage-green Material 3 palette, separate light + dark builders that accept a `fontFamily` so the active language flips Poppins ↔ JameelNooriNastaleeq.

### Color tokens
| Token | Hex | Used for |
|---|---|---|
| `primaryColor` | `#3D6B50` | Primary buttons, active nav pill, headings emphasis |
| `secondaryColor` | `#5B8A6A` | Gradient endpoint, dark-mode elevated button |
| `accentColor` | `#8CB49C` | Dark-mode primary, outlined-button border |
| `scaffoldLight` | `#F2F5F0` | Light scaffold bg |
| `cardLight` | `#FFFFFF` | Light card surface |
| `surfaceLight` | `#E8EFE5` | Light input fill |
| `scaffoldDark` | `#0F1410` | Dark scaffold bg |
| `cardDark` | `#1A2420` | Dark card surface |
| `surfaceDark` | `#1E2B24` | Dark input fill |
| `navBarDark` | `#1A1A1A` | Bottom nav pill bg |
| `successColor` | `#4CAF50` | Healthy chip, eco icon |
| `warningColor` | `#FFA726` | Disclaimer banner |
| `errorColor` | `#EF5350` | Clear-history button, error SnackBar |
| `infoColor` | `#42A5F5` | Profile "member since" icon |

### Light theme highlights
- `useMaterial3: true`, `ColorScheme.fromSeed(primaryColor, …)`.
- Transparent `AppBar` with dark status-bar icons.
- Elevation 0 on cards + buttons (flat aesthetic, shadows applied manually via `BoxShadow`).
- Filled inputs with 14 px radius, no border.

### Dark theme highlights
- `primary: accentColor`, `secondary: secondaryColor`, `surface: cardDark`.
- Transparent `AppBar` with light status-bar icons.
- Elevated buttons use `secondaryColor` background; outlined buttons use accent green.
- `dividerTheme` uses `#2A3A30`.

---

## 12. Localization ([app_strings.dart](lib/l10n/app_strings.dart))

- Single 295-line map `_strings : Map<String, Map<String, String>>` keyed by `en` / `ur`.
- Public APIs:
  - `AppStrings.get(key, lang)` → falls back to English on miss.
  - `AppStrings.getDiseaseName(englishName, lang)`
  - `AppStrings.getDiseaseDescription(englishName, lang)`
  - `AppStrings.getSeverityLabel(severity, lang)`

Sections covered:
- General (`appTitle`, `error`, `pageNotFound`)
- Profile header (`welcomeBack`)
- Home tab (`recentDiagnose`, `seeAll`, `noDiagnosesYet`, `startScanningHistory`)
- History tab (counts, clear-confirm, empty state, stats card)
- Profile tab (`profile`, `abdulrehman`, `plantEnthusiast`, `memberSince`, `scansPerformed`)
- Scan section + bottom-sheet (titles, options, disclaimer)
- Banner titles + subtitles (`banner1Title`/`Subtitle`, `banner2…`, `banner3…`)
- Bottom nav (`home`, `scan`, `history`)
- Diagnose list item + result screen (confidence, treatment, risk bar labels)
- Disease catalog (per-disease names + descriptions in Urdu)
- Severity labels (`severityLow/Medium/High`)

**Font swap** is automatic: `MaterialApp.theme` and `darkTheme` are rebuilt with `lang.fontFamily` whenever `LanguageProvider` notifies. Urdu uses `JameelNooriNastaleeq`, English uses `Poppins`. `textDirection` is exposed but currently the app relies on `Locale('ur')` + RTL `Directionality` from `MaterialApp`.

---

## 13. Assets Inventory

### `assets/img/`
- 14 disease PNGs (one per class): `aphid.png`, `black_rust.png`, `blast.png`, `brown_rust.png`, `common_root_rot.png`, `fusarium_head_blight.png`, `healthy.png`, `leaf_blight.png`, `mildew.png`, `mite.png`, `septoria.png`, `smut.png`, `stem_fly.png`, `tan_spot.png`
- 3 banner JPGs: `wheat1.jpg`, `wheat2.jpg`, `wheat3.jpg`
- Branding: `wheatwise_logo.png` (used by `flutter_launcher_icons`), `wheat_splash.png`

### `assets/model/`
- `wheats_model.tflite` — the trained TFLite classifier.
- `labels.txt` — 14 lines, one label per line, matching the model's output index order.

### `assets/fonts/`
- `Poppins-Light.ttf` (300), `Poppins-Regular.ttf` (400), `Poppins-Bold.ttf` (700)
- `Jameel Noori Nastaleeq Kasheeda.ttf`

---

## 14. Platform Configuration

### Android (`android/`)
- `AndroidManifest.xml`:
  - `android:label="WheatWise"`
  - Single `MainActivity` (`launchMode="singleTop"`)
  - `LaunchTheme` for cold-start, `NormalTheme` post-init
  - `windowSoftInputMode="adjustResize"`, `hardwareAccelerated="true"`
  - `<queries>` declares `ACTION_PROCESS_TEXT` for Flutter's text plugin
- `app/build.gradle.kts`:
  - `namespace = "com.example.zoro"`, `applicationId = "com.example.zoro"`
  - `compileSdk`, `minSdk`, `targetSdk` pulled from Flutter Gradle plugin
  - Java/Kotlin target `VERSION_17`
  - Release uses **debug signing config** (TODO comment present) — replace before publishing.

> Note: `image_picker` on Android 13+ does not require runtime camera/storage permissions in the manifest for the photo-picker flow. If you ever need direct camera access, add `<uses-permission android:name="android.permission.CAMERA"/>`.

### iOS (`ios/`)
- `Info.plist`:
  - `CFBundleDisplayName` = WheatWise
  - `CFBundleName` = WheatWise
  - `flutter_launcher_icons` set `remove_alpha_ios: true`
- You must add `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription` to `Info.plist` for `image_picker` on iOS before App Store submission.

### Other platforms
`windows/`, `macos/`, `linux/`, `web/` scaffolding is present but `tflite_flutter` is mobile-first; desktop/web are not necessarily wired to the model.

### Launcher icons & splash
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/img/wheatwise_logo.png"
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/img/wheatwise_logo.png"
  remove_alpha_ios: true

flutter_native_splash:
  color: "#FFFFFF"
  android_12:
    color: "#FFFFFF"
    icon_background_color: "#FFFFFF"
```

Regenerate:
```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

---

## 15. Build & Run

```bash
# Install
flutter pub get

# Run
flutter run                            # debug, attached device
flutter run --release                  # release locally

# Android
flutter build apk --release            # universal apk
flutter build appbundle --release      # AAB for Play Store

# iOS (macOS host required)
flutter build ios --release

# Web
flutter build web
```

> Release Android builds currently re-use the debug signing config — set up a proper keystore before shipping.

---

## 16. Persistence Keys

| Key | Owner | Format |
|---|---|---|
| `diagnose_history` | `DiagnoseHistoryProvider` | `String` — JSON-encoded list of `ClassificationResult.toJson()` |
| `app_language` | `LanguageProvider` | `String` — `en` or `ur` |

No other persistent state (no DB, no Hive). Wiping app data resets both.

---

## 17. Known Caveats / TODOs

- **Dead code**: `BannerItem`, `DiagnoseItem` in [banner_item.dart](lib/models/banner_item.dart) and `HistoryScreen` ([history_screen.dart](lib/screens/history_screen.dart)) are no longer referenced. `DiseaseListScreen` ([disease_list_screen.dart](lib/screens/disease_list_screen.dart)) is fully built but not wired to any route or nav action.
- **Case mismatch**: `labels.txt` has `Stem fly` / `Tan spot` (lowercase). `DiseaseData` uses Title Case. `getByName` lowercases both, so model→catalog lookup works. Any case-sensitive comparison against the label needs care.
- **Duplicated scan bottom-sheet**: both `AppBottomNavBar._showScanOptions` and `ScanSection._showScanOptions` implement the same camera/gallery sheet. Worth extracting.
- **Hardcoded profile**: name, role, and "Member Since" are static. There is no auth/user model.
- **Hardcoded `ARB`** in `_ProfileHeader`'s small text ([home_screen.dart:105](lib/screens/home_screen.dart)) — separate from the Urdu-localized profile name.
- **Share action**: `_shareResult` in `ResultScreen` is a placeholder `SnackBar`, not a real share intent. No `share_plus` dependency yet.
- **Release signing**: Android release currently signs with the debug key (see `android/app/build.gradle.kts`).
- **iOS permission strings**: not present in `Info.plist`; required before submitting if you use `image_picker`.
- **AppConstants vs banner**: `bannerAutoPlayDuration` is 3s in `AppConstants`, but `BannerCarousel` hardcodes 4s — pick one.
- **Banner is `PageView`-based**, not `carousel_slider`, even though `carousel_slider` is a declared dependency.

---

## 18. Quick Reference Card

| Want to… | File |
|---|---|
| Change the model | [lib/utils/app_constants.dart](lib/utils/app_constants.dart) + replace assets |
| Add a disease class | [lib/models/disease.dart](lib/models/disease.dart) + `assets/img/` + retrain model + update `labels.txt` |
| Add/change a UI string | [lib/l10n/app_strings.dart](lib/l10n/app_strings.dart) |
| Add a screen | create in `lib/screens/`, register in `MaterialApp.routes` ([main.dart](lib/main.dart)) |
| Tweak colors | [lib/theme/app_theme.dart](lib/theme/app_theme.dart) |
| Change history capacity | `_maxHistorySize` in [lib/providers/diagnose_history_provider.dart](lib/providers/diagnose_history_provider.dart) |
| Wire the disease catalog into nav | Add a route + bottom-nav case to push [lib/screens/disease_list_screen.dart](lib/screens/disease_list_screen.dart) |

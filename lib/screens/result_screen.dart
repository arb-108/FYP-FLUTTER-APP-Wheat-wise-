import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/classification_result.dart';
import '../models/disease.dart';
import '../providers/diagnose_history_provider.dart';
import '../providers/scan_provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final result =
          ModalRoute.of(context)?.settings.arguments as ClassificationResult?;
      if (result != null) {
        context.read<DiagnoseHistoryProvider>().addDiagnosis(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final result =
        ModalRoute.of(context)?.settings.arguments as ClassificationResult?;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: Text(lang.get('error'))),
        body: const Center(child: Text('No result data')),
      );
    }

    Disease? disease;
    try {
      disease = DiseaseData.getByName(result.label);
    } catch (_) {
      // Unknown label — show fallback
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.get('result')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz_rounded),
            onPressed: () => _shareResult(result),
          ),
        ],
      ),
      body: Consumer<ScanProvider>(
        builder: (context, scanProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // ─── Disease Header Card ─────────────────
                _DiseaseHeaderCard(
                  result: result,
                  disease: disease,
                  imagePath: scanProvider.selectedImage?.path,
                ),

                const SizedBox(height: 24),

                // ─── Description Section ─────────────────
                Text(
                  '${lang.diseaseName(result.label)} ${lang.get('onWheat')}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  disease != null
                      ? lang.diseaseDescription(disease.name)
                      : lang.get('noDetailedInfo'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.7,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                ),

                const SizedBox(height: 24),

                // ─── Treatment & Prevention ──────────────
                if (disease != null) ...[
                  _TreatmentSection(disease: disease),
                  const SizedBox(height: 24),

                  // ─── Risk Prediction Bar ─────────────────
                  _RiskPredictionBar(disease: disease),
                  const SizedBox(height: 24),

                  // ─── Note Card ───────────────────────────
                  _NoteCard(disease: disease),
                  const SizedBox(height: 24),
                ],

                // ─── Action Buttons ──────────────────────
                _ActionButtons(
                  onScanAgain: () {
                    scanProvider.clearSelection();
                    Navigator.pop(context);
                  },
                  onShare: () => _shareResult(result),
                ),

                SizedBox(height: 16 + MediaQuery.of(context).padding.bottom),
              ],
            ),
          );
        },
      ),
    );
  }

  void _shareResult(ClassificationResult result) {
    final lang = context.read<LanguageProvider>();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${lang.get('sharing')} ${lang.diseaseName(result.label)} ${lang.get('resultText')}...'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ─── Disease Header Card ──────────────────────────────────
class _DiseaseHeaderCard extends StatelessWidget {
  final ClassificationResult result;
  final Disease? disease;
  final String? imagePath;

  const _DiseaseHeaderCard({
    required this.result,
    this.disease,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final severityColor = disease?.severityColor ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 64,
              height: 64,
              child: imagePath != null
                  ? Image.file(File(imagePath!), fit: BoxFit.cover)
                  : disease != null
                      ? Image.asset(disease!.imagePath, fit: BoxFit.cover)
                      : Container(
                          color: severityColor.withValues(alpha: 0.1),
                          child: Icon(
                            Icons.eco_rounded,
                            color: severityColor,
                            size: 32,
                          ),
                        ),
            ),
          ),
          const SizedBox(width: 14),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.diseaseName(result.label),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  lang.get('wheatPlant'),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Confidence
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: severityColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${(result.confidence * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: severityColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Treatment Section ────────────────────────────────────
class _TreatmentSection extends StatelessWidget {
  final Disease disease;

  const _TreatmentSection({required this.disease});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final greenColor = isDark ? AppTheme.accentColor : AppTheme.primaryColor;
    final tips = _getTreatmentTips(disease.name, lang);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.get('treatmentAndPrevention'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
          ),
          const SizedBox(height: 14),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: greenColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              height: 1.5,
                              color: isDark ? Colors.grey[400] : Colors.grey[700],
                            ),
                        children: [
                          TextSpan(
                            text: '${tip['title']}: ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: tip['desc']),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _getTreatmentTips(String name, LanguageProvider lang) {
    if (name == 'Healthy') {
      return [
        {'title': lang.get('maintenance'), 'desc': lang.get('maintenanceDesc')},
        {'title': lang.get('prevention'), 'desc': lang.get('preventionDesc')},
      ];
    }
    return [
      {'title': lang.get('fungicides'), 'desc': lang.get('fungicidesDesc')},
      {'title': lang.get('resistantVarieties'), 'desc': lang.get('resistantVarietiesDesc')},
      {'title': lang.get('cropRotation'), 'desc': lang.get('cropRotationDesc')},
    ];
  }
}

// ─── Risk Prediction Bar ──────────────────────────────────
class _RiskPredictionBar extends StatelessWidget {
  final Disease disease;

  const _RiskPredictionBar({required this.disease});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final riskLevel = disease.severity == Severity.low
        ? 0.2
        : disease.severity == Severity.medium
            ? 0.5
            : 0.85;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.get('riskLifePrediction'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
          ),
          const SizedBox(height: 14),
          // Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: riskLevel,
              minHeight: 8,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              valueColor:
                  AlwaysStoppedAnimation<Color>(disease.severityColor),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lang.get('low'),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              Text(lang.get('high'),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Note Card ────────────────────────────────────────────
class _NoteCard extends StatelessWidget {
  final Disease disease;

  const _NoteCard({required this.disease});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final greenColor = isDark ? AppTheme.accentColor : AppTheme.primaryColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: greenColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: greenColor.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_rounded,
            color: greenColor,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.get('note'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: greenColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lang.get('noteDesc'),
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: isDark ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Action Buttons ───────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  final VoidCallback onScanAgain;
  final VoidCallback onShare;

  const _ActionButtons({
    required this.onScanAgain,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onScanAgain,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(lang.get('reGenerate')),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: onShare,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(lang.get('share')),
          ),
        ),
      ],
    );
  }
}

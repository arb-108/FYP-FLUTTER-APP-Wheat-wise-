import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/classification_result.dart';
import '../models/disease.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';

class DiagnoseListItem extends StatelessWidget {
  final ClassificationResult result;

  const DiagnoseListItem({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Disease? disease;
    try {
      disease = DiseaseData.getByName(result.label);
    } catch (e) {
      debugPrint('Error: $e');
    }

    // Format timestamp
    final timeAgo = _formatTimeAgo(result.timestamp, lang);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _showDiagnoseDetail(context, result, disease),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Thumbnail / Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: disease != null
                        ? Image.asset(disease.imagePath, fit: BoxFit.cover)
                        : Container(
                            color: Colors.grey.withValues(alpha: 0.1),
                            child: const Icon(
                              Icons.help_outline,
                              color: Colors.grey,
                              size: 24,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.diseaseName(result.label),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lang.get('wheat'),
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Time
                Text(
                  timeAgo,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime date, LanguageProvider lang) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} ${lang.get('mAgo')}';
    if (diff.inHours < 24) return '${diff.inHours} ${lang.get('hAgo')}';
    if (diff.inDays < 7) return '${diff.inDays} ${lang.get('dAgo')}';
    return '${date.month}/${date.day}/${date.year}';
  }

  void _showDiagnoseDetail(
    BuildContext context,
    ClassificationResult result,
    Disease? disease,
  ) {
    final lang = context.read<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppTheme.cardDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        final bottomPadding = MediaQuery.of(context).padding.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: disease != null
                          ? Image.asset(disease.imagePath, fit: BoxFit.cover)
                          : Container(
                              color: Colors.grey.withValues(alpha: 0.1),
                              child: const Icon(
                                Icons.help_outline,
                                color: Colors.grey,
                                size: 28,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.diseaseName(result.label),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${lang.get('confidence')}: ${(result.confidence * 100).toStringAsFixed(1)}%',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[500],
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (disease != null) ...[
                const SizedBox(height: 24),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    lang.get('description'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    lang.diseaseDescription(disease.name),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          color: isDark ? Colors.grey[400] : Colors.grey[700],
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      '${lang.get('severity')}: ',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: disease.severityColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        lang.severityLabel(disease.severityLabel),
                        style: TextStyle(
                          color: disease.severityColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(lang.get('close')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

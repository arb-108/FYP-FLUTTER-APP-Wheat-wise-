import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scan_provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';

class ScanSection extends StatelessWidget {
  const ScanSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          // Icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: (isDark ? AppTheme.accentColor : AppTheme.primaryColor)
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.eco_rounded,
              color: isDark ? AppTheme.accentColor : AppTheme.primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(height: 14),

          // Title
          Text(
            lang.get('scanTitle'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),

          // Subtitle
          Text(
            lang.get('scanSubtitle'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),

          // Scan Now button
          const _ScanNowButton(),
        ],
      ),
    );
  }
}

// ─── Scan Now Button ────────────────────────────────────────
class _ScanNowButton extends StatelessWidget {
  const _ScanNowButton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();
    final greenColor = isDark ? AppTheme.accentColor : AppTheme.primaryColor;

    return Consumer<ScanProvider>(
      builder: (context, scanProvider, _) {
        final isLoading = scanProvider.isCameraLoading ||
            scanProvider.isGalleryLoading ||
            scanProvider.isProcessing;

        // Show error if any
        if (scanProvider.error != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(scanProvider.error!),
                backgroundColor: AppTheme.errorColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          });
        }

        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: isLoading || !scanProvider.isInitialized
                ? null
                : () => _showScanOptions(context, scanProvider),
            style: OutlinedButton.styleFrom(
              foregroundColor: greenColor,
              side: BorderSide(color: greenColor, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                    ),
                  )
                : Text(
                    lang.get('scanNow'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
          ),
        );
      },
    );
  }

  void _showScanOptions(BuildContext context, ScanProvider scanProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.read<LanguageProvider>();
    final greenColor = isDark ? AppTheme.accentColor : AppTheme.primaryColor;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + MediaQuery.of(ctx).padding.bottom),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              lang.get('scanPlant'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              lang.get('chooseOption'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _OptionCard(
                    icon: Icons.camera_alt_rounded,
                    label: lang.get('camera'),
                    greenColor: greenColor,
                    onTap: () {
                      Navigator.pop(ctx);
                      scanProvider.openCamera(context);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _OptionCard(
                    icon: Icons.photo_library_rounded,
                    label: lang.get('gallery'),
                    greenColor: greenColor,
                    onTap: () {
                      Navigator.pop(ctx);
                      scanProvider.openGallery(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // ─── Disclaimer Warning ─────────────────────
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.warningColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.warningColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppTheme.warningColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      lang.get('scanDisclaimer'),
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Scan Option Card ───────────────────────────────────────
class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color greenColor;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.label,
    required this.greenColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          border: Border.all(
            color: greenColor.withValues(alpha: 0.25),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 44, color: greenColor),
            const SizedBox(height: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

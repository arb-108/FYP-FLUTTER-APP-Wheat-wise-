import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/scan_provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';

class AppBottomNavBar extends StatelessWidget {
  final int? currentIndex;
  final void Function(int)? onTap;

  const AppBottomNavBar({super.key, this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Consumer<NavigationProvider>(
      builder: (context, navProvider, _) {
        final activeIndex = currentIndex ?? navProvider.currentIndex;
        final bottomPadding = MediaQuery.of(context).padding.bottom;
        return Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 12 + bottomPadding),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: lang.get('home'),
                isActive: activeIndex == 0,
                onTap: () => (onTap ?? _defaultTap(context, navProvider))(0),
              ),
              _NavItem(
                icon: Icons.document_scanner_outlined,
                activeIcon: Icons.document_scanner_rounded,
                label: lang.get('scan'),
                isActive: false,
                onTap: () => (onTap ?? _defaultTap(context, navProvider))(1),
              ),
              _NavItem(
                icon: Icons.history_outlined,
                activeIcon: Icons.history_rounded,
                label: lang.get('history'),
                isActive: activeIndex == 2,
                onTap: () => (onTap ?? _defaultTap(context, navProvider))(2),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: lang.get('profile'),
                isActive: activeIndex == 3,
                onTap: () => (onTap ?? _defaultTap(context, navProvider))(3),
              ),
            ],
          ),
        );
      },
    );
  }

  void Function(int) _defaultTap(
      BuildContext context, NavigationProvider navProvider) {
    return (int index) {
      if (index == 1) {
        _showScanOptions(context);
        return;
      }
      navProvider.setIndex(index);
    };
  }

  void _showScanOptions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.read<LanguageProvider>();
    final greenColor = isDark ? AppTheme.accentColor : AppTheme.primaryColor;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : Colors.white,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                  child: _ScanOptionCard(
                    icon: Icons.camera_alt_rounded,
                    label: lang.get('camera'),
                    greenColor: greenColor,
                    onTap: () {
                      Navigator.pop(ctx);
                      context.read<ScanProvider>().openCamera(context);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ScanOptionCard(
                    icon: Icons.photo_library_rounded,
                    label: lang.get('gallery'),
                    greenColor: greenColor,
                    onTap: () {
                      Navigator.pop(ctx);
                      context.read<ScanProvider>().openGallery(context);
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

// ─── Single Nav Item ────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? Colors.white : Colors.white54,
              size: 22,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Scan Option Card (bottom sheet) ────────────────────────
class _ScanOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color greenColor;
  final VoidCallback onTap;

  const _ScanOptionCard({
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

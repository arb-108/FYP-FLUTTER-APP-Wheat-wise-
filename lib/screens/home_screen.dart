import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/diagnose_list_item.dart';
import '../widgets/scan_section.dart';
import '../providers/diagnose_history_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Consumer<NavigationProvider>(
          builder: (context, navProvider, _) {
            switch (navProvider.currentIndex) {
              case 2:
                return const _HistoryTab();
              case 3:
                return const _ProfileTab();
              default:
                return const _HomeTab();
            }
          },
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// ─── HOME TAB ─────────────────────────────────────────────
// ═══════════════════════════════════════════════════════════

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ProfileHeader(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: 20, bottom: 16),
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              BannerCarousel(),
              SizedBox(height: 20),
              ScanSection(),
              SizedBox(height: 24),
              _RecentDiagnosesSection(),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Profile Header ────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE8E8E8) : const Color(0xFF1A1A1A);
    final lang = context.watch<LanguageProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 5),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.accentColor.withValues(alpha: 0.3),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.person,
              color: AppTheme.primaryColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ARB',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 13,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  lang.get('welcomeBack'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                ),
              ],
            ),
          ),
          // Language toggle switch
          GestureDetector(
            onTap: () => lang.toggleLanguage(),
            child: Container(
              height: 28,
              decoration: BoxDecoration(
                color: isDark ? AppTheme.surfaceDark : const Color(0xFFE8EBE5),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // English tab
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    height: 28,
                    decoration: BoxDecoration(
                      color: lang.isEnglish
                          ? AppTheme.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Eng',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: lang.isEnglish
                            ? Colors.white
                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  // Urdu tab
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 28,
                    decoration: BoxDecoration(
                      color: lang.isUrdu
                          ? AppTheme.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'اردو',
                      style: TextStyle(
                        fontFamily: 'JameelNooriNastaleeq',
                        color: lang.isUrdu
                            ? Colors.white
                            : (isDark ? Colors.grey[400] : Colors.grey[600]),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
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
}

// ─── Recent Diagnoses ──────────────────────────────────────
class _RecentDiagnosesSection extends StatelessWidget {
  const _RecentDiagnosesSection();

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang.get('recentDiagnose'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
              Consumer<DiagnoseHistoryProvider>(
                builder: (context, historyProvider, _) {
                  if (!historyProvider.hasHistory) {
                    return const SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () {
                      context.read<NavigationProvider>().setIndex(2);
                    },
                    child: Text(
                      lang.get('seeAll'),
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Consumer<DiagnoseHistoryProvider>(
          builder: (context, historyProvider, _) {
            if (!historyProvider.hasHistory) {
              return const _EmptyHistoryWidget();
            }

            final recentDiagnoses = historyProvider.getRecent(3);
            return Column(
              children: recentDiagnoses
                  .map((result) => DiagnoseListItem(result: result))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

// ─── Empty History ─────────────────────────────────────────
class _EmptyHistoryWidget extends StatelessWidget {
  const _EmptyHistoryWidget();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.watch<LanguageProvider>();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.history_rounded,
            size: 48,
            color: AppTheme.accentColor,
          ),
          const SizedBox(height: 12),
          Text(
            lang.get('noDiagnosesYet'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
          ),
          const SizedBox(height: 4),
          Text(
            lang.get('startScanningHistory'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// ─── HISTORY TAB ──────────────────────────────────────────
// ═══════════════════════════════════════════════════════════

class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? const Color(0xFFE8E8E8) : const Color(0xFF1A1A1A);
    final lang = context.watch<LanguageProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.get('diagnosisHistory'),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Consumer<DiagnoseHistoryProvider>(
                        builder: (context, hp, _) => Text(
                          '${hp.historyCount} ${lang.get('totalScans')}',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer<DiagnoseHistoryProvider>(
                  builder: (context, hp, _) {
                    if (!hp.hasHistory) return const SizedBox.shrink();
                    return IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: isDark ? Colors.grey[400] : Colors.grey[500],
                      ),
                      onPressed: () => _showClearDialog(context, hp),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Consumer<DiagnoseHistoryProvider>(
              builder: (context, historyProvider, _) {
                if (!historyProvider.hasHistory) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history_rounded,
                          size: 72,
                          color: AppTheme.accentColor.withValues(alpha: 0.6),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          lang.get('noHistoryYet'),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.grey[300] : Colors.grey[700],
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          lang.get('startScanningHistoryDesc'),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[500],
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        ElevatedButton.icon(
                          onPressed: () =>
                              context.read<NavigationProvider>().setIndex(0),
                          icon: const Icon(Icons.camera_alt_rounded, size: 20),
                          label: Text(lang.get('startScanning')),
                        ),
                      ],
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.only(bottom: 16),
                  children: [
                    _HistoryStatsCard(historyProvider: historyProvider),
                    const SizedBox(height: 20),
                    ...historyProvider.history
                        .map((result) => DiagnoseListItem(result: result)),
                  ],
                );
              },
            ),
          ),
        ],
      );
  }

  void _showClearDialog(
      BuildContext context, DiagnoseHistoryProvider provider) {
    final lang = context.read<LanguageProvider>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(lang.get('clearHistory')),
        content: Text(lang.get('clearHistoryConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang.get('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearHistory();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(lang.get('historyCleared')),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: Text(lang.get('clear')),
          ),
        ],
      ),
    );
  }
}

// History stats card
class _HistoryStatsCard extends StatelessWidget {
  final DiagnoseHistoryProvider historyProvider;

  const _HistoryStatsCard({required this.historyProvider});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final total = historyProvider.historyCount;
    final healthy =
        historyProvider.history.where((r) => r.label == 'Healthy').length;
    final diseased = total - healthy;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            lang.get('totalScansLabel'),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$total',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  icon: Icons.check_circle_rounded,
                  label: lang.get('healthy'),
                  value: '$healthy',
                ),
              ),
              Container(
                width: 1,
                height: 36,
                color: Colors.white.withValues(alpha: 0.25),
              ),
              Expanded(
                child: _MiniStat(
                  icon: Icons.warning_rounded,
                  label: lang.get('diseased'),
                  value: '$diseased',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// ─── PROFILE TAB ──────────────────────────────────────────
// ═══════════════════════════════════════════════════════════

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.cardDark : Colors.white;
    final textColor = isDark ? const Color(0xFFE8E8E8) : const Color(0xFF1A1A1A);
    final subtextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final lang = context.watch<LanguageProvider>();

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Text(
            lang.get('profile'),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
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
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                lang.get('abdulrehman'),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                lang.get('plantEnthusiast'),
                style: TextStyle(color: subtextColor, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _ProfileInfoTile(
          icon: Icons.calendar_today_rounded,
          iconColor: AppTheme.infoColor,
          label: lang.get('memberSince'),
          value: 'March 2024',
          cardColor: cardColor,
          textColor: textColor,
          subtextColor: subtextColor,
        ),
        Consumer<DiagnoseHistoryProvider>(
          builder: (context, hp, _) => _ProfileInfoTile(
            icon: Icons.eco_rounded,
            iconColor: AppTheme.successColor,
            label: lang.get('scansPerformed'),
            value: '${hp.historyCount}',
            cardColor: cardColor,
            textColor: textColor,
            subtextColor: subtextColor,
          ),
        ),
      ],
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color cardColor;
  final Color textColor;
  final Color? subtextColor;

  const _ProfileInfoTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.cardColor,
    required this.textColor,
    this.subtextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: subtextColor, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
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

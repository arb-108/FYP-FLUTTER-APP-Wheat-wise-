import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/diagnose_history_provider.dart';
import '../widgets/diagnose_list_item.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnosis History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<DiagnoseHistoryProvider>(
            builder: (context, historyProvider, _) {
              if (!historyProvider.hasHistory) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: () =>
                    _showClearHistoryDialog(context, historyProvider),
              );
            },
          ),
        ],
      ),
      body: Consumer<DiagnoseHistoryProvider>(
        builder: (context, historyProvider, _) {
          if (!historyProvider.hasHistory) {
            return const _EmptyHistoryView();
          }

          return ListView(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            children: [
              _HistoryStats(historyProvider: historyProvider),
              const SizedBox(height: 20),
              ...historyProvider.history
                  .map((result) => DiagnoseListItem(result: result)),
            ],
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }

  void _showClearHistoryDialog(
    BuildContext context,
    DiagnoseHistoryProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Clear History'),
        content: const Text(
          'Are you sure you want to clear all diagnosis history? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearHistory();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('History cleared'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

// ─── Empty View ────────────────────────────────────────────
class _EmptyHistoryView extends StatelessWidget {
  const _EmptyHistoryView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 80,
            color: AppTheme.accentColor.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 20),
          Text(
            'No History Yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start scanning plants to see\nyour history here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            icon: const Icon(Icons.camera_alt_rounded, size: 20),
            label: const Text('Start Scanning'),
          ),
        ],
      ),
    );
  }
}

// ─── Stats Card ────────────────────────────────────────────
class _HistoryStats extends StatelessWidget {
  final DiagnoseHistoryProvider historyProvider;

  const _HistoryStats({required this.historyProvider});

  @override
  Widget build(BuildContext context) {
    final total = historyProvider.historyCount;
    final healthy = historyProvider.history
        .where((r) => r.label == 'Healthy')
        .length;
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
            'Total Scans',
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
                  label: 'Healthy',
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
                  label: 'Diseased',
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

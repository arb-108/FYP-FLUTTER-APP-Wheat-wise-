import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/disease.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav_bar.dart';

class DiseaseListScreen extends StatefulWidget {
  const DiseaseListScreen({super.key});

  @override
  State<DiseaseListScreen> createState() => _DiseaseListScreenState();
}

class _DiseaseListScreenState extends State<DiseaseListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Severity? _selectedSeverity;
  String _query = '';

  List<Disease> get _filtered {
    return DiseaseData.all.where((d) {
      final matchesQuery =
          d.name.toLowerCase().contains(_query.toLowerCase()) ||
              d.description.toLowerCase().contains(_query.toLowerCase());
      final matchesSeverity =
          _selectedSeverity == null || d.severity == _selectedSeverity;
      return matchesQuery && matchesSeverity;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildSeverityFilter(),
            Expanded(child: _buildList()),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) return;
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 2:
              if (Navigator.canPop(context)) Navigator.pop(context);
              break;
            default:
              if (Navigator.canPop(context)) Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.get('diseaseLibrary'),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFE8E8E8) : Colors.grey[900],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${DiseaseData.all.length} ${lang.get('wheatDiseasesCatalogued')}',
            style: TextStyle(color: Colors.grey[500], fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v),
        decoration: InputDecoration(
          hintText: lang.get('searchDiseases'),
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[400]),
          suffixIcon: _query.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: Colors.grey[400]),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                )
              : null,
          filled: true,
          fillColor: isDark ? AppTheme.cardDark : Colors.white,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSeverityFilter() {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final greenColor = isDark ? AppTheme.accentColor : AppTheme.primaryColor;
    final filters = [null, Severity.low, Severity.medium, Severity.high];
    final labels = [
      lang.get('all'),
      lang.get('severityLow'),
      lang.get('severityMedium'),
      lang.get('severityHigh'),
    ];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        itemCount: filters.length,
        separatorBuilder: (_, i) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final isSelected = _selectedSeverity == filters[i];
          return GestureDetector(
            onTap: () => setState(() => _selectedSeverity = filters[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? greenColor
                    : (isDark ? AppTheme.cardDark : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? greenColor
                      : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                ),
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.grey[300] : Colors.grey[700]),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildList() {
    final lang = context.watch<LanguageProvider>();
    final items = _filtered;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 56, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              lang.get('noDiseaseFound'),
              style: TextStyle(color: Colors.grey[500], fontSize: 15),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      itemCount: items.length,
      separatorBuilder: (_, i) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _DiseaseCard(disease: items[i]),
    );
  }
}

// ─── Disease Card ───────────────────────────────────────────
class _DiseaseCard extends StatelessWidget {
  final Disease disease;

  const _DiseaseCard({required this.disease});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Image badge
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Image.asset(disease.imagePath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 14),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.diseaseName(disease.name),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  lang.diseaseDescription(disease.name),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Severity pill
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: disease.severityColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              lang.severityLabel(disease.severityLabel),
              style: TextStyle(
                color: disease.severityColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

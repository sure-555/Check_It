import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../data/history_reports.dart';
import '../../rules/rule_models.dart';
import '../../services/local_storage_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<InspectionResult> _hiveReports = [];
  List<InspectionResult> _allReports = [];
  List<InspectionResult> _filteredReports = [];

  final List<String> _filters = ['All', 'Critical', 'Major', 'Minor', 'Compliant'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _hiveReports = LocalStorageService().getAllInspections();
    _allReports = [..._hiveReports, ...historyReports];
    _applyFilter(_selectedFilter);
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesFilter(InspectionResult r) {
    final score = r.riskScore;
    bool matchesChip = true;
    switch (_selectedFilter) {
      case 'All':
        matchesChip = true;
        break;
      case 'Critical':
        matchesChip = score <= 30;
        break;
      case 'Major':
        matchesChip = score > 30 && score <= 60;
        break;
      case 'Minor':
        matchesChip = score > 60 && !r.isCompliant;
        break;
      case 'Compliant':
        matchesChip = r.isCompliant;
        break;
      default:
        matchesChip = true;
    }

    final matchesQuery = _searchQuery.isEmpty ||
        r.productName.toLowerCase().contains(_searchQuery);

    return matchesChip && matchesQuery;
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      _filteredReports = _allReports.where(_matchesFilter).toList();
    });
  }

  void _onSearch(String query) {
    _searchQuery = query.trim().toLowerCase();
    _applyFilter(_selectedFilter);
  }

  String _getDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) return "TODAY";
    if (targetDate == yesterday) return "YESTERDAY";
    return "EARLIER";
  }

  List<dynamic> _buildListItems() {
    final sortedHive = List<InspectionResult>.from(_hiveReports.where(_matchesFilter))
      ..sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
      
    final sortedDummy = List<InspectionResult>.from(historyReports.where(_matchesFilter))
      ..sort((a, b) => b.scannedAt.compareTo(a.scannedAt));

    final items = [];
    String? currentHeader;

    for (final result in sortedHive) {
      final header = _getDateHeader(result.scannedAt);
      if (header != currentHeader) {
        items.add(header);
        currentHeader = header;
      }
      items.add({'type': 'live', 'data': result});
    }

    if (sortedDummy.isNotEmpty) {
       items.add('EARLIER (DEMO DATA)');
       for (final result in sortedDummy) {
         items.add({'type': 'dummy', 'data': result});
       }
    }

    return items;
  }

  void _deleteReport(InspectionResult result) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Report'),
        content: const Text('Are you sure you want to delete this live report?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await LocalStorageService().deleteInspection(result);
              _loadData(); // reload hive data and refresh ui
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listItems = _buildListItems();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF9),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Inspection History', 
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF1C1917),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _filteredReports.length == _allReports.length 
                  ? 'Total: ${_allReports.length} Records'
                  : 'Showing ${_filteredReports.length} of ${_allReports.length} records', 
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF78716C),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFAFAF9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1C1917)),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 48,
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: 'Search by product name or brand...',
                  hintStyle: const TextStyle(fontFamily: 'Inter', color: Color(0xFFA8A29E), fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFA8A29E)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Color(0xFFA8A29E)),
                          onPressed: () {
                            _searchController.clear();
                            _onSearch('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE7E5E4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE7E5E4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1C1917)),
                  ),
                ),
              ),
            ),
          ),
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: _filters.map((chipLabel) {
                final isActive = _selectedFilter == chipLabel;
                return GestureDetector(
                  onTap: () => _applyFilter(chipLabel),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFF1C1917) : Colors.white,
                      border: Border.all(
                        color: isActive ? Colors.transparent : const Color(0xFFE7E5E4),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      chipLabel,
                      style: TextStyle(
                        color: isActive ? Colors.white : const Color(0xFF78716C),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          
          // List or Empty State
          Expanded(
            child: listItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.search_off, size: 48, color: Color(0xFFE7E5E4)),
                        SizedBox(height: 16),
                        Text(
                          "No inspections found",
                          style: TextStyle(color: Color(0xFF78716C), fontSize: 16, fontFamily: 'Inter'),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Try adjusting your filters",
                          style: TextStyle(color: Color(0xFFA8A29E), fontSize: 13, fontFamily: 'Inter'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: listItems.length,
                    itemBuilder: (context, index) {
                      final item = listItems[index];
                      if (item is String) {
                         return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
                          child: Text(
                            item.toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFFA8A29E),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              fontFamily: 'Inter',
                            ),
                          ),
                        );
                      } else if (item is Map) {
                        return _buildInspectionTile(context, item['data'] as InspectionResult, item['type'] == 'live');
                      }
                      return const SizedBox.shrink();
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionTile(BuildContext context, InspectionResult result, bool isLive) {
    final score = result.riskScore;
    final isCompliant = result.isCompliant;
    
    String badgeText;
    Color badgeBgColor;
    Color badgeTextColor;

    if (isCompliant) {
      badgeText = "Compliant";
      badgeTextColor = const Color(0xFF059669);
      badgeBgColor = const Color(0xFF059669).withOpacity(0.12);
    } else if (score <= 30) {
      badgeText = "Critical";
      badgeTextColor = const Color(0xFFDC2626);
      badgeBgColor = const Color(0xFFDC2626).withOpacity(0.12);
    } else if (score <= 60) {
      badgeText = "Major";
      badgeTextColor = const Color(0xFFD97706);
      badgeBgColor = const Color(0xFFD97706).withOpacity(0.12);
    } else {
      badgeText = "Minor";
      badgeTextColor = const Color(0xFF059669);
      badgeBgColor = const Color(0xFF059669).withOpacity(0.12);
    }

    return GestureDetector(
      onTap: () {
        context.push('/report-detail', extra: result);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabelThumbnail(result.labelImageAsset),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1C1917),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Color(0xFFA8A29E)),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(result.scannedAt),
                        style: const TextStyle(
                          color: Color(0xFF78716C),
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeBgColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            color: badgeTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      if (!isCompliant) ...[
                        const SizedBox(width: 8),
                        Text(
                          "${result.violations.length} violations",
                          style: const TextStyle(
                            color: Color(0xFFDC2626),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (isLive)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _deleteReport(result),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelThumbnail(String? assetPath) {
    if (assetPath == null || assetPath.isEmpty) {
      return _placeholderThumbnail();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        assetPath,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _placeholderThumbnail();
        },
      ),
    );
  }

  Widget _placeholderThumbnail() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.inventory_2_outlined,
        color: Color(0xFFA8A29E),
        size: 24,
      ),
    );
  }
}


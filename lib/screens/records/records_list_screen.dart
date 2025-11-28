import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/helpers.dart';
import '../../providers/health_records_provider.dart';
import '../../models/health_record.dart';
import 'add_edit_record_screen.dart';
import 'record_details_screen.dart';

class RecordsListScreen extends StatefulWidget {
  const RecordsListScreen({Key? key}) : super(key: key);

  @override
  State<RecordsListScreen> createState() => _RecordsListScreenState();
}

class _RecordsListScreenState extends State<RecordsListScreen> {
  List<HealthRecord> _allRecords = [];
  List<HealthRecord>? _filteredRecords;
  bool _isLoading = false;
  String? _filterDate;
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecords();
    });
  }

  Future<void> _loadRecords() async {
    if (!mounted || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final provider = Provider.of<HealthRecordsProvider>(context, listen: false);
    final records = await provider.loadRecords();

    if (mounted) {
      setState(() {
        _allRecords = records;
        _isLoading = false;
      });
    }
  }

  Future<void> _applyFilter() async {
    if (_filterDate == null && _dateRange == null) {
      setState(() {
        _filteredRecords = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final provider = Provider.of<HealthRecordsProvider>(context, listen: false);
    List<HealthRecord> records;

    if (_filterDate != null) {
      records = await provider.getRecordsByDateRange(_filterDate!, _filterDate!);
    } else if (_dateRange != null) {
      final startDate = DateHelper.formatDate(_dateRange!.start);
      final endDate = DateHelper.formatDate(_dateRange!.end);
      records = await provider.getRecordsByDateRange(startDate, endDate);
    } else {
      records = _allRecords;
    }

    if (mounted) {
      setState(() {
        _filteredRecords = records;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleAddRecord() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AddEditRecordScreen(),
      ),
    );

    if (result == true) {
      _loadRecords();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF8FB),
      body: Column(
        children: [
          // Fixed Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            color: const Color(0xFFEAF8FB),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Health Records',
                  style: TextStyle(
                    color: Color(0xFF002E34),
                    fontSize: 26,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w400,
                    height: 1,
                    letterSpacing: -1,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.filter_list_outlined,
                        color: Color(0xFF002E34),
                      ),
                      onPressed: _showFilterDialog,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Color(0xFF00707D),
                        size: 28,
                      ),
                      onPressed: _handleAddRecord,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Scrollable Content
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00707D),
        ),
      );
    }

    final records = _filteredRecords ?? _allRecords;

    if (records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: const Color(0xFF88A8AF),
            ),
            const SizedBox(height: 16),
            const Text(
              'No records found',
              style: TextStyle(
                color: Color(0xFF002E34),
                fontSize: 18,
                fontFamily: 'Onest',
                fontWeight: FontWeight.w400,
              ),
            ),
            if (_allRecords.isEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Tap + to add your first record',
                style: TextStyle(
                  color: Color(0xFF88A8AF),
                  fontSize: 14,
                  fontFamily: 'Onest',
                ),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadRecords,
      color: const Color(0xFF00707D),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: ShapeDecoration(
              color: const Color(0xFFF8FDFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RecordDetailsScreen(record: record),
                    ),
                  );
                  if (result == true) {
                    _loadRecords();
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00707D).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xFF00707D),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateHelper.formatDisplayDate(
                                DateHelper.parseDate(record.date),
                              ),
                              style: const TextStyle(
                                color: Color(0xFF002E34),
                                fontSize: 16,
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${record.steps} steps • ${record.calories} cal • ${record.water} ml',
                              style: const TextStyle(
                                color: Color(0xFF88A8AF),
                                fontSize: 14,
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF88A8AF),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8FDFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Filter Records',
            style: TextStyle(
              color: Color(0xFF002E34),
              fontSize: 20,
              fontFamily: 'Onest',
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterOption(
                icon: Icons.today_outlined,
                title: 'Single Date',
                onTap: () async {
                  Navigator.pop(context);
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _filterDate = DateHelper.formatDate(date);
                      _dateRange = null;
                    });
                    _applyFilter();
                  }
                },
              ),
              const SizedBox(height: 8),
              _buildFilterOption(
                icon: Icons.date_range_outlined,
                title: 'Date Range',
                onTap: () async {
                  Navigator.pop(context);
                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (range != null) {
                    setState(() {
                      _dateRange = range;
                      _filterDate = null;
                    });
                    _applyFilter();
                  }
                },
              ),
              const SizedBox(height: 8),
              _buildFilterOption(
                icon: Icons.clear_outlined,
                title: 'Clear Filter',
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _filterDate = null;
                    _dateRange = null;
                  });
                  _applyFilter();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5F3F6)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF00707D),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF002E34),
                  fontSize: 16,
                  fontFamily: 'Onest',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

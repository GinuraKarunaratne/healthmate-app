import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/helpers.dart';
import '../../models/health_record.dart';
import '../../providers/health_records_provider.dart';
import 'add_edit_record_screen.dart';

class RecordDetailsScreen extends StatelessWidget {
  final HealthRecord record;

  const RecordDetailsScreen({Key? key, required this.record}) : super(key: key);

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
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF002E34),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Record Details',
                      style: TextStyle(
                        color: Color(0xFF002E34),
                        fontSize: 26,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.w400,
                        height: 1,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF00707D),
                  ),
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AddEditRecordScreen(record: record),
                      ),
                    );
                    if (result == true && context.mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                ),
              ],
            ),
          ),
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Date Card with gradient
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF00707D),
                          Color(0xFF4ECDC4),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 48,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          DateHelper.formatDisplayDate(
                            DateHelper.parseDate(record.date),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontFamily: 'Onest',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Health Activity Summary',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontFamily: 'Onest',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Metrics Grid (2x2)
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Steps',
                          record.steps.toString(),
                          Icons.directions_walk_outlined,
                          const Color(0xFF00707D),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildMetricCard(
                          'Calories',
                          record.calories.toString(),
                          Icons.local_fire_department_outlined,
                          const Color(0xFFF2994A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Water',
                          '${(record.water / 1000).toStringAsFixed(1)}L',
                          Icons.water_drop_outlined,
                          const Color(0xFF56CCF2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildMetricCard(
                          'Water',
                          '${record.water}ml',
                          Icons.opacity,
                          const Color(0xFF4ECDC4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Detailed breakdown
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF8FDFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.analytics_outlined,
                              color: Color(0xFF00707D),
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Activity Breakdown',
                              style: TextStyle(
                                color: Color(0xFF002E34),
                                fontSize: 18,
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildDetailRow(
                          'Total Steps',
                          '${record.steps} steps',
                          Icons.directions_walk_outlined,
                          const Color(0xFF00707D),
                        ),
                        const Divider(height: 24, color: Color(0xFFE5F3F6)),
                        _buildDetailRow(
                          'Calories Burned',
                          '${record.calories} kcal',
                          Icons.local_fire_department_outlined,
                          const Color(0xFFF2994A),
                        ),
                        const Divider(height: 24, color: Color(0xFFE5F3F6)),
                        _buildDetailRow(
                          'Water Intake',
                          '${record.water} ml',
                          Icons.water_drop_outlined,
                          const Color(0xFF56CCF2),
                        ),
                        const Divider(height: 24, color: Color(0xFFE5F3F6)),
                        _buildDetailRow(
                          'Hydration',
                          '${(record.water / 1000).toStringAsFixed(2)} liters',
                          Icons.local_drink_outlined,
                          const Color(0xFF4ECDC4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Delete Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _handleDelete(context),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 50,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFE57373),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Delete Record',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Onest',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: const Color(0xFFF8FDFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontFamily: 'Onest',
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF88A8AF),
              fontSize: 12,
              fontFamily: 'Onest',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF88A8AF),
                  fontSize: 12,
                  fontFamily: 'Onest',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF002E34),
                  fontSize: 16,
                  fontFamily: 'Onest',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8FDFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Delete Record',
            style: TextStyle(
              color: Color(0xFF002E34),
              fontSize: 20,
              fontFamily: 'Onest',
              fontWeight: FontWeight.w500,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this record? This action cannot be undone.',
            style: TextStyle(
              color: Color(0xFF002E34),
              fontSize: 16,
              fontFamily: 'Onest',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF88A8AF),
                  fontSize: 16,
                  fontFamily: 'Onest',
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Color(0xFFE57373),
                  fontSize: 16,
                  fontFamily: 'Onest',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      final provider = Provider.of<HealthRecordsProvider>(context, listen: false);
      final success = await provider.deleteRecord(record.id!);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Record deleted successfully'),
              backgroundColor: Color(0xFF66BB6A),
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete record'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

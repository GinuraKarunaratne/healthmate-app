import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/helpers.dart';
import '../../models/sleep_session.dart';
import '../../providers/sleep_provider.dart';

class SleepTrackerScreen extends StatefulWidget {
  const SleepTrackerScreen({Key? key}) : super(key: key);

  @override
  State<SleepTrackerScreen> createState() => _SleepTrackerScreenState();
}

class _SleepTrackerScreenState extends State<SleepTrackerScreen> {
  DateTime? _startTime;
  DateTime? _endTime;
  int _quality = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SleepProvider>(context, listen: false).loadSessions();
    });
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
            child: const Text(
              'Sleep Tracker',
              style: TextStyle(
                color: Color(0xFF002E34),
                fontSize: 26,
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w400,
                height: 1,
                letterSpacing: -1,
              ),
            ),
          ),
          // Scrollable Content
          Expanded(
            child: Consumer<SleepProvider>(
              builder: (context, provider, _) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Add Sleep Session Card
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
                                  Icons.nightlight_outlined,
                                  color: Color(0xFF00707D),
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Add Sleep Session',
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
                            _buildTimePicker(
                              label: 'Start Time',
                              time: _startTime,
                              onSelect: (time) {
                                setState(() {
                                  _startTime = time;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildTimePicker(
                              label: 'End Time',
                              time: _endTime,
                              onSelect: (time) {
                                setState(() {
                                  _endTime = time;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Sleep Quality',
                              style: TextStyle(
                                color: Color(0xFF002E34),
                                fontSize: 16,
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(5, (index) {
                                final quality = index + 1;
                                final isSelected = quality <= _quality;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _quality = quality;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(
                                          gradient: isSelected
                                              ? const LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color(0xFF00707D),
                                                    Color(0xFF4ECDC4),
                                                  ],
                                                )
                                              : null,
                                          color: isSelected
                                              ? null
                                              : const Color(0xFFE5F3F6),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          isSelected ? Icons.star : Icons.star_outline,
                                          size: 28,
                                          color: isSelected
                                              ? Colors.white
                                              : const Color(0xFF88A8AF),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '$quality',
                                        style: TextStyle(
                                          color: isSelected
                                              ? const Color(0xFF00707D)
                                              : const Color(0xFF88A8AF),
                                          fontSize: 12,
                                          fontFamily: 'Onest',
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 20),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _handleAddSession,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 50,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF00707D),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Add Session',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Onest',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Statistics Card
                      _buildStatisticsCard(provider),
                      const SizedBox(height: 20),
                      const Text(
                        'Sleep History',
                        style: TextStyle(
                          color: Color(0xFF002E34),
                          fontSize: 18,
                          fontFamily: 'Onest',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (provider.sessions.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.bedtime_outlined,
                                  size: 64,
                                  color: Color(0xFF88A8AF),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No sleep sessions yet',
                                  style: TextStyle(
                                    color: Color(0xFF002E34),
                                    fontSize: 16,
                                    fontFamily: 'Onest',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Add your first session above',
                                  style: TextStyle(
                                    color: Color(0xFF88A8AF),
                                    fontSize: 14,
                                    fontFamily: 'Onest',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.sessions.length,
                          itemBuilder: (context, index) {
                            final session = provider.sessions[index];
                            return _buildSessionCard(session, provider);
                          },
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker({
    required String label,
    required DateTime? time,
    required Function(DateTime) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF002E34),
            fontSize: 14,
            fontFamily: 'Onest',
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: time ?? DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 7)),
                lastDate: DateTime.now(),
              );
              if (date != null && mounted) {
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(time ?? DateTime.now()),
                );
                if (selectedTime != null) {
                  onSelect(DateTime(
                    date.year,
                    date.month,
                    date.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  ));
                }
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE5F3F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time_outlined,
                    color: Color(0xFF00707D),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    time != null
                        ? DateHelper.formatDateTime(time)
                        : 'Select $label',
                    style: const TextStyle(
                      color: Color(0xFF002E34),
                      fontSize: 16,
                      fontFamily: 'Onest',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCard(SleepProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: const [
              Icon(
                Icons.nightlight,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Sleep Statistics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Onest',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Avg Duration',
                SleepHelper.formatDuration(
                  provider.getAverageDuration().toInt(),
                ),
                Icons.schedule_outlined,
              ),
              Container(
                width: 1,
                height: 60,
                color: Colors.white24,
              ),
              _buildStatItem(
                'Avg Quality',
                provider.getAverageQuality().toStringAsFixed(1),
                Icons.star_outline,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'Onest',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontFamily: 'Onest',
          ),
        ),
      ],
    );
  }

  Widget _buildSessionCard(SleepSession session, SleepProvider provider) {
    final startTime = DateTime.fromMillisecondsSinceEpoch(session.startTime);
    final endTime = DateTime.fromMillisecondsSinceEpoch(session.endTime);

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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF00707D),
                      Color(0xFF4ECDC4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.nightlight,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateHelper.formatDisplayDate(startTime),
                      style: const TextStyle(
                        color: Color(0xFF002E34),
                        fontSize: 16,
                        fontFamily: 'Onest',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${DateHelper.formatTime(startTime)} - ${DateHelper.formatTime(endTime)}',
                      style: const TextStyle(
                        color: Color(0xFF88A8AF),
                        fontSize: 14,
                        fontFamily: 'Onest',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 14,
                          color: Color(0xFF00707D),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          SleepHelper.formatDuration(session.durationMinutes),
                          style: const TextStyle(
                            color: Color(0xFF00707D),
                            fontSize: 12,
                            fontFamily: 'Onest',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 16),
                        ...List.generate(
                          5,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: Icon(
                              index < session.quality ? Icons.star : Icons.star_outline,
                              size: 14,
                              color: index < session.quality
                                  ? const Color(0xFF00707D)
                                  : const Color(0xFF88A8AF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFE57373),
                ),
                onPressed: () => _handleDelete(session.id!, provider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleAddSession() async {
    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both start and end time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_endTime!.isBefore(_startTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End time must be after start time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final duration = SleepHelper.calculateDuration(_startTime!, _endTime!);
    final session = SleepSession(
      startTime: _startTime!.millisecondsSinceEpoch,
      endTime: _endTime!.millisecondsSinceEpoch,
      durationMinutes: duration,
      quality: _quality,
      date: DateHelper.formatDate(_endTime!),
    );

    final provider = Provider.of<SleepProvider>(context, listen: false);
    final success = await provider.addSession(session);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sleep session added successfully'),
          backgroundColor: Color(0xFF66BB6A),
        ),
      );
      setState(() {
        _startTime = null;
        _endTime = null;
        _quality = 3;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Failed to add session'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleDelete(int id, SleepProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8FDFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Delete Session',
            style: TextStyle(
              color: Color(0xFF002E34),
              fontSize: 20,
              fontFamily: 'Onest',
              fontWeight: FontWeight.w500,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this sleep session?',
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

    if (confirmed == true) {
      final success = await provider.deleteSession(id);
      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session deleted successfully'),
            backgroundColor: Color(0xFF66BB6A),
          ),
        );
      }
    }
  }
}

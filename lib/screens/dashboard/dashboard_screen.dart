import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/health_record.dart';
import '../../providers/health_records_provider.dart';
import '../../providers/sleep_provider.dart';
import '../records/records_list_screen.dart';
import '../sleep/sleep_tracker_screen.dart';
import '../medication/medication_tracker_screen.dart';
import '../profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardHomeScreen();
      case 1:
        return const RecordsListScreen();
      case 2:
        return const SleepTrackerScreen();
      case 3:
        return const MedicationTrackerScreen();
      default:
        return const DashboardHomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedScreen(),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF00707D),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.dashboard, 0),
            _buildNavItem(Icons.article, 1),
            _buildNavItem(Icons.nightlight, 2),
            _buildNavItem(Icons.medication, 3),
            _buildNavItem(Icons.person, 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 4) {
          // Navigate to profile screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
          size: 26,
        ),
      ),
    );
  }
}

class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({super.key});

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen> {
  HealthRecord? _todayRecord;
  List<HealthRecord> _weeklyRecords = [];
  bool _isLoading = false;
  int _waterGoal = 2000;

  @override
  void initState() {
    super.initState();
    _loadWaterGoal();
    _loadData();
  }

  Future<void> _loadWaterGoal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _waterGoal = prefs.getInt('water_goal') ?? 2000;
    });
  }

  Future<void> _saveWaterGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('water_goal', goal);
    setState(() {
      _waterGoal = goal;
    });
  }

  Future<void> _loadData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final healthProvider =
          Provider.of<HealthRecordsProvider>(context, listen: false);

      await healthProvider.loadRecords();
      final todayRecord = await healthProvider.loadTodayRecord();
      final weeklyRecords = await healthProvider.getLast7DaysRecords();

      if (mounted) {
        setState(() {
          _todayRecord = todayRecord;
          _weeklyRecords = weeklyRecords;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF8FB),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Builder(
              builder: (context) {
                final healthProvider =
                    Provider.of<HealthRecordsProvider>(context, listen: false);
                final stats = healthProvider.getTodayStats(_todayRecord);

                return Column(
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: 60,
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      color: const Color(0xFFEAF8FB),
                      child: SvgPicture.asset(
                        'assets/logo.svg',
                        width: 80,
                        height: 30,
                      ),
                    ),

                    // Content
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadData,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                const Text(
                                  'Todays Activity',
                                  style: TextStyle(
                                    color: Color(0xFF002E34),
                                    fontSize: 26,
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const SizedBox(height: 25),

                                // Stats Grid (4 cards)
                                Wrap(
                                  alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.start,
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    _buildStatCard(
                                      value: '${stats['steps'] ?? 0}',
                                      label: 'Step Count',
                                      icon: Icons.directions_walk_outlined,
                                    ),
                                    _buildStatCard(
                                      value: '${stats['calories'] ?? 0}',
                                      label: 'Calories',
                                      icon: Icons.local_fire_department_outlined,
                                    ),
                                    _buildStatCard(
                                      value:
                                          '${((stats['water'] ?? 0) / 1000).toStringAsFixed(1)}L',
                                      label: 'Water Intake',
                                      icon: Icons.water_drop_outlined,
                                    ),
                                    _buildStatCard(
                                      value: _getSleepQuality(context),
                                      label: 'Sleep Quality',
                                      icon: Icons.bedtime_outlined,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),

                                const Text(
                                  'Weekly Progress',
                                  style: TextStyle(
                                    color: Color(0xFF002E34),
                                    fontSize: 26,
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                // Weekly Progress - Steps
                                _buildWeeklyProgressCard('Steps', 'steps'),
                                const SizedBox(height: 20),

                                // Weekly Progress - Calories
                                _buildWeeklyProgressCard('Calories', 'calories'),
                                const SizedBox(height: 20),

                                // Water Intake Gauge
                                _buildWaterIntakeCard(
                                  stats['water'] ?? 0,
                                  _waterGoal,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  // === STAT GRID CARD ===
  Widget _buildStatCard({
    required String value,
    required String label,
    required IconData icon,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate width: screen width - (left padding + right padding + gap)
    final cardWidth = (screenWidth - 50) / 2;

    return Container(
      width: cardWidth,
      height: 171,
      padding: const EdgeInsets.all(20),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0xFFF8FDFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon top-left (small, teal-ish)
          Icon(
            icon,
            size: 24,
            color: const Color(0xFF00707D),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF002E34),
                  fontSize: 32,
                  fontFamily: 'Onest',
                  fontWeight: FontWeight.w500,
                  height: 1,
                  letterSpacing: -0.70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Onest',
                  fontWeight: FontWeight.w400,
                  height: 1,
                  letterSpacing: -0.70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // === WEEKLY PROGRESS CARD ===
  Widget _buildWeeklyProgressCard(String title, String dataType) {
    final icon = dataType == 'steps'
        ? Icons.directions_walk_outlined
        : Icons.local_fire_department_outlined;

    return Container(
      width: double.infinity,
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
          // Title + icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Progress - $title',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Onest',
                  fontWeight: FontWeight.w400,
                  height: 1,
                  letterSpacing: -0.70,
                ),
              ),
              Icon(
                icon,
                color: const Color(0xFF00707D),
                size: 24,
              ),
            ],
          ),
          const SizedBox(height: 30),
          _weeklyRecords.isEmpty
              ? const SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(
                        color: Color(0xFF88A8AF),
                        fontSize: 14,
                        fontFamily: 'Onest',
                      ),
                    ),
                  ),
                )
              : _buildSimpleBarChart(dataType),
        ],
      ),
    );
  }

  Widget _buildSimpleBarChart(String dataType) {
    if (_weeklyRecords.isEmpty) return const SizedBox.shrink();

    // Get max value for scaling based on data type
    final maxValue = _weeklyRecords.fold<int>(
      0,
      (max, record) {
        final value = dataType == 'steps' ? record.steps : record.calories;
        return value > max ? value : max;
      },
    );

    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: _weeklyRecords.map((record) {
          final value = dataType == 'steps' ? record.steps : record.calories;
          final heightPercentage = maxValue > 0 ? value / maxValue : 0.0;
          final barHeight = 100 * heightPercentage;

          return Container(
            width: 30,
            height: barHeight,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Color(0xFF00707D),
                  Color(0xFF4ECDC4),
                ],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }).toList(),
      ),
    );
  }

  // === WATER INTAKE CARD (circle + text) ===
  Widget _buildWaterIntakeCard(int currentWater, int goalWater) {
    final percentage =
        goalWater > 0 ? (currentWater / goalWater).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: double.infinity,
      height: 210,
      color: Colors.transparent,
      child: Stack(
        children: [
          // Circle gauge on left
          Positioned(
            left: 0,
            top: 20,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(130, 130),
                  painter: WaterCircleProgressPainter(percentage),
                ),
                Icon(
                  Icons.water_drop,
                  size: 40,
                  color: Colors.white.withOpacity(0.9),
                ),
              ],
            ),
          ),

          // Text on right
          Positioned(
            left: 160,
            top: 35,
            child: SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Water Intake',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Onest',
                      fontWeight: FontWeight.w400,
                      height: 1,
                      letterSpacing: -0.73,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _showEditWaterGoalDialog(context),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '$currentWater',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontFamily: 'Onest',
                              fontWeight: FontWeight.w400,
                              height: 1,
                              letterSpacing: -0.73,
                            ),
                          ),
                          TextSpan(
                            text: '/$goalWater ML',
                            style: const TextStyle(
                              color: Color(0xFF88A8AF),
                              fontSize: 25,
                              fontFamily: 'Onest',
                              fontWeight: FontWeight.w400,
                              height: 1,
                              letterSpacing: -0.73,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Add Water Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecordsListScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00707D),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Add Water',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
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

  String _getSleepQuality(BuildContext context) {
    final sleepProvider = Provider.of<SleepProvider>(context, listen: false);
    final avgQuality = sleepProvider.getAverageQuality();
    return avgQuality > 0 ? avgQuality.toStringAsFixed(1) : 'N/A';
  }

  Future<void> _showEditWaterGoalDialog(BuildContext context) async {
    final controller = TextEditingController(text: _waterGoal.toString());

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF8FDFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          'Edit Water Goal',
          style: TextStyle(
            color: Color(0xFF002E34),
            fontSize: 20,
            fontFamily: 'Onest',
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Water Goal (ml)',
              style: TextStyle(
                color: Color(0xFF002E34),
                fontSize: 14,
                fontFamily: 'Onest',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(
                color: Color(0xFF002E34),
                fontSize: 16,
                fontFamily: 'Onest',
              ),
              decoration: InputDecoration(
                hintText: 'Enter goal in ml',
                hintStyle: const TextStyle(
                  color: Color(0xFF88A8AF),
                  fontSize: 16,
                  fontFamily: 'Onest',
                ),
                border: InputBorder.none,
                filled: true,
                fillColor: const Color(0xFFE5F3F6),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF00707D),
                    width: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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
            onPressed: () {
              final newGoal = int.tryParse(controller.text);
              if (newGoal != null && newGoal > 0) {
                _saveWaterGoal(newGoal);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid number'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFF00707D),
                fontSize: 16,
                fontFamily: 'Onest',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// === WATER CIRCLE PAINTER (semi-filled gauge) ===
class WaterCircleProgressPainter extends CustomPainter {
  final double percentage;

  WaterCircleProgressPainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background circle (top half light, like Figma)
    final bgPaint = Paint()
      ..color = const Color(0xFFA1DCE8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Water fill gradient from bottom upwards
    if (percentage > 0) {
      final waterHeight = size.height * percentage;
      final waterTop = size.height - waterHeight;

      final waterRect = Rect.fromLTWH(0, waterTop, size.width, waterHeight);

      final waterPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: const [
            Color(0xFF00707D),
            Color(0xFF4ECDC4),
          ],
        ).createShader(waterRect)
        ..style = PaintingStyle.fill;

      // Clip to circle and draw the water
      canvas.save();
      canvas.clipPath(Path()..addOval(rect));
      canvas.drawRect(waterRect, waterPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(WaterCircleProgressPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}

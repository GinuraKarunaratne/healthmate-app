import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/constants.dart';
import '../models/health_record.dart';
import '../core/helpers.dart';

class WeeklyChart extends StatefulWidget {
  final List<HealthRecord> records;
  final String dataType;
  final Color color;

  const WeeklyChart({
    Key? key,
    required this.records,
    required this.dataType,
    required this.color,
  }) : super(key: key);

  @override
  State<WeeklyChart> createState() => _WeeklyChartState();
}

class _WeeklyChartState extends State<WeeklyChart> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last 7 Days - ${_getTitle()}',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: widget.records.isEmpty
                      ? const Center(
                          child: Text(
                            'No data available',
                            style: AppTextStyles.body2,
                          ),
                        )
                      : LineChart(
                          _buildLineChartData(),
                          duration: const Duration(milliseconds: 300),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getTitle() {
    switch (widget.dataType) {
      case 'steps':
        return 'Steps';
      case 'calories':
        return 'Calories';
      case 'water':
        return 'Water (ml)';
      default:
        return widget.dataType;
    }
  }

  double _getValue(HealthRecord record) {
    switch (widget.dataType) {
      case 'steps':
        return record.steps.toDouble();
      case 'calories':
        return record.calories.toDouble();
      case 'water':
        return record.water.toDouble();
      default:
        return 0;
    }
  }

  LineChartData _buildLineChartData() {
    final spots = <FlSpot>[];
    for (int i = 0; i < widget.records.length; i++) {
      final value = _getValue(widget.records[i]) * _animation.value;
      spots.add(FlSpot(i.toDouble(), value));
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: null,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.border,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: AppTextStyles.caption,
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < widget.records.length) {
                final date = DateHelper.parseDate(widget.records[value.toInt()].date);
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${date.day}/${date.month}',
                    style: AppTextStyles.caption,
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.4,
          color: widget.color,
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: widget.color,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: widget.color.withOpacity(0.2),
            gradient: LinearGradient(
              colors: [
                widget.color.withOpacity(0.3),
                widget.color.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }
}

class SleepVisualization extends StatefulWidget {
  final double averageHours;
  final double averageQuality;
  final Color color;

  const SleepVisualization({
    super.key,
    required this.averageHours,
    required this.averageQuality,
    required this.color,
  });

  @override
  State<SleepVisualization> createState() => _SleepVisualizationState();
}

class _SleepVisualizationState extends State<SleepVisualization> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sleep Overview',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCircularIndicator(
                      value: widget.averageHours / 12,
                      label: 'Avg Hours',
                      displayValue: widget.averageHours.toStringAsFixed(1),
                      icon: Icons.bedtime,
                    ),
                    _buildCircularIndicator(
                      value: widget.averageQuality / 10,
                      label: 'Quality',
                      displayValue: widget.averageQuality.toStringAsFixed(1),
                      icon: Icons.star,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSleepInsight(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCircularIndicator({
    required double value,
    required String label,
    required String displayValue,
    required IconData icon,
  }) {
    final animatedValue = value * _animation.value;

    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: animatedValue,
                  strokeWidth: 12,
                  backgroundColor: widget.color.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: widget.color, size: 28),
                  const SizedBox(height: 4),
                  Text(
                    displayValue,
                    style: AppTextStyles.heading2.copyWith(
                      color: widget.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.body2,
        ),
      ],
    );
  }

  Widget _buildSleepInsight() {
    String insight;
    IconData insightIcon;
    Color insightColor;

    if (widget.averageHours < 6) {
      insight = 'You need more sleep. Aim for 7-9 hours.';
      insightIcon = Icons.warning_amber_rounded;
      insightColor = AppColors.error;
    } else if (widget.averageHours >= 7 && widget.averageHours <= 9) {
      insight = 'Great! You\'re getting enough sleep.';
      insightIcon = Icons.check_circle;
      insightColor = AppColors.success;
    } else {
      insight = 'Consider adjusting your sleep schedule.';
      insightIcon = Icons.info_outline;
      insightColor = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: insightColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(insightIcon, color: insightColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              insight,
              style: AppTextStyles.body2.copyWith(color: insightColor),
            ),
          ),
        ],
      ),
    );
  }
}

class WaterWaveVisualization extends StatefulWidget {
  final int currentWater;
  final int goalWater;
  final Color color;

  const WaterWaveVisualization({
    super.key,
    required this.currentWater,
    required this.goalWater,
    required this.color,
  });

  @override
  State<WaterWaveVisualization> createState() => _WaterWaveVisualizationState();
}

class _WaterWaveVisualizationState extends State<WaterWaveVisualization> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = widget.goalWater > 0
        ? (widget.currentWater / widget.goalWater).clamp(0.0, 1.0)
        : 0.0;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Water Intake',
                  style: AppTextStyles.heading3,
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: widget.color.withOpacity(0.3), width: 3),
                          ),
                        ),
                        ClipOval(
                          child: SizedBox(
                            width: 150,
                            height: 150,
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  height: 150 * percentage * _animation.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          widget.color.withOpacity(0.7),
                                          widget.color.withOpacity(0.3),
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.water_drop, color: widget.color, size: 36),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${(percentage * 100).toInt()}%',
                                        style: AppTextStyles.heading1.copyWith(
                                          color: widget.color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${widget.currentWater}/${widget.goalWater} ml',
                                        style: AppTextStyles.body2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

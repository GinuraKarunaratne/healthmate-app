import 'package:flutter/material.dart';
import '../core/constants.dart';

class StatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 24),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  widget.value,
                  style: AppTextStyles.heading2.copyWith(
                    color: widget.color,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.title,
                style: AppTextStyles.body2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

class ProgressStatCard extends StatefulWidget {
  final String title;
  final int current;
  final int goal;
  final IconData icon;
  final Color color;

  const ProgressStatCard({
    super.key,
    required this.title,
    required this.current,
    required this.goal,
    required this.icon,
    required this.color,
  });

  @override
  State<ProgressStatCard> createState() => _ProgressStatCardState();
}

class _ProgressStatCardState extends State<ProgressStatCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _progressAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.goal > 0 ? (widget.current / widget.goal).clamp(0.0, 1.0) : 0.0;

    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(widget.icon, color: widget.color, size: 24),
                    const SizedBox(width: 8),
                    Text(widget.title, style: AppTextStyles.heading3),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '${widget.current}',
                      style: AppTextStyles.heading2.copyWith(color: widget.color),
                    ),
                    Text(
                      ' / ${widget.goal}',
                      style: AppTextStyles.body2,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress * _progressAnimation.value,
                  backgroundColor: widget.color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}% complete',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

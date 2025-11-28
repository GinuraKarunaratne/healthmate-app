import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/helpers.dart';
import '../../providers/goals_provider.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _stepGoalController = TextEditingController();
  final _waterGoalController = TextEditingController();
  final _targetWeightController = TextEditingController();

  bool _hasLoadedGoals = false;

  void _loadGoalsIfNeeded() {
    if (_hasLoadedGoals) return;

    final provider = Provider.of<GoalsProvider>(context, listen: false);

    if (provider.isLoading) {
      return;
    }

    _hasLoadedGoals = true;

    Future.microtask(() {
      if (!mounted) return;
      _stepGoalController.text = provider.dailyStepGoal.toString();
      _waterGoalController.text = provider.dailyWaterGoalMl.toString();
      _targetWeightController.text = provider.targetWeight.toString();
    });
  }

  @override
  void dispose() {
    _stepGoalController.dispose();
    _waterGoalController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<GoalsProvider>(context, listen: false);
    final success = await provider.updateGoal(
      int.parse(_stepGoalController.text),
      int.parse(_waterGoalController.text),
      double.parse(_targetWeightController.text),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Goals updated successfully'),
          backgroundColor: Color(0xFF66BB6A),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Failed to update goals'),
          backgroundColor: Colors.red,
        ),
      );
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
            child: const Text(
              'Goals & Settings',
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
            child: Consumer<GoalsProvider>(
              builder: (context, provider, _) {
                if (!provider.isLoading) {
                  _loadGoalsIfNeeded();
                }

                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF00707D),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Daily Goals Card
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
                                    Icons.flag_outlined,
                                    color: Color(0xFF00707D),
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Daily Goals',
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
                              _buildTextField(
                                label: 'Daily Step Goal',
                                hint: 'Enter target steps per day',
                                controller: _stepGoalController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (value) => ValidationHelper.validateNumber(
                                  value,
                                  'Step goal',
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                label: 'Daily Water Goal (ml)',
                                hint: 'Enter target water intake in ml',
                                controller: _waterGoalController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (value) => ValidationHelper.validateNumber(
                                  value,
                                  'Water goal',
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildTextField(
                                label: 'Target Weight (kg)',
                                hint: 'Enter your target weight',
                                controller: _targetWeightController,
                                keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                validator: (value) => ValidationHelper.validateDouble(
                                  value,
                                  'Target weight',
                                ),
                              ),
                              const SizedBox(height: 20),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _handleSave,
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
                                        'Save Goals',
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
                        // Current Goals Card
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
                                    Icons.info_outlined,
                                    color: Color(0xFF00707D),
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Current Goals',
                                    style: TextStyle(
                                      color: Color(0xFF002E34),
                                      fontSize: 18,
                                      fontFamily: 'Onest',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildGoalInfoItem(
                                'Daily Steps',
                                '${provider.dailyStepGoal} steps',
                                Icons.directions_walk_outlined,
                                const Color(0xFF00707D),
                              ),
                              const SizedBox(height: 12),
                              _buildGoalInfoItem(
                                'Daily Water',
                                '${provider.dailyWaterGoalMl} ml',
                                Icons.water_drop_outlined,
                                const Color(0xFF00707D),
                              ),
                              const SizedBox(height: 12),
                              _buildGoalInfoItem(
                                'Target Weight',
                                '${provider.targetWeight.toStringAsFixed(1)} kg',
                                Icons.monitor_weight_outlined,
                                const Color(0xFF00707D),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Recommendations Card
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
                              const Text(
                                'Recommended Daily Goals',
                                style: TextStyle(
                                  color: Color(0xFF002E34),
                                  fontSize: 18,
                                  fontFamily: 'Onest',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildRecommendationItem(
                                'Steps: 10,000 steps/day for general health',
                              ),
                              const SizedBox(height: 12),
                              _buildRecommendationItem(
                                'Water: 2,000-2,500 ml/day for adults',
                              ),
                              const SizedBox(height: 12),
                              _buildRecommendationItem(
                                'Weight: Consult healthcare professional for healthy range',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          style: const TextStyle(
            color: Color(0xFF002E34),
            fontSize: 16,
            fontFamily: 'Onest',
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF88A8AF),
              fontSize: 16,
              fontFamily: 'Onest',
            ),
            border: InputBorder.none,
            filled: true,
            fillColor: const Color(0xFFE5F3F6),
            contentPadding: const EdgeInsets.only(
              top: 16,
              bottom: 16,
              left: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF00707D), width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalInfoItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
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
                  fontSize: 14,
                  fontFamily: 'Onest',
                ),
              ),
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

  Widget _buildRecommendationItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline,
          size: 16,
          color: Color(0xFF66BB6A),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF002E34),
              fontSize: 15,
              fontFamily: 'Onest',
            ),
          ),
        ),
      ],
    );
  }
}

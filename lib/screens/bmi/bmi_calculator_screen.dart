import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bmi_provider.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({Key? key}) : super(key: key);

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BMIProvider>(context, listen: false).loadSavedValues();
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
              'BMI Calculator',
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
            child: Consumer<BMIProvider>(
              builder: (context, provider, _) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Input Card
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
                              'Height (cm)',
                              style: TextStyle(
                                color: Color(0xFF002E34),
                                fontSize: 16,
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor: const Color(0xFF00707D),
                                      inactiveTrackColor: const Color(0xFFE5F3F6),
                                      thumbColor: const Color(0xFF00707D),
                                      overlayColor: const Color(0xFF00707D).withOpacity(0.2),
                                      trackHeight: 4,
                                    ),
                                    child: Slider(
                                      value: provider.height,
                                      min: 100,
                                      max: 250,
                                      divisions: 150,
                                      label: '${provider.height.toInt()} cm',
                                      onChanged: (value) {
                                        provider.setHeight(value);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: Text(
                                    '${provider.height.toInt()}',
                                    style: const TextStyle(
                                      color: Color(0xFF00707D),
                                      fontSize: 20,
                                      fontFamily: 'Onest',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Weight (kg)',
                              style: TextStyle(
                                color: Color(0xFF002E34),
                                fontSize: 16,
                                fontFamily: 'Onest',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                      activeTrackColor: const Color(0xFF00707D),
                                      inactiveTrackColor: const Color(0xFFE5F3F6),
                                      thumbColor: const Color(0xFF00707D),
                                      overlayColor: const Color(0xFF00707D).withOpacity(0.2),
                                      trackHeight: 4,
                                    ),
                                    child: Slider(
                                      value: provider.weight,
                                      min: 30,
                                      max: 200,
                                      divisions: 170,
                                      label: '${provider.weight.toInt()} kg',
                                      onChanged: (value) {
                                        provider.setWeight(value);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: Text(
                                    '${provider.weight.toInt()}',
                                    style: const TextStyle(
                                      color: Color(0xFF00707D),
                                      fontSize: 20,
                                      fontFamily: 'Onest',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: provider.calculateBMI,
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
                                      'Calculate BMI',
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
                      if (provider.bmi > 0) ...[
                        const SizedBox(height: 20),
                        // BMI Result Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF8FDFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Your BMI',
                                style: TextStyle(
                                  color: Color(0xFF88A8AF),
                                  fontSize: 14,
                                  fontFamily: 'Onest',
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                provider.bmi.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 48,
                                  fontFamily: 'Onest',
                                  fontWeight: FontWeight.w700,
                                  color: _getBMIColor(provider.category),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _getBMIColor(provider.category).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  provider.category,
                                  style: TextStyle(
                                    color: _getBMIColor(provider.category),
                                    fontSize: 16,
                                    fontFamily: 'Onest',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildBMIScale(provider.bmi),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Recommendation Card
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
                                children: [
                                  Icon(
                                    Icons.info_outlined,
                                    color: const Color(0xFF00707D),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Recommendation',
                                    style: TextStyle(
                                      color: Color(0xFF002E34),
                                      fontSize: 18,
                                      fontFamily: 'Onest',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                provider.recommendation,
                                style: const TextStyle(
                                  color: Color(0xFF002E34),
                                  fontSize: 15,
                                  fontFamily: 'Onest',
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // BMI Categories Card
                        _buildBMIRangesCard(),
                      ],
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

  Widget _buildBMIScale(double bmi) {
    final screenWidth = MediaQuery.of(context).size.width - 80;
    return Column(
      children: [
        Container(
          height: 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF56CCF2),
                Color(0xFF6FCF97),
                Color(0xFFF2C94C),
                Color(0xFFF2994A),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: ((bmi - 10) / 30 * screenWidth).clamp(0, screenWidth - 24),
              ),
              child: const Icon(
                Icons.arrow_drop_down,
                color: Color(0xFF002E34),
                size: 32,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              '10',
              style: TextStyle(
                color: Color(0xFF88A8AF),
                fontSize: 12,
                fontFamily: 'Onest',
              ),
            ),
            Text(
              '18.5',
              style: TextStyle(
                color: Color(0xFF88A8AF),
                fontSize: 12,
                fontFamily: 'Onest',
              ),
            ),
            Text(
              '25',
              style: TextStyle(
                color: Color(0xFF88A8AF),
                fontSize: 12,
                fontFamily: 'Onest',
              ),
            ),
            Text(
              '30',
              style: TextStyle(
                color: Color(0xFF88A8AF),
                fontSize: 12,
                fontFamily: 'Onest',
              ),
            ),
            Text(
              '40+',
              style: TextStyle(
                color: Color(0xFF88A8AF),
                fontSize: 12,
                fontFamily: 'Onest',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBMIRangesCard() {
    return Container(
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
            'BMI Categories',
            style: TextStyle(
              color: Color(0xFF002E34),
              fontSize: 18,
              fontFamily: 'Onest',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          _buildBMIRangeItem(
            'Underweight',
            '< 18.5',
            const Color(0xFF56CCF2),
          ),
          const SizedBox(height: 12),
          _buildBMIRangeItem(
            'Normal',
            '18.5 - 24.9',
            const Color(0xFF6FCF97),
          ),
          const SizedBox(height: 12),
          _buildBMIRangeItem(
            'Overweight',
            '25.0 - 29.9',
            const Color(0xFFF2C94C),
          ),
          const SizedBox(height: 12),
          _buildBMIRangeItem(
            'Obese',
            '≥ 30.0',
            const Color(0xFFF2994A),
          ),
        ],
      ),
    );
  }

  Widget _buildBMIRangeItem(String category, String range, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            category,
            style: const TextStyle(
              color: Color(0xFF002E34),
              fontSize: 15,
              fontFamily: 'Onest',
            ),
          ),
        ),
        Text(
          range,
          style: const TextStyle(
            color: Color(0xFF88A8AF),
            fontSize: 14,
            fontFamily: 'Onest',
          ),
        ),
      ],
    );
  }

  Color _getBMIColor(String category) {
    switch (category) {
      case 'Underweight':
        return const Color(0xFF56CCF2);
      case 'Normal':
        return const Color(0xFF6FCF97);
      case 'Overweight':
        return const Color(0xFFF2C94C);
      case 'Obese':
        return const Color(0xFFF2994A);
      default:
        return const Color(0xFF002E34);
    }
  }
}

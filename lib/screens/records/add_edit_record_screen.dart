import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/helpers.dart';
import '../../models/health_record.dart';
import '../../providers/health_records_provider.dart';

class AddEditRecordScreen extends StatefulWidget {
  final HealthRecord? record;

  const AddEditRecordScreen({Key? key, this.record}) : super(key: key);

  @override
  State<AddEditRecordScreen> createState() => _AddEditRecordScreenState();
}

class _AddEditRecordScreenState extends State<AddEditRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  final _stepsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _waterController = TextEditingController();

  bool get isEditing => widget.record != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _selectedDate = DateHelper.parseDate(widget.record!.date);
      _stepsController.text = widget.record!.steps.toString();
      _caloriesController.text = widget.record!.calories.toString();
      _waterController.text = widget.record!.water.toString();
    } else {
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _stepsController.dispose();
    _caloriesController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final record = HealthRecord(
      id: widget.record?.id,
      date: DateHelper.formatDate(_selectedDate),
      steps: int.parse(_stepsController.text),
      calories: int.parse(_caloriesController.text),
      water: int.parse(_waterController.text),
    );

    final provider = Provider.of<HealthRecordsProvider>(context, listen: false);
    final success = isEditing
        ? await provider.updateRecord(record)
        : await provider.addRecord(record);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing ? 'Record updated successfully' : 'Record added successfully',
          ),
          backgroundColor: const Color(0xFF66BB6A),
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save record'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
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
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF002E34),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Text(
                  isEditing ? 'Edit Record' : 'Add Record',
                  style: const TextStyle(
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
          ),
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Date Selector Card
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
                            'Date',
                            style: TextStyle(
                              color: Color(0xFF002E34),
                              fontSize: 16,
                              fontFamily: 'Onest',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _selectDate,
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
                                      Icons.calendar_today_outlined,
                                      color: Color(0xFF00707D),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      DateHelper.formatDisplayDate(_selectedDate),
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
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Health Data Card
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
                            'Health Data',
                            style: TextStyle(
                              color: Color(0xFF002E34),
                              fontSize: 18,
                              fontFamily: 'Onest',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            label: 'Steps',
                            hint: 'Enter steps count',
                            controller: _stepsController,
                            icon: Icons.directions_walk_outlined,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Calories',
                            hint: 'Enter calories burned',
                            controller: _caloriesController,
                            icon: Icons.local_fire_department_outlined,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Water (ml)',
                            hint: 'Enter water intake in ml',
                            controller: _waterController,
                            icon: Icons.water_drop_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Save Button
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
                          child: Center(
                            child: Text(
                              isEditing ? 'Update Record' : 'Add Record',
                              style: const TextStyle(
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
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
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF00707D),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF002E34),
                fontSize: 14,
                fontFamily: 'Onest',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
          validator: (value) => ValidationHelper.validateNumber(value, label),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/medication.dart';
import '../../providers/medication_provider.dart';

class MedicationTrackerScreen extends StatefulWidget {
  const MedicationTrackerScreen({Key? key}) : super(key: key);

  @override
  State<MedicationTrackerScreen> createState() =>
      _MedicationTrackerScreenState();
}

class _MedicationTrackerScreenState extends State<MedicationTrackerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MedicationProvider>(context, listen: false).loadMedications();
    });
  }

  void _showAddMedicationDialog() {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    final notesController = TextEditingController();
    String frequency = 'daily';
    String timeOfDay = 'morning';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFFF8FDFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: const Text(
            'Add Medication',
            style: TextStyle(
              color: Color(0xFF002E34),
              fontSize: 20,
              fontFamily: 'Onest',
              fontWeight: FontWeight.w500,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogTextField(
                  label: 'Medication Name',
                  controller: nameController,
                  hint: 'e.g., Aspirin',
                ),
                const SizedBox(height: 16),
                _buildDialogTextField(
                  label: 'Dosage',
                  controller: dosageController,
                  hint: 'e.g., 500mg',
                ),
                const SizedBox(height: 16),
                const Text(
                  'Frequency',
                  style: TextStyle(
                    color: Color(0xFF002E34),
                    fontSize: 14,
                    fontFamily: 'Onest',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F3F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: frequency,
                    isExpanded: true,
                    underline: const SizedBox(),
                    style: const TextStyle(
                      color: Color(0xFF002E34),
                      fontSize: 16,
                      fontFamily: 'Onest',
                    ),
                    dropdownColor: const Color(0xFFF8FDFF),
                    items: const [
                      DropdownMenuItem(value: 'daily', child: Text('Daily')),
                      DropdownMenuItem(
                          value: 'twice_daily', child: Text('Twice Daily')),
                      DropdownMenuItem(
                          value: 'three_times', child: Text('Three Times Daily')),
                      DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                      DropdownMenuItem(
                          value: 'as_needed', child: Text('As Needed')),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        frequency = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Time of Day',
                  style: TextStyle(
                    color: Color(0xFF002E34),
                    fontSize: 14,
                    fontFamily: 'Onest',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F3F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: timeOfDay,
                    isExpanded: true,
                    underline: const SizedBox(),
                    style: const TextStyle(
                      color: Color(0xFF002E34),
                      fontSize: 16,
                      fontFamily: 'Onest',
                    ),
                    dropdownColor: const Color(0xFFF8FDFF),
                    items: const [
                      DropdownMenuItem(value: 'morning', child: Text('Morning')),
                      DropdownMenuItem(
                          value: 'afternoon', child: Text('Afternoon')),
                      DropdownMenuItem(value: 'evening', child: Text('Evening')),
                      DropdownMenuItem(value: 'night', child: Text('Night')),
                      DropdownMenuItem(
                          value: 'anytime', child: Text('Anytime')),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        timeOfDay = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _buildDialogTextField(
                  label: 'Notes (Optional)',
                  controller: notesController,
                  hint: 'e.g., Take with food',
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF88A8AF),
                  fontFamily: 'Onest',
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  if (nameController.text.isEmpty ||
                      dosageController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in required fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final medication = Medication(
                    name: nameController.text,
                    dosage: dosageController.text,
                    frequency: frequency,
                    timeOfDay: timeOfDay,
                    notes: notesController.text.isEmpty
                        ? null
                        : notesController.text,
                  );

                  final provider =
                      Provider.of<MedicationProvider>(context, listen: false);
                  final success = await provider.addMedication(medication);

                  if (success && mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Medication added successfully'),
                        backgroundColor: Color(0xFF66BB6A),
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00707D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Onest',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
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
        TextField(
          controller: controller,
          maxLines: maxLines,
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
            contentPadding: const EdgeInsets.all(12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF00707D), width: 1),
            ),
          ),
        ),
      ],
    );
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
                  'Medication Tracker',
                  style: TextStyle(
                    color: Color(0xFF002E34),
                    fontSize: 26,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w400,
                    height: 1,
                    letterSpacing: -1,
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _showAddMedicationDialog,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00707D),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Scrollable Content
          Expanded(
            child: Consumer<MedicationProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF00707D),
                    ),
                  );
                }

                if (provider.medications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medication_outlined,
                          size: 64,
                          color: const Color(0xFF88A8AF).withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No medications added yet',
                          style: TextStyle(
                            color: Color(0xFF88A8AF),
                            fontSize: 16,
                            fontFamily: 'Onest',
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap + to add your first medication',
                          style: TextStyle(
                            color: Color(0xFF88A8AF),
                            fontSize: 14,
                            fontFamily: 'Onest',
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: provider.loadMedications,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      // Active Medications
                      if (provider.activeMedications.isNotEmpty) ...[
                        const Text(
                          'Active Medications',
                          style: TextStyle(
                            color: Color(0xFF002E34),
                            fontSize: 18,
                            fontFamily: 'Onest',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...provider.activeMedications
                            .map((med) => _buildMedicationCard(med, provider)),
                      ],

                      // Inactive Medications
                      if (provider.medications
                          .where((m) => !m.isActive)
                          .isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Inactive Medications',
                          style: TextStyle(
                            color: Color(0xFF88A8AF),
                            fontSize: 18,
                            fontFamily: 'Onest',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...provider.medications
                            .where((m) => !m.isActive)
                            .map((med) => _buildMedicationCard(med, provider)),
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

  Widget _buildMedicationCard(
      Medication medication, MedicationProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF00707D).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.medication,
                  color: Color(0xFF00707D),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication.name,
                      style: TextStyle(
                        color: medication.isActive
                            ? const Color(0xFF002E34)
                            : const Color(0xFF88A8AF),
                        fontSize: 18,
                        fontFamily: 'Onest',
                        fontWeight: FontWeight.w600,
                        decoration: medication.isActive
                            ? null
                            : TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      medication.dosage,
                      style: const TextStyle(
                        color: Color(0xFF88A8AF),
                        fontSize: 14,
                        fontFamily: 'Onest',
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: medication.isActive,
                onChanged: (value) {
                  provider.toggleMedicationStatus(medication.id!);
                },
                activeColor: const Color(0xFF00707D),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(
                _formatFrequency(medication.frequency),
                Icons.repeat,
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                _formatTimeOfDay(medication.timeOfDay),
                Icons.access_time,
              ),
            ],
          ),
          if (medication.notes != null && medication.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE5F3F6),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.note,
                    size: 16,
                    color: Color(0xFF00707D),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      medication.notes!,
                      style: const TextStyle(
                        color: Color(0xFF002E34),
                        fontSize: 13,
                        fontFamily: 'Onest',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: const Color(0xFFF2994A),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFFF8FDFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      title: const Text(
                        'Delete Medication',
                        style: TextStyle(
                          color: Color(0xFF002E34),
                          fontFamily: 'Onest',
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to delete ${medication.name}?',
                        style: const TextStyle(
                          color: Color(0xFF002E34),
                          fontFamily: 'Onest',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF88A8AF),
                              fontFamily: 'Onest',
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await provider.deleteMedication(medication.id!);
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Medication deleted'),
                                  backgroundColor: Color(0xFF00707D),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Onest',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F3F6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: const Color(0xFF00707D),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF002E34),
              fontSize: 12,
              fontFamily: 'Onest',
            ),
          ),
        ],
      ),
    );
  }

  String _formatFrequency(String frequency) {
    switch (frequency) {
      case 'daily':
        return 'Daily';
      case 'twice_daily':
        return 'Twice Daily';
      case 'three_times':
        return '3x Daily';
      case 'weekly':
        return 'Weekly';
      case 'as_needed':
        return 'As Needed';
      default:
        return frequency;
    }
  }

  String _formatTimeOfDay(String timeOfDay) {
    switch (timeOfDay) {
      case 'morning':
        return 'Morning';
      case 'afternoon':
        return 'Afternoon';
      case 'evening':
        return 'Evening';
      case 'night':
        return 'Night';
      case 'anytime':
        return 'Anytime';
      default:
        return timeOfDay;
    }
  }
}

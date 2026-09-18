import 'package:flutter/material.dart';
import 'package:physioghar/common_widgets/app_empty_state.dart';
import 'package:physioghar/common_widgets/app_loading.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/screens/patients/patient_controller.dart';
import 'package:physioghar/screens/patients/widgets/patient_condition_card.dart';
import 'package:physioghar/screens/patients/widgets/patient_header.dart';
import 'package:physioghar/screens/patients/widgets/patient_info_card.dart';
import 'package:physioghar/screens/patients/widgets/patient_notes.dart';
import 'package:physioghar/screens/patients/widgets/patient_treatment_history.dart';

class PatientDetailScreen extends StatefulWidget {
  const PatientDetailScreen({super.key, required this.patientId});

  final int patientId;

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  late final PatientController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PatientController();

    _controller.loadPatient(widget.patientId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Patient Details')),
      body: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: _controller.isLoading,
          builder: (context, isLoading, _) {
            if (isLoading) {
              return const AppLoading();
            }

            return ValueListenableBuilder(
              valueListenable: _controller.selectedPatient,
              builder: (context, patient, _) {
                if (patient == null) {
                  return const AppEmptyState(
                    icon: Icons.person_off_outlined,
                    title: 'Patient not found',
                    message: 'The patient record could not be found.',
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacingXl,
                    vertical: AppSizes.spacingSm,
                  ),
                  child: Column(
                    children: [
                      PatientHeader(patient: patient),

                      const SizedBox(height: AppSizes.spacingMd),

                      PatientInfoCard(patient: patient),

                      const SizedBox(height: AppSizes.spacingMd),

                      PatientConditionCard(patient: patient),

                      const SizedBox(height: AppSizes.spacingMd),

                      PatientTreatmentHistory(patientId: patient.id!),

                      const SizedBox(height: AppSizes.spacingMd),
                      PatientNotes(
                        patientId: patient.id!,
                        controller: _controller,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

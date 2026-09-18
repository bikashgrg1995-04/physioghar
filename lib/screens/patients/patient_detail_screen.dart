import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/common_widgets/app_empty_state.dart';
import 'package:physioghar/common_widgets/app_loading.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/data/providers/patient_provider.dart';
import 'package:physioghar/screens/patients/widgets/patient_condition_card.dart';
import 'package:physioghar/screens/patients/widgets/patient_header.dart';
import 'package:physioghar/screens/patients/widgets/patient_info_card.dart';
import 'package:physioghar/screens/patients/widgets/patient_notes.dart';
import 'package:physioghar/screens/patients/widgets/patient_treatment_history.dart';

class PatientDetailScreen extends ConsumerStatefulWidget {
  const PatientDetailScreen({super.key, required this.patientId});

  final int patientId;

  @override
  ConsumerState<PatientDetailScreen> createState() =>
      _PatientDetailScreenState();
}

class _PatientDetailScreenState extends ConsumerState<PatientDetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) {
        return;
      }

      ref.read(patientProvider.notifier).loadPatient(widget.patientId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientState = ref.watch(patientProvider);

    final isLoading = patientState.isLoading;

    final patient = patientState.selectedPatient;

    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.cream,
        appBar: AppBar(title: const Text('Patient Details')),
        body: const SafeArea(child: AppLoading()),
      );
    }

    if (patient == null) {
      return Scaffold(
        backgroundColor: AppColors.cream,
        appBar: AppBar(title: const Text('Patient Details')),
        body: const SafeArea(
          child: AppEmptyState(
            icon: Icons.person_off_outlined,
            title: 'Patient not found',
            message: 'The patient record could not be found.',
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Patient Details')),
      body: SafeArea(
        child: SingleChildScrollView(
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

              PatientNotes(patientId: patient.id!),
            ],
          ),
        ),
      ),
    );
  }
}

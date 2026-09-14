import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/app/router.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/providers/patient_provider.dart';
import 'package:physioghar/screens/patients/widgets/patient_card.dart';
import 'package:physioghar/screens/patients/widgets/patient_empty_state.dart';
import 'package:physioghar/screens/patients/widgets/patient_search_field.dart';

class PatientsScreen extends ConsumerStatefulWidget {
  const PatientsScreen({super.key});

  @override
  ConsumerState<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends ConsumerState<PatientsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(patientProvider);

    final filteredPatients = patients.where((patient) {
      final query = _searchQuery.toLowerCase().trim();

      return query.isEmpty ||
          patient.name.toLowerCase().contains(query) ||
          patient.condition.toLowerCase().contains(query);
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patients',
              key: const Key('patients-screen-title'),
              style: GoogleFonts.fraunces(
                fontSize: AppSizes.fontSizeDisplay,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: AppSizes.spacingXs),
            Text(
              'Your patient records',
              style: GoogleFonts.inter(
                fontSize: AppSizes.fontSizeMd,
                color: AppColors.inkMid,
              ),
            ),

            const SizedBox(height: AppSizes.spacingLg),

            PatientSearchField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),

            const SizedBox(height: AppSizes.spacingLg),

            Expanded(
              child: filteredPatients.isEmpty
                  ? const PatientEmptyState()
                  : ListView.separated(
                      itemCount: filteredPatients.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSizes.spacingMd),
                      itemBuilder: (context, index) {
                        final patient = filteredPatients[index];

                        return PatientCard(
                          patient: patient,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRouter.patientDetail,
                              arguments: patient.id,
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

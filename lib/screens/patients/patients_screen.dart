
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:physioghar/app/router.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';
import 'package:physioghar/data/providers/patient_provider.dart';
import 'package:physioghar/models/patient.dart';
import 'package:physioghar/screens/patients/widgets/patient_list_shimmer.dart';
import 'package:physioghar/screens/patients/widgets/patient_card.dart';
import 'package:physioghar/screens/patients/widgets/patient_empty_state.dart';
import 'package:physioghar/screens/patients/widgets/patient_search_field.dart';

class PatientsScreen extends ConsumerStatefulWidget {
  const PatientsScreen({
    super.key,
  });

  @override
  ConsumerState<PatientsScreen> createState() =>
      _PatientsScreenState();
}

class _PatientsScreenState
    extends ConsumerState<PatientsScreen> {
  final _searchController =
      TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) {
        return;
      }

      ref
          .read(patientProvider.notifier)
          .loadPatients();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final patientState =
        ref.watch(patientProvider);

    final patients = patientState.patients;

    final query =
        _searchQuery.toLowerCase().trim();

    final filteredPatients =
        patients.where((patient) {
      final name =
          patient.name?.toLowerCase() ?? '';

      final condition =
          patient.condition?.toLowerCase() ?? '';

      return query.isEmpty ||
          name.contains(query) ||
          condition.contains(query);
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSizes.spacingXl,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Patients',
              key: const Key(
                'patients-screen-title',
              ),
              style: context.textTheme.displayLarge,
            ),

            const SizedBox(
              height: AppSizes.spacingXs,
            ),

            Text(
              'Your patient records',
              style: context.textTheme.bodyMedium,
            ),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),

            PatientSearchField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),

            Expanded(
              child: Builder(
                builder: (context) {
                  if (patientState.isLoading &&
                      patients.isEmpty) {
                    return const PatientListShimmer();
                  }

                  if (filteredPatients.isEmpty) {
                    return const PatientEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () {
                      return ref
                          .read(
                            patientProvider.notifier,
                          )
                          .loadPatients();
                    },
                    child: ListView.separated(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      itemCount:
                          filteredPatients.length,
                      separatorBuilder:
                          (_, _) =>
                              const SizedBox(
                        height:
                            AppSizes.spacingMd,
                      ),
                      itemBuilder:
                          (context, index) {
                        final Patient patient =
                            filteredPatients[index];

                        return PatientCard(
                          patient: patient,
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed(
                              AppRouter.patientDetail,
                              arguments:
                                  patient.id,
                            );
                          },
                        );
                      },
                    ),
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
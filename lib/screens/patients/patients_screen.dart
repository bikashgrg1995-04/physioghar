import 'package:flutter/material.dart';

import 'package:physioghar/app/router.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';
import 'package:physioghar/models/patient.dart';
import 'package:physioghar/screens/patients/patient_controller.dart';
import 'package:physioghar/screens/patients/widgets/patient_list_shimmer.dart';
import 'package:physioghar/screens/patients/widgets/patient_card.dart';
import 'package:physioghar/screens/patients/widgets/patient_empty_state.dart';
import 'package:physioghar/screens/patients/widgets/patient_search_field.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({
    super.key,
  });

  @override
  State<PatientsScreen> createState() =>
      _PatientsScreenState();
}

class _PatientsScreenState
    extends State<PatientsScreen> {
  late final PatientController _controller;

  final _searchController =
      TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _controller = PatientController();
    _controller.loadPatients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Patient>>(
      valueListenable: _controller.patients,
      builder: (
        context,
        patients,
        _,
      ) {
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
                  child: ValueListenableBuilder<bool>(
                    valueListenable:
                        _controller.isLoading,
                    builder: (
                      context,
                      isLoading,
                      _,
                    ) {
                      if (isLoading &&
                          patients.isEmpty) {
                        return const PatientListShimmer();
                      }

                      if (filteredPatients.isEmpty) {
                        return const PatientEmptyState();
                      }

                      return RefreshIndicator(
                        onRefresh:
                            _controller.loadPatients,
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
                            final patient =
                                filteredPatients[index];

                            return PatientCard(
                              patient: patient,
                              onTap: () {
                                Navigator.of(
                                  context,
                                ).pushNamed(
                                  AppRouter
                                      .patientDetail,
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
      },
    );
  }
}
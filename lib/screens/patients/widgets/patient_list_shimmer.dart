import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';

class PatientListShimmer extends StatelessWidget {
  const PatientListShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics:
          const AlwaysScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (_, _) =>
          const SizedBox(
        height: AppSizes.spacingMd,
      ),
      itemBuilder: (_, _) {
        return const _PatientCardShimmer();
      },
    );
  }
}

class _PatientCardShimmer extends StatelessWidget {
  const _PatientCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.mist,
      highlightColor: AppColors.white,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(
          AppSizes.spacingLg,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(
            AppSizes.cardRadius,
          ),
          border: Border.all(
            color: AppColors.mist,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // Patient identity
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(
                  width: AppSizes.spacingMd,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 17,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              BorderRadius.circular(6),
                        ),
                      ),

                      const SizedBox(
                        height: AppSizes.spacingSm,
                      ),

                      Container(
                        width: 120,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: AppSizes.spacingMd,
            ),

            // Condition summary
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(
                AppSizes.spacingMd,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(
                  AppSizes.spacingSm,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 75,
                    height: 11,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius:
                          BorderRadius.circular(4),
                    ),
                  ),

                  const SizedBox(
                    height: AppSizes.spacingSm,
                  ),

                  Container(
                    width: 210,
                    height: 15,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius:
                          BorderRadius.circular(5),
                    ),
                  ),

                  const SizedBox(
                    height: AppSizes.spacingSm,
                  ),

                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration:
                            const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                      ),

                      const SizedBox(
                        width: AppSizes.spacingXs,
                      ),

                      Container(
                        width: 120,
                        height: 13,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: AppSizes.spacingMd,
            ),

            // View Patient button
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(
                  AppSizes.buttonRadius,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
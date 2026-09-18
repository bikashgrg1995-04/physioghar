
import 'package:flutter/material.dart';

import 'package:physioghar/app/router.dart';
import 'package:physioghar/common_widgets/app_loading.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/models/therapist.dart';
import 'package:physioghar/screens/profile/language_controller.dart';
import 'package:physioghar/screens/profile/therapist_controller.dart';
import 'package:physioghar/screens/profile/widgets/profile_actions.dart';
import 'package:physioghar/screens/profile/widgets/profile_header.dart';
import 'package:physioghar/screens/profile/widgets/therapist_details_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  late final TherapistController _controller;
  late final LanguageController _languageController;

  @override
  void initState() {
    super.initState();

    _controller = therapistController;
    _languageController = LanguageController();

    _controller.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Therapist?>(
      valueListenable: _controller.therapist,
      builder: (
        context,
        therapist,
        _,
      ) {
        if (therapist == null) {
          return const SafeArea(
            child: AppLoading(),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              bottom: AppSizes.spacingXl,
            ),
            child: Column(
              children: [
                ProfileHeader(
                  therapist: therapist,
                  isAvatarUpdating:
                      _controller.isAvatarUpdating,
                  onAvatarTap: () {
                    _controller.changeAvatar(
                      context,
                    );
                  },
                ),

                TherapistDetailsCard(
                  therapist: therapist,
                  onEdit: () {
                    _controller.openEditProfile(
                      context,
                    );
                  },
                ),

                const SizedBox(
                  height: AppSizes.spacingMd,
                ),

                ProfileActions(
                  onSettings: () {
                    _controller.openSettings(
                      context,
                      _languageController,
                    );
                  },
                  onReportIssue: () {
                    Navigator.of(context).pushNamed(
                      AppRouter.complaints,
                    );
                  },
                  onLogout: () {
                    _controller.logout(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _languageController.dispose();

    super.dispose();
  }
}
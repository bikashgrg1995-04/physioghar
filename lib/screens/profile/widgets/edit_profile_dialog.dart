
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/common_widgets/app_text_field.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/models/therapist.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({
    super.key,
    required this.therapist,
    required this.onSave,
  });

  final Therapist therapist;

  final Future<void> Function({
    required String phone,
    required String experience,
    required String specialization,
    required String address,
    required String bio,
  }) onSave;

  @override
  State<EditProfileDialog> createState() =>
      _EditProfileDialogState();
}

class _EditProfileDialogState
    extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _phoneController;
  late final TextEditingController _experienceController;
  late final TextEditingController _specializationController;
  late final TextEditingController _addressController;
  late final TextEditingController _bioController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _phoneController = TextEditingController(
      text: widget.therapist.phone ?? '',
    );

    _experienceController = TextEditingController(
      text: widget.therapist.experience ?? '',
    );

    _specializationController = TextEditingController(
      text: widget.therapist.specialization ?? '',
    );

    _addressController = TextEditingController(
      text: widget.therapist.address ?? '',
    );

    _bioController = TextEditingController(
      text: widget.therapist.bio ?? '',
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _experienceController.dispose();
    _specializationController.dispose();
    _addressController.dispose();
    _bioController.dispose();

    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_isSaving) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.onSave(
        phone: _phoneController.text.trim(),
        experience: _experienceController.text.trim(),
        specialization:
            _specializationController.text.trim(),
        address: _addressController.text.trim(),
        bio: _bioController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } catch (error) {
      debugPrint(
        'Edit profile save failed: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
      ),
      titlePadding: const EdgeInsets.fromLTRB(
        AppSizes.spacingLg,
        AppSizes.spacingLg,
        AppSizes.spacingLg,
        0,
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSizes.spacingLg,
        AppSizes.spacingMd,
        AppSizes.spacingLg,
        AppSizes.spacingSm,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppSizes.spacingLg,
        0,
        AppSizes.spacingLg,
        AppSizes.spacingLg,
      ),
      title: Text(
        'Edit Profile',
        style: GoogleFonts.fraunces(
          fontSize: AppSizes.fontSizeXl,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: _phoneController,
                label: 'Phone',
                hintText: 'Enter phone number',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(
                height: AppSizes.spacingMd,
              ),

              AppTextField(
                controller: _experienceController,
                label: 'Experience',
                hintText: 'e.g. 5 years',
                prefixIcon: Icons.work_outline,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(
                height: AppSizes.spacingMd,
              ),

              AppTextField(
                controller: _specializationController,
                label: 'Specialization',
                hintText: 'Enter specialization',
                prefixIcon:
                    Icons.medical_services_outlined,
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(
                height: AppSizes.spacingMd,
              ),

              AppTextField(
                controller: _addressController,
                label: 'Address',
                hintText: 'Enter address',
                prefixIcon:
                    Icons.location_on_outlined,
                textInputAction: TextInputAction.next,
                maxLines: 1,
              ),

              const SizedBox(
                height: AppSizes.spacingMd,
              ),

              AppTextField(
                controller: _bioController,
                label: 'Bio',
                hintText: 'Tell us about yourself',
                prefixIcon: Icons.notes_outlined,
                textInputAction: TextInputAction.done,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving
              ? null
              : () {
                  Navigator.of(context).pop();
                },
          style: TextButton.styleFrom(
            minimumSize: const Size(
              AppSizes.minTapTarget,
              AppSizes.minTapTarget,
            ),
          ),
          child: Text(
            'Cancel',
            style: GoogleFonts.inter(
              fontSize: AppSizes.fontSizeMd,
              fontWeight: FontWeight.w600,
              color: AppColors.inkMid,
            ),
          ),
        ),

        AppButton(
          width: 100,
          text: _isSaving ? 'Saving...' : 'Save',
          onPressed: _isSaving
              ? null
              : _saveProfile,
        ),
      ],
    );
  }
}

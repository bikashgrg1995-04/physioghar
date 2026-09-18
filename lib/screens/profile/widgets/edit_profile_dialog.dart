import 'package:flutter/material.dart';

import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/common_widgets/app_text_field.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';
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
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
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

    FocusScope.of(context).unfocus();

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
        specialization: _specializationController.text.trim(),
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
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingLg,
        vertical: AppSizes.spacingXl,
      ),
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
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
      title: _DialogHeader(
        isSaving: _isSaving,
        onClose: _isSaving
            ? null
            : () {
                Navigator.of(context).pop();
              },
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 420,
        ),
        child: SingleChildScrollView(
          keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keep your professional information up to date.',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.inkMid,
                    height: 1.45,
                  ),
                ),

                const SizedBox(
                  height: AppSizes.spacingLg,
                ),

                const _SectionLabel(
                  icon: Icons.badge_outlined,
                  title: 'Professional Information',
                ),

                const SizedBox(
                  height: AppSizes.spacingMd,
                ),

                AppTextField(
                  controller: _specializationController,
                  label: 'Specialization',
                  hintText: 'e.g. Physiotherapist',
                  prefixIcon: Icons.medical_services_outlined,
                  textInputAction: TextInputAction.next,
                  validator: _requiredValidator,
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
                  validator: _requiredValidator,
                ),

                const SizedBox(
                  height: AppSizes.spacingLg,
                ),

                const _SectionLabel(
                  icon: Icons.contact_phone_outlined,
                  title: 'Contact Information',
                ),

                const SizedBox(
                  height: AppSizes.spacingMd,
                ),

                AppTextField(
                  controller: _phoneController,
                  label: 'Phone',
                  hintText: 'Enter phone number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: _requiredValidator,
                ),

                const SizedBox(
                  height: AppSizes.spacingMd,
                ),

                AppTextField(
                  controller: _addressController,
                  label: 'Address',
                  hintText: 'Enter your address',
                  prefixIcon: Icons.location_on_outlined,
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  validator: _requiredValidator,
                ),

                const SizedBox(
                  height: AppSizes.spacingLg,
                ),

                const _SectionLabel(
                  icon: Icons.notes_outlined,
                  title: 'About You',
                ),

                const SizedBox(
                  height: AppSizes.spacingMd,
                ),

                AppTextField(
                  controller: _bioController,
                  label: 'Bio',
                  hintText: 'Tell patients a little about yourself',
                  prefixIcon: Icons.notes_outlined,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  validator: _requiredValidator,
                ),
              ],
            ),
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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacingMd,
            ),
          ),
          child: Text(
            'Cancel',
            style: context.textTheme.labelLarge?.copyWith(
              color: AppColors.inkMid,
            ),
          ),
        ),

        AppButton(
          width: 140,
          text: _isSaving ? 'Saving...' : 'Save Changes',
          icon: _isSaving
              ? const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : const Icon(
                  Icons.check_rounded,
                  size: 18,
                ),
          onPressed: _isSaving ? null : _saveProfile,
        ),
      ],
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
    required this.isSaving,
    required this.onClose,
  });

  final bool isSaving;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSizes.minTapTarget,
          height: AppSizes.minTapTarget,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.pinePale,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            size: 22,
            color: AppColors.pine,
          ),
        ),

        const SizedBox(
          width: AppSizes.spacingMd,
        ),

        Expanded(
          child: Text(
            'Edit Profile',
            style: context.textTheme.headlineLarge?.copyWith(
              fontSize: AppSizes.fontSizeXl,
            ),
          ),
        ),

        IconButton(
          onPressed: onClose,
          tooltip: 'Close',
          constraints: const BoxConstraints(
            minWidth: AppSizes.minTapTarget,
            minHeight: AppSizes.minTapTarget,
          ),
          icon: const Icon(
            Icons.close_rounded,
            size: 21,
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: AppColors.pine,
        ),
        const SizedBox(
          width: AppSizes.spacingSm,
        ),
        Text(
          title,
          style: context.textTheme.labelLarge?.copyWith(
            color: AppColors.pine,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
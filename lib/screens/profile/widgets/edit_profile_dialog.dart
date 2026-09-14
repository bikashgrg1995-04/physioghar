import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/models/therapist.dart';
import 'package:physioghar/providers/therapist_provider.dart';

class EditProfileDialog extends ConsumerStatefulWidget {
  const EditProfileDialog({super.key, required this.therapist});

  final Therapist therapist;

  @override
  ConsumerState<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends ConsumerState<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _experienceController;
  late final TextEditingController _specializationController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(text: widget.therapist.email);

    _phoneController = TextEditingController(text: widget.therapist.phone);

    _experienceController = TextEditingController(
      text: widget.therapist.experience,
    );

    _specializationController = TextEditingController(
      text: widget.therapist.specialization,
    );

    _addressController = TextEditingController(text: widget.therapist.address);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _experienceController.dispose();
    _specializationController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ref
        .read(therapistProvider.notifier)
        .updateProfile(
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          experience: _experienceController.text.trim(),
          specialization: _specializationController.text.trim(),
          address: _addressController.text.trim(),
        );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
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
              _ProfileTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validateEmail,
              ),
              const SizedBox(height: AppSizes.spacingMd),
              _ProfileTextField(
                controller: _phoneController,
                label: 'Phone',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSizes.spacingMd),
              _ProfileTextField(
                controller: _experienceController,
                label: 'Experience',
                icon: Icons.work_outline,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSizes.spacingMd),
              _ProfileTextField(
                controller: _specializationController,
                label: 'Specialization',
                icon: Icons.medical_services_outlined,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSizes.spacingMd),
              _ProfileTextField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.location_on_outlined,
                textInputAction: TextInputAction.done,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
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
        FilledButton(
          onPressed: _saveProfile,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.pine,
            foregroundColor: Colors.white,
            minimumSize: const Size(
              AppSizes.minTapTarget,
              AppSizes.minTapTarget,
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingLg),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            ),
          ),
          child: Text(
            'Save',
            style: GoogleFonts.inter(
              fontSize: AppSizes.fontSizeMd,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email';
    }

    return null;
  }
}

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator ?? _requiredValidator,
      maxLines: maxLines,
      style: GoogleFonts.inter(
        fontSize: AppSizes.fontSizeMd,
        color: AppColors.ink,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.inkMute, size: 20),
        labelStyle: GoogleFonts.inter(
          fontSize: AppSizes.fontSizeMd,
          color: AppColors.inkMid,
        ),
        floatingLabelStyle: GoogleFonts.inter(
          fontSize: AppSizes.fontSizeSm,
          fontWeight: FontWeight.w600,
          color: AppColors.pine,
        ),
        filled: true,
        fillColor: AppColors.mist.withValues(alpha: 0.45),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingMd,
          vertical: AppSizes.spacingMd,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.spacingSm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.spacingSm),
          borderSide: BorderSide(color: AppColors.mist),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.spacingSm),
          borderSide: BorderSide(color: AppColors.pine, width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.spacingSm),
          borderSide: BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.spacingSm),
          borderSide: BorderSide(color: AppColors.danger, width: 1.2),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }

    return null;
  }
}

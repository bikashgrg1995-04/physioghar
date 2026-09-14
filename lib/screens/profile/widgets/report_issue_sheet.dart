import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:physioghar/common_widgets/app_button.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';

class ReportIssueSheet extends StatefulWidget {
  const ReportIssueSheet({
    super.key,
  });

  @override
  State<ReportIssueSheet> createState() => _ReportIssueSheetState();
}

class _ReportIssueSheetState extends State<ReportIssueSheet> {
  final _formKey = GlobalKey<FormState>();

  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Patient Issue';

  static const categories = [
    'Patient Issue',
    'Booking Issue',
    'Payment Issue',
    'Technical Issue',
    'Other',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitComplaint() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(true);

   
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSizes.spacingLg,
          AppSizes.spacingSm,
          AppSizes.spacingLg,
          MediaQuery.viewInsetsOf(context).bottom +
              AppSizes.spacingLg,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.inkMute.withValues(
                        alpha: 0.35,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(
                  height: AppSizes.spacingLg,
                ),

                Text(
                  'Report an Issue',
                  style: GoogleFonts.fraunces(
                    fontSize: AppSizes.fontSizeXl,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),

                const SizedBox(
                  height: AppSizes.spacingXs,
                ),

                Text(
                  'Tell us about a problem you are facing.',
                  style: GoogleFonts.inter(
                    fontSize: AppSizes.fontSizeMd,
                    color: AppColors.inkMid,
                  ),
                ),

                const SizedBox(
                  height: AppSizes.spacingLg,
                ),

                _FieldLabel(
                  label: 'CATEGORY',
                ),

                const SizedBox(
                  height: AppSizes.spacingXs,
                ),

                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: _inputDecoration(),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),

                const SizedBox(
                  height: AppSizes.spacingMd,
                ),

                _FieldLabel(
                  label: 'SUBJECT',
                ),

                const SizedBox(
                  height: AppSizes.spacingXs,
                ),

                TextFormField(
                  controller: _subjectController,
                  textInputAction: TextInputAction.next,
                  decoration: _inputDecoration(
                    hintText: 'Enter the subject',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a subject';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: AppSizes.spacingMd,
                ),

                _FieldLabel(
                  label: 'DESCRIPTION',
                ),

                const SizedBox(
                  height: AppSizes.spacingXs,
                ),

                TextFormField(
                  controller: _descriptionController,
                  minLines: 4,
                  maxLines: 6,
                  textInputAction: TextInputAction.newline,
                  decoration: _inputDecoration(
                    hintText: 'Describe the issue',
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please describe the issue';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: AppSizes.spacingLg,
                ),

                AppButton(
                  width: double.infinity,
                  text: 'Submit Complaint',
                  icon: const Icon(
                    Icons.send_outlined,
                    size: 18,
                  ),
                  onPressed: _submitComplaint,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? hintText,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      alignLabelWithHint: alignLabelWithHint,
      filled: true,
      fillColor: AppColors.mist,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingMd,
        vertical: AppSizes.spacingMd,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        borderSide: const BorderSide(
          color: AppColors.pine,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        borderSide: const BorderSide(
          color: AppColors.danger,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        borderSide: const BorderSide(
          color: AppColors.danger,
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.ibmPlexMono(
        fontSize: AppSizes.fontSizeXs,
        fontWeight: FontWeight.w600,
        color: AppColors.inkMute,
        letterSpacing: 0.7,
      ),
    );
  }
}
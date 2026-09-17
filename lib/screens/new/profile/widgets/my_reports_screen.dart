import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/models/complaint.dart';
import 'package:physioghar/screens/new/profile/complaint_controller.dart';
import 'package:physioghar/screens/new/profile/widgets/report_issue_sheet.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  @override
  void initState() {
    super.initState();

    complaintController.loadComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          'My Reports',
          style: GoogleFonts.fraunces(
            fontSize: AppSizes.fontSizeXl,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: complaintController.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.pine,
              ),
            );
          }

          return ValueListenableBuilder<List<Complaint>>(
            valueListenable: complaintController.complaints,
            builder: (context, complaints, _) {
              if (complaints.isEmpty) {
                return const _EmptyState();
              }

              return RefreshIndicator(
                onRefresh: complaintController.loadComplaints,
                color: AppColors.pine,
                backgroundColor: AppColors.white,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.spacingLg,
                    AppSizes.spacingSm,
                    AppSizes.spacingLg,
                    100,
                  ),
                  itemCount: complaints.length,
                  separatorBuilder: (_, _) => const SizedBox(
                    height: AppSizes.spacingMd,
                  ),
                  itemBuilder: (context, index) {
                    final complaint = complaints[index];

                    return _ComplaintCard(
                      complaint: complaint,
                      onEdit: complaint.status == 'pending'
                          ? () => _editComplaint(complaint)
                          : null,
                      onDelete: complaint.status == 'pending'
                          ? () => _deleteComplaint(complaint)
                          : null,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.pine,
        foregroundColor: AppColors.white,
        elevation: 3,
        onPressed: _addComplaint,
        child: const Icon(
          Icons.add,
          size: 26,
        ),
      ),
    );
  }

  void _addComplaint() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.cardRadius),
        ),
      ),
      builder: (_) {
        return const ReportIssueSheet();
      },
    );
  }

  void _editComplaint(Complaint complaint) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.cardRadius),
        ),
      ),
      builder: (_) {
        return ReportIssueSheet(
          complaint: complaint,
        );
      },
    );
  }

  Future<void> _deleteComplaint(Complaint complaint) async {
    if (complaint.id == null) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppSizes.cardRadius,
            ),
          ),
          title: Text(
            'Delete Report?',
            style: GoogleFonts.inter(
              fontSize: AppSizes.fontSizeLg,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this report? '
            'This action cannot be undone.',
            style: GoogleFonts.inter(
              fontSize: AppSizes.fontSizeSm,
              color: AppColors.inkMid,
              height: 1.5,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            AppSizes.spacingMd,
            0,
            AppSizes.spacingMd,
            AppSizes.spacingMd,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontSize: AppSizes.fontSizeSm,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkMid,
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppSizes.buttonRadius,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(
                'Delete',
                style: GoogleFonts.inter(
                  fontSize: AppSizes.fontSizeSm,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    final success = await complaintController.deleteComplaint(
      complaint.id!,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      AppSnackBar.showSuccess(
        'Report deleted successfully.',
      );
    } else {
      AppSnackBar.showError(
        complaintController.errorMessage ??
            'Failed to delete report.',
      );
    }
  }
}

class _ComplaintCard extends StatelessWidget {
  const _ComplaintCard({
    required this.complaint,
    this.onEdit,
    this.onDelete,
  });

  final Complaint complaint;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isResolved = complaint.status == 'resolved';

    final canModify =
        !isResolved &&
        complaint.id != null &&
        (onEdit != null || onDelete != null);

    final categoryLabel = _categoryLabel(
      complaint.category,
    );

    final card = Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        border: Border.all(
          color: AppColors.inkMute.withValues(
            alpha: 0.14,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(
              alpha: 0.035,
            ),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          AppSizes.spacingLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _CategoryBadge(
                    label: categoryLabel,
                  ),
                ),
                const SizedBox(
                  width: AppSizes.spacingSm,
                ),
                _StatusBadge(
                  text: isResolved
                      ? 'Resolved'
                      : 'Pending',
                  isResolved: isResolved,
                ),
              ],
            ),

            const SizedBox(
              height: AppSizes.spacingMd,
            ),

            Text(
              complaint.subject?.trim().isNotEmpty == true
                  ? complaint.subject!
                  : 'No subject',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: AppSizes.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
                height: 1.3,
              ),
            ),

            const SizedBox(
              height: AppSizes.spacingSm,
            ),

            Text(
              complaint.description?.trim().isNotEmpty == true
                  ? complaint.description!
                  : 'No description provided.',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: AppSizes.fontSizeSm,
                color: AppColors.inkMid,
                height: 1.55,
              ),
            ),

            const SizedBox(
              height: AppSizes.spacingMd,
            ),

            Container(
              height: 1,
              color: AppColors.inkMute.withValues(
                alpha: 0.10,
              ),
            ),

            const SizedBox(
              height: AppSizes.spacingMd,
            ),

            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: AppColors.inkMute,
                ),
                const SizedBox(
                  width: AppSizes.spacingXs,
                ),
                Text(
                  complaint.createdAt != null
                      ? _formatDate(
                          complaint.createdAt!,
                        )
                      : 'Date unavailable',
                  style: GoogleFonts.ibmPlexMono(
                    fontSize: AppSizes.fontSizeXs,
                    color: AppColors.inkMute,
                  ),
                ),
                const Spacer(),
                if (canModify) ...[
                  Icon(
                    Icons.swipe_outlined,
                    size: 15,
                    color: AppColors.inkMute,
                  ),
                  const SizedBox(
                    width: AppSizes.spacingXs,
                  ),
                  Text(
                    'Swipe',
                    style: GoogleFonts.inter(
                      fontSize: AppSizes.fontSizeXs,
                      fontWeight: FontWeight.w500,
                      color: AppColors.inkMute,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );

    if (!canModify) {
      return card;
    }

    return Dismissible(
      key: ValueKey(complaint.id),
      direction: DismissDirection.horizontal,

      background: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingLg,
        ),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: AppColors.pine,
          borderRadius: BorderRadius.circular(
            AppSizes.cardRadius,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.edit_outlined,
              color: AppColors.white,
              size: 22,
            ),
            const SizedBox(
              height: AppSizes.spacingXs,
            ),
            Text(
              'Edit',
              style: GoogleFonts.inter(
                fontSize: AppSizes.fontSizeXs,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),

      secondaryBackground: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingLg,
        ),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(
            AppSizes.cardRadius,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Icon(
              Icons.delete_outline,
              color: AppColors.white,
              size: 22,
            ),
            const SizedBox(
              height: AppSizes.spacingXs,
            ),
            Text(
              'Delete',
              style: GoogleFonts.inter(
                fontSize: AppSizes.fontSizeXs,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),

      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEdit?.call();
        } else {
          onDelete?.call();
        }

        return false;
      },

      child: card,
    );
  }

  String _categoryLabel(String? category) {
    switch (category) {
      case 'patient':
        return 'Patient Issue';
      case 'booking':
        return 'Booking Issue';
      case 'payment':
        return 'Payment Issue';
      case 'technical':
        return 'Technical Issue';
      case 'other':
        return 'Other';
      default:
        return 'Other';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacingSm,
          vertical: AppSizes.spacingXs,
        ),
        decoration: BoxDecoration(
          color: AppColors.pinePale.withValues(
            alpha: 0.65,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: AppSizes.fontSizeXs,
            fontWeight: FontWeight.w600,
            color: AppColors.pine,
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.text,
    required this.isResolved,
  });

  final String text;
  final bool isResolved;

  @override
  Widget build(BuildContext context) {
    final color = isResolved
        ? AppColors.pine
        : AppColors.amber;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacingSm,
        vertical: AppSizes.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(
            width: AppSizes.spacingXs,
          ),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: AppSizes.fontSizeXs,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSizes.spacingLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.pinePale,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.report_outlined,
                size: 32,
                color: AppColors.pine,
              ),
            ),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),

            Text(
              'No reports yet',
              style: GoogleFonts.inter(
                fontSize: AppSizes.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),

            const SizedBox(
              height: AppSizes.spacingXs,
            ),

            Text(
              'Your submitted complaints will appear here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: AppSizes.fontSizeSm,
                color: AppColors.inkMid,
                height: 1.5,
              ),
            ),

            const SizedBox(
              height: AppSizes.spacingLg,
            ),

            Text(
              'Tap + to submit a new report.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: AppSizes.fontSizeXs,
                fontWeight: FontWeight.w500,
                color: AppColors.inkMute,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
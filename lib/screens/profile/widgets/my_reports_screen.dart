
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:physioghar/common_widgets/app_snackbar.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/core/extensions/context_extensions.dart';
import 'package:physioghar/core/utils/date_time_utils.dart';
import 'package:physioghar/data/providers/complaint_provider.dart';
import 'package:physioghar/models/complaint.dart';
import 'package:physioghar/screens/profile/widgets/report_issue_sheet.dart';

class MyReportsScreen extends ConsumerStatefulWidget {
  const MyReportsScreen({super.key});

  @override
  ConsumerState<MyReportsScreen> createState() =>
      _MyReportsScreenState();
}

class _MyReportsScreenState
    extends ConsumerState<MyReportsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(complaintProvider.notifier).loadComplaints();
    });
  }

  @override
  Widget build(BuildContext context) {
    final complaintState = ref.watch(complaintProvider);

    final complaints = complaintState.complaints;
    final isLoading = complaintState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          'My Reports',
          style: context.textTheme.headlineLarge?.copyWith(
            fontSize: AppSizes.fontSizeXl,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.pine,
              ),
            )
          : complaints.isEmpty
              ? const _EmptyState()
              : RefreshIndicator(
                  onRefresh: () {
                    return ref
                        .read(complaintProvider.notifier)
                        .loadComplaints();
                  },
                  color: AppColors.pine,
                  backgroundColor: AppColors.white,
                  child: ListView.separated(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.spacingLg,
                      AppSizes.spacingSm,
                      AppSizes.spacingLg,
                      100,
                    ),
                    itemCount: complaints.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(
                      height: AppSizes.spacingMd,
                    ),
                    itemBuilder: (context, index) {
                      final complaint = complaints[index];

                      return _ComplaintCard(
                        complaint: complaint,
                        onEdit:
                            complaint.status == 'pending'
                                ? () =>
                                    _editComplaint(complaint)
                                : null,
                        onDelete:
                            complaint.status == 'pending'
                                ? () =>
                                    _deleteComplaint(complaint)
                                : null,
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.pine,
        foregroundColor: AppColors.white,
        elevation: 3,
        onPressed: _addComplaint,
        child: const Icon(
          Icons.add_rounded,
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

  Future<void> _deleteComplaint(
    Complaint complaint,
  ) async {
    if (complaint.id == null) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppSizes.cardRadius,
            ),
          ),
          title: Text(
            'Delete Report?',
            style: context.textTheme.headlineLarge?.copyWith(
              fontSize: AppSizes.fontSizeLg,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this report? '
            'This action cannot be undone.',
            style: context.textTheme.bodyMedium?.copyWith(
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
                style: context.textTheme.labelLarge?.copyWith(
                  color: AppColors.inkMid,
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: AppColors.white,
                elevation: 0,
                minimumSize: const Size(
                  AppSizes.minTapTarget,
                  AppSizes.minTapTarget,
                ),
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
                style: context.textTheme.labelLarge?.copyWith(
                  color: AppColors.white,
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

    final success = await ref
        .read(complaintProvider.notifier)
        .deleteComplaint(complaint.id!);

    if (!mounted) {
      return;
    }

    if (success) {
      AppSnackBar.showSuccess(
        'Report deleted successfully.',
      );
    } else {
      final errorMessage =
          ref.read(complaintProvider).errorMessage;

      AppSnackBar.showError(
        errorMessage ?? 'Failed to delete report.',
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
          crossAxisAlignment:
              CrossAxisAlignment.start,
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
                  ? complaint.subject!.trim()
                  : 'No subject',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
                height: 1.3,
              ),
            ),
            const SizedBox(
              height: AppSizes.spacingSm,
            ),
            Text(
              complaint.description?.trim().isNotEmpty ==
                      true
                  ? complaint.description!.trim()
                  : 'No description provided.',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style:
                  context.textTheme.bodyMedium?.copyWith(
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
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: AppColors.inkMute,
                ),
                const SizedBox(
                  width: AppSizes.spacingXs,
                ),
                Text(
                  complaint.createdAt != null
                      ? DateTimeUtils.formatDate(
                          complaint.createdAt!,
                        )
                      : 'Date unavailable',
                  style:
                      context.textTheme.labelSmall?.copyWith(
                    color: AppColors.inkMute,
                  ),
                ),
                const Spacer(),
                if (canModify) ...[
                  const Icon(
                    Icons.swipe_left_outlined,
                    size: 15,
                    color: AppColors.inkMute,
                  ),
                  const SizedBox(
                    width: AppSizes.spacingXs,
                  ),
                  Text(
                    'Swipe for actions',
                    style:
                        context.textTheme.labelSmall?.copyWith(
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

    return Slidable(
      key: ValueKey(complaint.id),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.42,
        children: [
          if (onEdit != null)
            SlidableAction(
              onPressed: (_) {
                onEdit?.call();
              },
              backgroundColor: AppColors.pine,
              foregroundColor: AppColors.white,
              icon: Icons.edit_outlined,
              label: 'Edit',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(
                  AppSizes.cardRadius,
                ),
                bottomLeft: Radius.circular(
                  AppSizes.cardRadius,
                ),
              ),
            ),
          if (onDelete != null)
            SlidableAction(
              onPressed: (_) {
                onDelete?.call();
              },
              backgroundColor: AppColors.danger,
              foregroundColor: AppColors.white,
              icon: Icons.delete_outline_rounded,
              label: 'Delete',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(
                  AppSizes.cardRadius,
                ),
                bottomRight: Radius.circular(
                  AppSizes.cardRadius,
                ),
              ),
            ),
        ],
      ),
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
          style:
              context.textTheme.labelSmall?.copyWith(
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
            style:
                context.textTheme.labelSmall?.copyWith(
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
              style:
                  context.textTheme.headlineLarge?.copyWith(
                fontSize: AppSizes.fontSizeLg,
              ),
            ),
            const SizedBox(
              height: AppSizes.spacingXs,
            ),
            Text(
              'Your submitted complaints will appear here.',
              textAlign: TextAlign.center,
              style:
                  context.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
            const SizedBox(
              height: AppSizes.spacingLg,
            ),
            Text(
              'Tap + to submit a new report.',
              textAlign: TextAlign.center,
              style:
                  context.textTheme.labelSmall?.copyWith(
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
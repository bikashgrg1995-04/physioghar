import 'package:flutter/material.dart';
import 'package:physioghar/core/constants/app_colors.dart';
import 'package:physioghar/core/constants/app_sizes.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/screens/new/sessions/session_controller.dart';

class PatientTreatmentHistory extends StatefulWidget {
  const PatientTreatmentHistory({super.key, required this.patientId});

  final int patientId;

  @override
  State<PatientTreatmentHistory> createState() =>
      _PatientTreatmentHistoryState();
}

class _PatientTreatmentHistoryState extends State<PatientTreatmentHistory> {
  late final SessionController _controller;

  @override
  void initState() {
    super.initState();

    _controller = SessionController();

    _controller.loadSessions(
      status: SessionStatus.completed,
      patientId: widget.patientId,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _controller.isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.spacingLg),
              child: CircularProgressIndicator(),
            ),
          );
        }

        return ValueListenableBuilder<List<Session>>(
          valueListenable: _controller.sessions,
          builder: (context, sessions, _) {
            if (sessions.isEmpty) {
              return _buildEmptyState();
            }

            final completedSessions = sessions
                .where((session) => session.status == SessionStatus.completed)
                .toList();

            completedSessions.sort((a, b) {
              final aDate = a.scheduleDate;
              final bDate = b.scheduleDate;

              if (aDate == null) return 1;
              if (bDate == null) return -1;

              return bDate.compareTo(aDate);
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Treatment History',
                      style: TextStyle(
                        fontSize: AppSizes.fontSizeLg,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${completedSessions.length} sessions',
                      style: const TextStyle(
                        fontSize: AppSizes.fontSizeSm,
                        color: AppColors.inkMute,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.spacingSm),

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < completedSessions.length; i++) ...[
                        _TreatmentHistoryListItem(
                          session: completedSessions[i],
                          onTap: () {
                            _showSessionDetails(context, completedSessions[i]);
                          },
                        ),

                        if (i != completedSessions.length - 1)
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.spacingXl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: const Column(
        children: [
          Icon(Icons.history_rounded, size: 32, color: AppColors.inkMute),
          SizedBox(height: AppSizes.spacingSm),
          Text(
            'No treatment history yet',
            style: TextStyle(
              fontSize: AppSizes.fontSizeMd,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }

  void _showSessionDetails(BuildContext context, Session session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _SessionDetailsBottomSheet(session: session);
      },
    );
  }
}

class _SessionDetailsBottomSheet extends StatelessWidget {
  const _SessionDetailsBottomSheet({required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        decoration: const BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.spacingXl,
            AppSizes.spacingSm,
            AppSizes.spacingXl,
            AppSizes.spacingXl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.inkMute,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.spacingXl),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Treatment Details',
                      style: const TextStyle(
                        fontSize: AppSizes.fontSizeXl,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spacingMd),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.spacingLg),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.treatment?.trim().isNotEmpty == true
                          ? session.treatment!
                          : 'Treatment Session',
                      style: const TextStyle(
                        fontSize: AppSizes.fontSizeLg,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),

                    const SizedBox(height: AppSizes.spacingSm),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.pinePale,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 14,
                                color: AppColors.pine,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'COMPLETED',
                                style: TextStyle(
                                  fontSize: AppSizes.fontSizeXs,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.pine,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.spacingMd),

              _DetailRow(
                icon: Icons.calendar_today_outlined,
                label: 'Date',
                value: _formatDate(session.scheduleDate),
              ),

              _DetailRow(
                icon: Icons.access_time_outlined,
                label: 'Time',
                value: session.scheduleTime ?? 'Not available',
              ),

              _DetailRow(
                icon: Icons.location_on_outlined,
                label: 'Location',
                value: session.location?.trim().isNotEmpty == true
                    ? session.location!
                    : 'Not available',
              ),

              if (session.notes?.trim().isNotEmpty == true) ...[
                const SizedBox(height: AppSizes.spacingLg),

                const Text(
                  'Session Notes',
                  style: TextStyle(
                    fontSize: AppSizes.fontSizeMd,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),

                const SizedBox(height: AppSizes.spacingSm),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSizes.spacingLg),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                  ),
                  child: Text(
                    session.notes!,
                    style: const TextStyle(
                      fontSize: AppSizes.fontSizeMd,
                      height: 1.5,
                      color: AppColors.inkMid,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Not available';
    }

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spacingMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.pine),

          const SizedBox(width: AppSizes.spacingMd),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: AppSizes.fontSizeXs,
                    color: AppColors.inkMute,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: AppSizes.fontSizeMd,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TreatmentHistoryListItem extends StatelessWidget {
  const _TreatmentHistoryListItem({required this.session, required this.onTap});

  final Session session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingLg),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.pinePale,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.medical_services_outlined,
                color: AppColors.pine,
                size: 22,
              ),
            ),

            const SizedBox(width: AppSizes.spacingMd),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.treatment?.trim().isNotEmpty == true
                        ? session.treatment!
                        : 'Treatment Session',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: AppSizes.fontSizeMd,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),

                  const SizedBox(height: AppSizes.spacingXs),

                  Text(
                    _formatDate(session.scheduleDate),
                    style: const TextStyle(
                      fontSize: AppSizes.fontSizeSm,
                      color: AppColors.inkMid,
                    ),
                  ),

                  if (session.scheduleTime != null) ...[
                    const SizedBox(height: AppSizes.spacingTiny),
                    Text(
                      session.scheduleTime!,
                      style: const TextStyle(
                        fontSize: AppSizes.fontSizeXs,
                        color: AppColors.inkMute,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: AppSizes.spacingSm),

            const Icon(Icons.chevron_right_rounded, color: AppColors.inkMute),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Date unavailable';
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

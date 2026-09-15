// import 'package:flutter/material.dart';
// import 'package:physioghar/app/router.dart';
// import 'package:physioghar/core/constants/app_sizes.dart';
// import 'package:physioghar/models/session.dart';
// import 'package:physioghar/screens/dashboard/widgets/schedule_item_card.dart';

// class TodayScheduleSection extends StatefulWidget {
//   const TodayScheduleSection({
//     super.key,
//     required this.sessions,
//     required this.listHeight,
//   });

//   final List<Session> sessions;
//   final double listHeight;

//   @override
//   State<TodayScheduleSection> createState() => _TodayScheduleSectionState();
// }

// class _TodayScheduleSectionState extends State<TodayScheduleSection> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Today's Schedule", style: Theme.of(context).textTheme.titleLarge),
//         const SizedBox(height: AppSizes.spacingMd),
//         SizedBox(
//           height: widget.listHeight,
//           child: Scrollbar(
//             controller: _scrollController,
//             thumbVisibility: true,
//             child: ListView.separated(
//               controller: _scrollController,
//               physics: const AlwaysScrollableScrollPhysics(),
//               itemCount: widget.sessions.length,
//               separatorBuilder: (_, _) =>
//                   const SizedBox(height: AppSizes.spacingSm),
//               itemBuilder: (context, index) {
//                 final session = widget.sessions[index];

//                 return ScheduleItemCard(
//                   cardKey: Key('today-session-card-${session.id}'),
//                   session: session,
//                   onTap: () {
//                     Navigator.of(context)
//                         .pushNamed(AppRouter.sessionDetail, arguments: session.id);
//                   },
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

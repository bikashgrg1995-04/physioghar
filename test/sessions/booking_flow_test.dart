
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:physioghar/models/schedule_slot.dart';
// import 'package:physioghar/models/session.dart';
// import 'package:physioghar/providers/schedule_provider.dart';
// import 'package:physioghar/providers/session_provider.dart';

// void main() {
//   test(
//     'accepting a booking updates session and schedule state',
//     () {
//       final container = ProviderContainer();

//       addTearDown(container.dispose);

//       // Initial session state.
//       final initialSessions = container.read(sessionProvider);

//       final request = initialSessions.firstWhere(
//         (session) => session.id == 'request_session_001',
//       );

//       expect(
//         request.status,
//         SessionStatus.requested,
//       );

//       // The request should not already have a booked schedule slot.
//       final initialSchedule = container.read(scheduleProvider);

//       expect(
//         initialSchedule.any(
//           (slot) => slot.sessionId == request.id,
//         ),
//         isFalse,
//       );

//       // Accept the booking.
//       container
//           .read(sessionProvider.notifier)
//           .acceptSession(request.id);

//       // Session should now be upcoming.
//       final updatedSessions = container.read(sessionProvider);

//       final updatedSession = updatedSessions.firstWhere(
//         (session) => session.id == request.id,
//       );

//       expect(
//         updatedSession.status,
//         SessionStatus.upcoming,
//       );

//       // Schedule should now contain a booked slot
//       // for the accepted session.
//       final updatedSchedule = container.read(scheduleProvider);

//       final bookedSlot = updatedSchedule.firstWhere(
//         (slot) => slot.sessionId == request.id,
//       );

//       expect(
//         bookedSlot.status,
//         ScheduleSlotStatus.booked,
//       );

//       expect(
//         bookedSlot.dateTime,
//         updatedSession.dateTime,
//       );
//     },
//   );
// }
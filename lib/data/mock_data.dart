import 'package:physioghar/models/schedule_slot.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/models/therapist.dart';

class MockData {
  MockData._();
  static final Therapist initialTherapist = Therapist(
    id: 'therapist_001',
    name: 'Dr. Anisha Sharma',
    email: 'anisha@physioghar.com',
    phone: '+977 9800000000',
    specialization: 'Physiotherapist',
    experience: '5 years',
    address: 'Bharatpur, Chitwan',
    avatarUrl: '',
    isAvailable: true,
  );

  static final List<Session> sessions = [
    Session(
      id: 'session_001',
      patientName: 'Sita Sharma',
      treatment: 'Back Pain',
      location: 'Home Visit',
      dateTime: DateTime(2026, 9, 12, 10, 0),
      status: SessionStatus.upcoming,
      patientAge: '32',
    ),

    Session(
      id: 'session_002',
      patientName: 'Ram Thapa',
      treatment: 'Knee Rehabilitation',
      location: 'Clinic',
      dateTime: DateTime(2026, 9, 12, 14, 0),
      status: SessionStatus.upcoming,
      patientAge: '45',
    ),
  ];

  static const List<Map<String, dynamic>> scheduleSlots = [
    {'time': 9, 'status': ScheduleSlotStatus.open},
    {
      'time': 10,
      'status': ScheduleSlotStatus.booked,
      'sessionId': 'session_001',
    },
    {'time': 11, 'status': ScheduleSlotStatus.open},
    {'time': 12, 'status': ScheduleSlotStatus.blocked},
    {'time': 13, 'status': ScheduleSlotStatus.blocked},
  ];
}

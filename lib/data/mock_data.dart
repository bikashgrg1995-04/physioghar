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

  static final List<Session> dashboardSessions = [
    Session(
      id: 'dashboard_session_001',
      patientName: 'Sita Sharma',
      treatment: 'Back Pain',
      location: 'Home Visit',
      dateTime: DateTime(2000, 1, 1, 10, 0),
      status: SessionStatus.upcoming,
      patientAge: '32',
    ),

    Session(
      id: 'dashboard_session_002',
      patientName: 'Ram Thapa',
      treatment: 'Knee Rehabilitation',
      location: 'Clinic',
      dateTime: DateTime(2000, 1, 1, 14, 0),
      status: SessionStatus.upcoming,
      patientAge: '45',
    ),
  ];

  static const List<Map<String, dynamic>> scheduleSlots = [
    {'time': 9, 'status': ScheduleSlotStatus.open},
    {
      'time': 10,
      'status': ScheduleSlotStatus.booked,
      'sessionId': 'schedule_session_001',
    },
    {'time': 11, 'status': ScheduleSlotStatus.open},
    {'time': 12, 'status': ScheduleSlotStatus.blocked},
    {'time': 13, 'status': ScheduleSlotStatus.blocked},
  ];

  // Schedule sessions for testing purposes
  // when booked schedule is clicked, it will show
  //the session details of the booked session
  static final List<Session> scheduleSessions = [
    Session(
      id: 'schedule_session_001',
      patientName: 'Hari Adhikari',
      treatment: 'Shoulder Rehabilitation',
      location: 'Clinic',
      dateTime: DateTime(2000, 1, 1, 10, 0),
      status: SessionStatus.upcoming,
      patientAge: '38',
    ),
  ];

  // Mock booking requests for the Sessions > Requests tab.

  static final List<Session> bookingRequests = [
    Session(
      id: 'request_session_001',
      patientName: 'Maya Gurung',
      treatment: 'Neck Pain',
      location: 'Home Visit',
      dateTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        16,
        0,
      ),
      status: SessionStatus.requested,
      patientAge: '29',
    ),
  ];
}

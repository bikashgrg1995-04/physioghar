import 'package:physioghar/models/schedule_slot.dart';
import 'package:physioghar/models/session.dart';
import 'package:physioghar/models/patient.dart';

class MockData {
  MockData._();
 

  static final List<Session> dashboardSessions = [
    Session(
      id: 'dashboard_session_001',
      patientName: 'Sita Sharma',
      treatment: 'Back Pain',
      location: 'Home Visit',
      dateTime: DateTime(2000, 1, 1, 10, 0),
      status: SessionStatus.upcoming,
      patientAge: '32',
      source: SessionSource.dashboard,
    ),

    Session(
      id: 'dashboard_session_002',
      patientName: 'Ram Thapa',
      treatment: 'Knee Rehabilitation',
      location: 'Clinic',
      dateTime: DateTime(2000, 1, 1, 14, 0),
      status: SessionStatus.upcoming,
      patientAge: '45',
      source: SessionSource.dashboard,
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
      source: SessionSource.schedule,
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
      source: SessionSource.bookingRequest
    ),
  ];

  static final List<Patient> patients = [
    Patient(
      id: 'patient_001',
      name: 'Sita Sharma',
      age: 42,
      gender: 'Female',
      contact: '+977 9812345678',
      condition: 'Lower Back Pain',
      treatmentHistory: [
        'Lower back mobility exercises',
        'Core strengthening',
        'Hamstring stretching',
      ],
      previousSessions: [
        '10 Sept 2026 • 10:00 AM',
        '03 Sept 2026 • 10:00 AM',
        '27 Aug 2026 • 10:00 AM',
      ],
      notes: [
        PatientNote(
          id: 'note_001',
          content:
              'Patient reported reduced pain compared to previous session.\n\n'
              'Exercise:\n'
              '- Core strengthening\n'
              '- Hamstring stretching\n'
              '- Lower back mobility\n\n'
              'Next Session:\n'
              'Continue strengthening exercises.',
          createdAt: DateTime(2026, 9, 10, 10, 30),
        ),
        PatientNote(
          id: 'note_002',
          content:
              'Patient completed assigned exercises. '
              'Mild discomfort reported during prolonged sitting.',
          createdAt: DateTime(2026, 9, 3, 10, 30),
        ),
      ],
    ),

    Patient(
      id: 'patient_002',
      name: 'Ram Thapa',
      age: 45,
      gender: 'Male',
      contact: '+977 9801234567',
      condition: 'Knee Rehabilitation',
      treatmentHistory: [
        'Knee mobility exercises',
        'Quadriceps strengthening',
        'Balance training',
      ],
      previousSessions: [
        '08 Sept 2026 • 02:00 PM',
        '01 Sept 2026 • 02:00 PM',
        '25 Aug 2026 • 02:00 PM',
      ],
      notes: [
        PatientNote(
          id: 'note_003',
          content:
              'Patient showed improved knee mobility compared to the previous session.\n\n'
              'Exercise:\n'
              '- Knee flexion\n'
              '- Quadriceps strengthening\n'
              '- Balance exercises\n\n'
              'Next Session:\n'
              'Progress strengthening exercises gradually.',
          createdAt: DateTime(2026, 9, 8, 14, 30),
        ),
      ],
    ),

    Patient(
      id: 'patient_003',
      name: 'Maya Gurung',
      age: 29,
      gender: 'Female',
      contact: '+977 9823456789',
      condition: 'Neck Pain',
      treatmentHistory: [
        'Neck mobility exercises',
        'Posture correction',
        'Upper back stretching',
      ],
      previousSessions: ['05 Sept 2026 • 04:00 PM', '29 Aug 2026 • 04:00 PM'],
      notes: [
        PatientNote(
          id: 'note_004',
          content:
              'Patient reported improvement in neck stiffness. '
              'Posture correction exercises were reviewed.',
          createdAt: DateTime(2026, 9, 5, 16, 30),
        ),
      ],
    ),

    Patient(
      id: 'patient_004',
      name: 'Hari Adhikari',
      age: 38,
      gender: 'Male',
      contact: '+977 9865432109',
      condition: 'Shoulder Rehabilitation',
      treatmentHistory: [
        'Shoulder mobility exercises',
        'Rotator cuff strengthening',
        'Resistance band exercises',
      ],
      previousSessions: ['06 Sept 2026 • 11:00 AM', '30 Aug 2026 • 11:00 AM'],
      notes: [
        PatientNote(
          id: 'note_005',
          content:
              'Shoulder range of motion has improved. '
              'Patient tolerated resistance exercises well.',
          createdAt: DateTime(2026, 9, 6, 11, 30),
        ),
      ],
    ),

    Patient(
      id: 'patient_005',
      name: 'Anita Karki',
      age: 51,
      gender: 'Female',
      contact: '+977 9841122334',
      condition: 'Post-operative Rehabilitation',
      treatmentHistory: [
        'Gentle mobility exercises',
        'Strengthening exercises',
        'Functional movement training',
      ],
      previousSessions: ['04 Sept 2026 • 09:00 AM', '28 Aug 2026 • 09:00 AM'],
      notes: [
        PatientNote(
          id: 'note_006',
          content:
              'Patient is progressing steadily with functional movements. '
              'No significant discomfort reported during today’s exercises.',
          createdAt: DateTime(2026, 9, 4, 9, 30),
        ),
      ],
    ),
  ];
}

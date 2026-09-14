enum SessionStatus {
  requested,
  upcoming,
  completed,
  cancelled,
}

enum SessionSource {
  dashboard,
  schedule,
  bookingRequest,
}

class Session {
  final String id;
  final String patientName;
  final String treatment;
  final String location;
  final DateTime dateTime;
  final SessionStatus status;
  final String? patientAge;
  final String? notes;
  final SessionSource source;

  const Session({
    required this.id,
    required this.patientName,
    required this.treatment,
    required this.location,
    required this.dateTime,
    required this.status,
    required this.source,
    this.patientAge,
    this.notes,
  });

  Session copyWith({
    String? id,
    String? patientName,
    String? treatment,
    String? location,
    DateTime? dateTime,
    SessionStatus? status,
    String? patientAge,
    String? notes,
    SessionSource? source,
  }) {
    return Session(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      treatment: treatment ?? this.treatment,
      location: location ?? this.location,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      patientAge: patientAge ?? this.patientAge,
      notes: notes ?? this.notes,
      source: source ?? this.source,
    );
  }
}
import 'dart:convert';

Session sessionFromJson(String str) =>
    Session.fromJson(json.decode(str) as Map<String, dynamic>);

String sessionToJson(Session data) => json.encode(data.toJson());

enum SessionStatus {
  requested,
  upcoming,
  completed,
  cancelled;

  String get value {
    switch (this) {
      case SessionStatus.requested:
        return 'requested';

      case SessionStatus.upcoming:
        return 'upcoming';

      case SessionStatus.completed:
        return 'completed';

      case SessionStatus.cancelled:
        return 'cancelled';
    }
  }

  String get label {
    switch (this) {
      case SessionStatus.requested:
        return 'REQUESTED';

      case SessionStatus.upcoming:
        return 'UPCOMING';

      case SessionStatus.completed:
        return 'COMPLETED';

      case SessionStatus.cancelled:
        return 'CANCELLED';
    }
  }

  static SessionStatus fromJson(String value) {
    switch (value.toLowerCase()) {
      case 'requested':
        return SessionStatus.requested;

      case 'upcoming':
        return SessionStatus.upcoming;

      case 'completed':
        return SessionStatus.completed;

      case 'cancelled':
        return SessionStatus.cancelled;

      default:
        throw FormatException('Unknown session status: $value');
    }
  }
}

class Session {
  final int? id;
  final int? patientId;
  final String? patientName;

  final int? scheduleSlotId;
  final DateTime? scheduleDate;
  final String? scheduleTime;

  final String? treatment;
  final String? location;

  final SessionStatus? status;

  final String? notes;
  final String? cancellationReason;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  Session({
    this.id,
    this.patientId,
    this.patientName,
    this.scheduleSlotId,
    this.scheduleDate,
    this.scheduleTime,
    this.treatment,
    this.location,
    this.status,
    this.notes,
    this.cancellationReason,
    this.createdAt,
    this.updatedAt,
  });

  Session copyWith({
    int? id,
    int? patientId,
    String? patientName,
    int? scheduleSlotId,
    DateTime? scheduleDate,
    String? scheduleTime,
    String? treatment,
    String? location,
    SessionStatus? status,
    String? notes,
    String? cancellationReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Session(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    patientName: patientName ?? this.patientName,
    scheduleSlotId: scheduleSlotId ?? this.scheduleSlotId,
    scheduleDate: scheduleDate ?? this.scheduleDate,
    scheduleTime: scheduleTime ?? this.scheduleTime,
    treatment: treatment ?? this.treatment,
    location: location ?? this.location,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    cancellationReason: cancellationReason ?? this.cancellationReason,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    id: json['id'] as int?,
    patientId: json['patient'] as int?,
    patientName: json['patient_name'] as String?,
    scheduleSlotId: json['schedule_slot'] as int?,
    scheduleDate: json['schedule_date'] == null
        ? null
        : DateTime.parse(json['schedule_date'] as String),
    scheduleTime: json['schedule_time'] as String?,
    treatment: json['treatment'] as String?,
    location: json['location'] as String?,
    status: json['status'] == null
        ? null
        : SessionStatus.fromJson(json['status'] as String),
    notes: json['notes'] as String?,
    cancellationReason: json['cancellation_reason'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'patient': patientId,
    'patient_name': patientName,
    'schedule_slot': scheduleSlotId,
    'schedule_date': scheduleDate == null ? null : _formatDate(scheduleDate!),
    'schedule_time': scheduleTime,
    'treatment': treatment,
    'location': location,
    'status': status?.value,
    'notes': notes,
    'cancellation_reason': cancellationReason,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');

    final month = date.month.toString().padLeft(2, '0');

    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}

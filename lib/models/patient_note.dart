
class PatientNote {
  const PatientNote({
    this.id,
    this.patientId,
    this.therapistId,
    this.content,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final int? patientId;
  final int? therapistId;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get hasContent =>
      content != null &&
      content!.trim().isNotEmpty;

  bool get isPersisted => id != null;

  factory PatientNote.fromJson(
    Map<String, dynamic> json,
  ) {
    return PatientNote(
      id: _parseInt(json['id']),
      patientId: _parseInt(
        json['patient'],
      ),
      therapistId: _parseInt(
        json['therapist'],
      ),
      content: json['content'] as String?,
      createdAt: _parseDateTime(
        json['created_at'],
      ),
      updatedAt: _parseDateTime(
        json['updated_at'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient': patientId,
      'therapist': therapistId,
      'content': content,
      'created_at':
          createdAt?.toIso8601String(),
      'updated_at':
          updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'content': content?.trim() ?? '',
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'content': content?.trim() ?? '',
    };
  }

  PatientNote copyWith({
    int? id,
    int? patientId,
    int? therapistId,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PatientNote(
      id: id ?? this.id,
      patientId:
          patientId ?? this.patientId,
      therapistId:
          therapistId ?? this.therapistId,
      content:
          content ?? this.content,
      createdAt:
          createdAt ?? this.createdAt,
      updatedAt:
          updatedAt ?? this.updatedAt,
    );
  }

  static int? _parseInt(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  static DateTime? _parseDateTime(
    dynamic value,
  ) {
    if (value is! String ||
        value.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }
}
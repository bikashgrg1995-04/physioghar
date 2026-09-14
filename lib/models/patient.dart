class Patient {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String contact;
  final String condition;
  final List<String> treatmentHistory;
  final List<String> previousSessions;
  final List<PatientNote> notes;

  const Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.contact,
    required this.condition,
    required this.treatmentHistory,
    required this.previousSessions,
    required this.notes,
  });

  Patient copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? contact,
    String? condition,
    List<String>? treatmentHistory,
    List<String>? previousSessions,
    List<PatientNote>? notes,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      contact: contact ?? this.contact,
      condition: condition ?? this.condition,
      treatmentHistory: treatmentHistory ?? this.treatmentHistory,
      previousSessions: previousSessions ?? this.previousSessions,
      notes: notes ?? this.notes,
    );
  }
}

class PatientNote {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const PatientNote({
    required this.id,
    required this.content,
    required this.createdAt,
    this.updatedAt,
  });

  PatientNote copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PatientNote(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
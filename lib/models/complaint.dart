import 'dart:convert';

Complaint complaintFromJson(String str) => Complaint.fromJson(json.decode(str));

String complaintToJson(Complaint data) => json.encode(data.toJson());

class Complaint {
  final int? id;
  final String? category;
  final String? subject;
  final String? description;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Complaint({
    this.id,
    this.category,
    this.subject,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Complaint copyWith({
    int? id,
    String? category,
    String? subject,
    String? description,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Complaint(
    id: id ?? this.id,
    category: category ?? this.category,
    subject: subject ?? this.subject,
    description: description ?? this.description,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
    id: json["id"],
    category: json["category"],
    subject: json["subject"],
    description: json["description"],
    status: json["status"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "subject": subject,
    "description": description,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

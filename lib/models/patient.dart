import 'dart:convert';

Patient patientFromJson(String str) => Patient.fromJson(json.decode(str));

String patientToJson(Patient data) => json.encode(data.toJson());

class Patient {
  final int? id;
  final String? name;
  final int? age;
  final String? gender;
  final String? phone;
  final String? email;
  final String? address;
  final String? condition;

  Patient({
    this.id,
    this.name,
    this.age,
    this.gender,
    this.phone,
    this.email,
    this.address,
    this.condition,
  });

  Patient copyWith({
    int? id,
    String? name,
    int? age,
    String? gender,
    String? phone,
    String? email,
    String? address,
    String? condition,
  }) => Patient(
    id: id ?? this.id,
    name: name ?? this.name,
    age: age ?? this.age,
    gender: gender ?? this.gender,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    address: address ?? this.address,
    condition: condition ?? this.condition,
  );

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
    id: json['id'],
    name: json['name'],
    age: json['age'],
    gender: json['gender'],
    phone: json['phone'],
    email: json['email'],
    address: json['address'],
    condition: json['condition'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'gender': gender,
    'phone': phone,
    'email': email,
    'address': address,
    'condition': condition,
  };
}

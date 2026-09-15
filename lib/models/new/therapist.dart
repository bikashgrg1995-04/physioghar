// To parse this JSON data, do
//
//     final therapist = therapistFromJson(jsonString);

import 'dart:convert';

Therapist therapistFromJson(String str) => Therapist.fromJson(json.decode(str));

String therapistToJson(Therapist data) => json.encode(data.toJson());

class Therapist {
  final String? name;
  final String? email;
  final String? phone;
  final String? specialization;
  final String? experience;
  final String? address;
  final String? bio;
  final bool? isAvailable;
  final String? avatar;

  Therapist({
    this.name,
    this.email,
    this.phone,
    this.specialization,
    this.experience,
    this.address,
    this.bio,
    this.isAvailable,
    this.avatar,
  });

  Therapist copyWith({
    String? name,
    String? email,
    String? phone,
    String? specialization,
    String? experience,
    String? address,
    String? bio,
    bool? isAvailable,
    String? avatar,
  }) => Therapist(
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    specialization: specialization ?? this.specialization,
    experience: experience ?? this.experience,
    address: address ?? this.address,
    bio: bio ?? this.bio,
    isAvailable: isAvailable ?? this.isAvailable,
    avatar: avatar ?? this.avatar,
  );

  factory Therapist.fromJson(Map<String, dynamic> json) => Therapist(
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    specialization: json["specialization"],
    experience: json["experience"],
    address: json["address"],
    bio: json["bio"],
    isAvailable: json["is_available"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "specialization": specialization,
    "experience": experience,
    "address": address,
    "bio": bio,
    "is_available": isAvailable,
    "avatar": avatar,
  };
}

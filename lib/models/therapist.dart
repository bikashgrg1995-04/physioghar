class Therapist {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String specialization;
  final String experience;
  final String address;
  final String avatarUrl;
  final bool isAvailable;

  const Therapist({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.experience,
    required this.address,
    required this.avatarUrl,
    required this.isAvailable,
  });

  Therapist copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? specialization,
    String? experience,
    String? address,
    String? avatarUrl,
    bool? isAvailable,
  }) {
    return Therapist(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      specialization: specialization ?? this.specialization,
      experience: experience ?? this.experience,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
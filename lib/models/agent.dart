class Agent {
  final String id;
  final String fullName;
  final String businessName;
  final String email;
  final String phone;
  final String cnic;
  final String? profileImage;
  final String? bio;
  final String role;
  final bool isVerified;
  final int totalPackages;
  final int totalBookings;
  final double averageRating;

  Agent({
    required this.id,
    required this.fullName,
    required this.businessName,
    required this.email,
    required this.phone,
    required this.cnic,
    this.profileImage,
    this.bio,
    this.role = 'AGENT',
    this.isVerified = false,
    this.totalPackages = 0,
    this.totalBookings = 0,
    this.averageRating = 0.0,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      businessName: json['businessName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      cnic: json['cnic'] ?? '',
      profileImage: json['profileImage'],
      bio: json['bio'],
      role: json['role'] ?? 'AGENT',
      isVerified: json['isVerified'] ?? false,
      totalPackages: json['totalPackages'] ?? 0,
      totalBookings: json['totalBookings'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'businessName': businessName,
      'email': email,
      'phone': phone,
      'cnic': cnic,
      'profileImage': profileImage,
      'bio': bio,
    };
  }
}

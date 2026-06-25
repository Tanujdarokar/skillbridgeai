class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String? profileImage;
  final String role;
  final EducationModel? education;
  final String? careerGoal;
  final List<String>? skills;
  final String preferredLanguage;
  final String? location;
  final bool isVerified;
  final String? token;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.profileImage,
    required this.role,
    this.education,
    this.careerGoal,
    this.skills,
    required this.preferredLanguage,
    this.location,
    required this.isVerified,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] ?? json;
    return UserModel(
      id: userData['id'] ?? userData['_id'] ?? '',
      fullName: userData['fullName'] ?? userData['name'] ?? '',
      email: userData['email'] ?? '',
      phone: userData['phone'],
      profileImage: userData['profileImage'],
      role: userData['role'] ?? 'student',
      education: userData['education'] != null ? EducationModel.fromJson(userData['education']) : null,
      careerGoal: userData['careerGoal'],
      skills: userData['skills'] != null ? List<String>.from(userData['skills']) : [],
      preferredLanguage: userData['preferredLanguage'] ?? 'English',
      location: userData['location'],
      isVerified: userData['isVerified'] ?? false,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'role': role,
      'education': education?.toJson(),
      'careerGoal': careerGoal,
      'skills': skills,
      'preferredLanguage': preferredLanguage,
      'location': location,
      'isVerified': isVerified,
    };
  }
}

class EducationModel {
  final String? degree;
  final String? branch;
  final String? college;
  final int? graduationYear;

  EducationModel({
    this.degree,
    this.branch,
    this.college,
    this.graduationYear,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      degree: json['degree'],
      branch: json['branch'],
      college: json['college'],
      graduationYear: json['graduationYear'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'degree': degree,
      'branch': branch,
      'college': college,
      'graduationYear': graduationYear,
    };
  }
}

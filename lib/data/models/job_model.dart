class JobModel {
  final String id;
  final String title;
  final String companyName;
  final String location;
  final String description;
  final List<String> requiredSkills;
  final String experienceRequired;
  final String salaryRange;
  final String? applicationUrl;

  JobModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.description,
    required this.requiredSkills,
    required this.experienceRequired,
    required this.salaryRange,
    this.applicationUrl,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      companyName: json['companyName'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      requiredSkills: List<String>.from(json['requiredSkills'] ?? []),
      experienceRequired: json['experienceRequired'] ?? '',
      salaryRange: json['salaryRange'] ?? '',
      applicationUrl: json['applicationUrl'],
    );
  }
}

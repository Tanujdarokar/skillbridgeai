class ResumeModel {
  final String id;
  final String userId;
  final String? resumeUrl;
  final double atsScore;
  final List<String> extractedSkills;
  final List<String> missingKeywords;
  final List<String> strengths;
  final List<String> improvements;
  final DateTime? analyzedAt;

  ResumeModel({
    required this.id,
    required this.userId,
    this.resumeUrl,
    required this.atsScore,
    required this.extractedSkills,
    required this.missingKeywords,
    required this.strengths,
    required this.improvements,
    this.analyzedAt,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      resumeUrl: json['resumeUrl'],
      atsScore: (json['atsScore'] ?? 0).toDouble(),
      extractedSkills: List<String>.from(json['extractedSkills'] ?? []),
      missingKeywords: List<String>.from(json['missingKeywords'] ?? []),
      strengths: List<String>.from(json['strengths'] ?? []),
      improvements: List<String>.from(json['improvements'] ?? []),
      analyzedAt: json['analyzedAt'] != null ? DateTime.parse(json['analyzedAt']) : null,
    );
  }
}

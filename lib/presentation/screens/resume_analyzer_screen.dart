import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../providers/auth_provider.dart';

class ResumeAnalyzerScreen extends ConsumerStatefulWidget {
  const ResumeAnalyzerScreen({super.key});

  @override
  ConsumerState<ResumeAnalyzerScreen> createState() => _ResumeAnalyzerScreenState();
}

class _ResumeAnalyzerScreenState extends ConsumerState<ResumeAnalyzerScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _analysisResult;

  Future<void> _pickAndUploadResume() async {
    // For demo/prototype: Simulation of file pick and upload
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _isLoading = false;
      _analysisResult = {
        "resume_score": 85,
        "extracted_skills": ["Flutter", "Dart", "Firebase", "Git", "UI/UX Design"],
        "missing_skills": ["State Management (Riverpod)", "Unit Testing", "CI/CD"],
        "formatting_issues": ["Use a more professional font", "Add more quantitative achievements"],
        "recommended_courses": ["Advanced Riverpod Patterns", "Flutter Testing Masterclass"]
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Resume Analyzer', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _analysisResult == null
              ? _buildUploadPrompt()
              : _buildAnalysisResult(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(strokeWidth: 6, strokeCap: StrokeCap.round),
          ),
          const SizedBox(height: 32),
          Text(
            'Analyzing your Resume...',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('SkillBot is scanning for ATS compatibility', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildUploadPrompt() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: _pickAndUploadResume,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), shape: BoxShape.circle),
                    child: const Icon(Icons.upload_file_rounded, size: 48, color: AppColors.primary),
                  ),
                  const SizedBox(height: 20),
                  const Text('Click to upload Resume', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  const Text('Supports PDF, DOCX (Max 5MB)', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          _buildFeatureItem(Icons.analytics_outlined, 'ATS Score Calculation', 'Know how well your resume performs in automated screening.'),
          const SizedBox(height: 20),
          _buildFeatureItem(Icons.manage_search_rounded, 'Keyword Optimization', 'Discover missing keywords that recruiters are looking for.'),
          const SizedBox(height: 20),
          _buildFeatureItem(Icons.edit_note_rounded, 'Improvement Tips', 'Get actionable suggestions to polish your formatting and content.'),
          const SizedBox(height: 40),
          const SizedBox(height: 100), // Space for nav bar
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String desc) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisResult() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScoreCard(),
          const SizedBox(height: 32),
          _buildSectionHeader('Extracted Skills'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (_analysisResult!['extracted_skills'] as List)
                .map((skill) => Chip(
                      label: Text(skill, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader('Missing Keywords', color: AppColors.error),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (_analysisResult!['missing_skills'] as List)
                .map((skill) => Chip(
                      label: Text(skill, style: const TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.w600)),
                      backgroundColor: AppColors.error.withOpacity(0.05),
                      side: BorderSide(color: AppColors.error.withOpacity(0.1)),
                    ))
                .toList(),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader('Formatting & Content'),
          ...(_analysisResult!['formatting_issues'] as List).map((issue) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.warning, size: 20),
                    const SizedBox(width: 12),
                    Expanded(child: Text(issue, style: const TextStyle(fontSize: 14))),
                  ],
                ),
              )),
          const SizedBox(height: 32),
          _buildSectionHeader('Improvement Suggestions'),
          ...(_analysisResult!['recommended_courses'] as List).map((course) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(child: Text(course, style: const TextStyle(fontWeight: FontWeight.w600))),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primary),
                  ],
                ),
              )),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: () => setState(() => _analysisResult = null),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Upload New Resume'),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color ?? AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    final score = _analysisResult!['resume_score'];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ATS Compatibility Score', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 4),
              Text('$score%', style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('Great work! Your resume is looking strong.', style: TextStyle(color: Colors.white, fontSize: 11)),
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 8,
                  backgroundColor: Colors.white24,
                  color: Colors.white,
                  strokeCap: StrokeCap.round,
                ),
              ),
              const Icon(Icons.description_rounded, color: Colors.white, size: 30),
            ],
          ),
        ],
      ),
    );
  }
}

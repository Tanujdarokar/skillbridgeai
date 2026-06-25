import 'package:flutter/material.dart';
import '../../core/theme.dart';

class LearningRoadmapScreen extends StatelessWidget {
  const LearningRoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Career Roadmap', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressCard(),
            const SizedBox(height: 32),
            const Text('Daily Learning Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildDailyTask('Introduction to Riverpod', '15 mins', true),
            _buildDailyTask('Practice 5 LeetCode Problems', '45 mins', false),
            const SizedBox(height: 32),
            const Text('Your Path to Senior Flutter Dev', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildMilestone('Master Flutter Basics', 'Completed', true, true),
            _buildMilestone('Advanced State Management', 'In Progress', false, true),
            _buildMilestone('Testing & CI/CD', 'Locked', false, false),
            _buildMilestone('Full Stack Integration', 'Locked', false, false),
            const SizedBox(height: 32),
            const Text('Recommended Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildCourseCard('Flutter & Dart - The Complete Guide', 'Udemy', '4.8 ★'),
            _buildCourseCard('Google Flutter Certification', 'Coursera', '4.9 ★'),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overall Progress', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  Text('45% Completed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: const Text('Level 4', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: 0.45,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: AppColors.background,
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTask(String title, String duration, bool isDone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDone ? AppColors.success.withOpacity(0.2) : Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(isDone ? Icons.check_circle_rounded : Icons.circle_outlined, color: isDone ? AppColors.success : Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, decoration: isDone ? TextDecoration.lineThrough : null)),
                Text(duration, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestone(String title, String status, bool isCompleted, bool isUnlocked) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? AppColors.success : (isUnlocked ? AppColors.primary : Colors.grey.shade300),
              ),
            ),
            Container(width: 2, height: 40, color: Colors.grey.shade200),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isUnlocked ? AppColors.textPrimary : Colors.grey)),
              Text(status, style: TextStyle(color: isCompleted ? AppColors.success : (isUnlocked ? AppColors.primary : Colors.grey), fontSize: 12)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCard(String title, String platform, String rating) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.school_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('$platform • $rating', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.open_in_new_rounded, size: 18, color: AppColors.primary),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../core/theme.dart';

class MockInterviewScreen extends StatefulWidget {
  const MockInterviewScreen({super.key});

  @override
  State<MockInterviewScreen> createState() => _MockInterviewScreenState();
}

class _MockInterviewScreenState extends State<MockInterviewScreen> {
  bool _hasStarted = false;
  int _currentQuestionIndex = 0;
  String _selectedType = '';

  final List<String> _questions = [
    "Tell me about yourself.",
    "What are your strengths and weaknesses?",
    "Why do you want to work for this company?",
    "Describe a challenging situation you faced and how you handled it.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Mock Interview', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: !_hasStarted ? _buildTypeSelection() : _buildInterviewUI(),
    );
  }

  Widget _buildTypeSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Choose Interview Type', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text('SkillBot will customize questions based on your choice.', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 32),
          _buildTypeCard('Technical Interview', 'Coding, System Design, DSA', Icons.computer_rounded, Colors.blue),
          const SizedBox(height: 16),
          _buildTypeCard('HR Interview', 'Behavioral, Culture fit, Goals', Icons.people_rounded, Colors.orange),
          const SizedBox(height: 16),
          _buildTypeCard('Project Discussion', 'Previous work, Technologies used', Icons.account_tree_rounded, Colors.purple),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildTypeCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedType = title;
            _hasStarted = true;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInterviewUI() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Question ${_currentQuestionIndex + 1}/${_questions.length}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
              TextButton(onPressed: () => setState(() => _hasStarted = false), child: const Text('Exit')),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.primary.withOpacity(0.1)),
            ),
            child: Text(
              _questions[_currentQuestionIndex],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
            ),
          ),
          const Spacer(),
          Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mic_rounded, size: 64, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Tap to start speaking', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Text('Interview Type: $_selectedType', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (_currentQuestionIndex < _questions.length - 1) {
                  setState(() => _currentQuestionIndex++);
                } else {
                  _showResults();
                }
              },
              child: Text(_currentQuestionIndex < _questions.length - 1 ? 'Next Question' : 'Finish Interview'),
            ),
          ),
        ],
      ),
    );
  }

  void _showResults() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 80),
            const SizedBox(height: 24),
            const Text('Performance Report', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            _buildScoreItem('Technical Score', 75, AppColors.primary),
            const SizedBox(height: 16),
            _buildScoreItem('Communication', 90, AppColors.success),
            const SizedBox(height: 16),
            _buildScoreItem('Confidence', 82, Colors.orange),
            const SizedBox(height: 40),
            const Text('SkillBot Suggestion:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            const Text(
              'Your communication is excellent! However, you should focus on providing more quantitative examples in your behavioral answers.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Back to Dashboard'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem(String label, int score, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('$score%', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: score / 100,
          backgroundColor: color.withOpacity(0.1),
          color: color,
          minHeight: 8,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }
}

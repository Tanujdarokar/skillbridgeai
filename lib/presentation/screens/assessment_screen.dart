import 'package:flutter/material.dart';
import '../../core/theme.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  bool _isTakingTest = false;
  int _currentQuestion = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the primary function of a "State" in Flutter?',
      'options': [
        'To store data that might change over time',
        'To define the static UI layout',
        'To handle network requests only',
        'To manage device hardware'
      ],
      'answer': 0
    },
    {
      'question': 'Which widget is used for creating a scrollable list of widgets?',
      'options': ['Column', 'Row', 'ListView', 'Stack'],
      'answer': 2
    },
    {
      'question': 'What does "pubspec.yaml" file contain?',
      'options': ['App source code', 'Project dependencies and metadata', 'Compiled binary', 'System logs'],
      'answer': 1
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Skill Assessment', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _isTakingTest ? _buildTestUI() : _buildCategorySelection(),
    );
  }

  Widget _buildCategorySelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Target Career', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text('Pick a domain to assess your current skill level.', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 32),
          _buildCategoryCard('Software Engineer', 'Mobile, Web, Backend', Icons.code_rounded, Colors.blue),
          const SizedBox(height: 16),
          _buildCategoryCard('Data Analyst', 'SQL, Python, Visualization', Icons.analytics_rounded, Colors.orange),
          const SizedBox(height: 16),
          _buildCategoryCard('UI/UX Designer', 'Figma, User Research', Icons.palette_rounded, Colors.purple),
          const SizedBox(height: 16),
          _buildCategoryCard('Cloud Engineer', 'AWS, Docker, Kubernetes', Icons.cloud_done_rounded, Colors.indigo),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      child: InkWell(
        onTap: () => setState(() => _isTakingTest = true),
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

  Widget _buildTestUI() {
    final question = _questions[_currentQuestion];
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Question ${_currentQuestion + 1}/${_questions.length}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
              TextButton(onPressed: () => setState(() => _isTakingTest = false), child: const Text('Exit')),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentQuestion + 1) / _questions.length,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 40),
          Text(question['question'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 32),
          ...List.generate(question['options'].length, (index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentQuestion < _questions.length - 1) {
                    setState(() => _currentQuestion++);
                  } else {
                    _showResults();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                child: Text(question['options'][index]),
              ),
            );
          }),
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
            const Icon(Icons.stars_rounded, color: Colors.amber, size: 80),
            const SizedBox(height: 24),
            const Text('Assessment Complete!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('You scored 85% in Software Engineering', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 40),
            _buildResultStat('Skill Match', '85%', AppColors.success),
            const SizedBox(height: 16),
            _buildResultStat('Missing Skills', '3 Areas', AppColors.error),
            const SizedBox(height: 40),
            const Text('Your Weak Areas:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            const Text('• Unit Testing\n• State Management (Advanced)\n• CI/CD Pipelines', style: TextStyle(height: 1.8)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => _isTakingTest = false);
                },
                child: const Text('Generate Learning Roadmap'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w800, color: color, fontSize: 18)),
        ],
      ),
    );
  }
}

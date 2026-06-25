import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Controllers
  final _locationController = TextEditingController();
  final _collegeController = TextEditingController();
  final _degreeController = TextEditingController();
  final _branchController = TextEditingController();
  final _goalController = TextEditingController();
  String _preferredLanguage = 'English';
  final List<String> _selectedSkills = [];

  @override
  void dispose() {
    _locationController.dispose();
    _collegeController.dispose();
    _degreeController.dispose();
    _branchController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Complete Your Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              )
            : null,
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentStep = index),
              children: [
                _buildPersonalStep(),
                _buildEducationStep(),
                _buildCareerStep(),
                _buildSkillsStep(),
              ],
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(4, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index <= _currentStep ? AppColors.primary : Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPersonalStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Personal Information', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Tell us a bit about yourself to personalize your experience.', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 32),
          _buildTextField('Location', 'e.g. Ahmedabad, Gujarat', Icons.location_on_outlined, _locationController),
          const SizedBox(height: 20),
          _buildDropdownField('Preferred Language', ['English', 'Hindi', 'Gujarati', 'Marathi', 'Tamil'], Icons.translate_rounded, (val) {
            setState(() => _preferredLanguage = val!);
          }),
        ],
      ),
    );
  }

  Widget _buildEducationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Educational Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Your education helps us recommend the right career paths.', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 32),
          _buildTextField('School/College', 'e.g. IIT Bombay', Icons.school_outlined, _collegeController),
          const SizedBox(height: 20),
          _buildTextField('Degree', 'e.g. B.Tech', Icons.history_edu_rounded, _degreeController),
          const SizedBox(height: 20),
          _buildTextField('Branch/Major', 'e.g. Computer Science', Icons.account_tree_outlined, _branchController),
        ],
      ),
    );
  }

  Widget _buildCareerStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Career Preferences', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('What are your professional goals?', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 32),
          _buildTextField('Dream Job Role', 'e.g. Full Stack Developer', Icons.stars_rounded, _goalController),
        ],
      ),
    );
  }

  Widget _buildSkillsStep() {
    final List<String> skills = ['Java', 'Python', 'Flutter', 'React', 'SQL', 'C++', 'Communication', 'Problem Solving', 'Leadership'];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current Skills', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Select the skills you already possess.', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 32),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: skills.map((skill) {
              final isSelected = _selectedSkills.contains(skill);
              return FilterChip(
                label: Text(skill),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedSkills.add(skill);
                    } else {
                      _selectedSkills.remove(skill);
                    }
                  });
                },
                selected: isSelected,
                backgroundColor: Colors.white,
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.2))),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    final authState = ref.watch(authProvider);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: authState.isLoading ? null : () {
            if (_currentStep < 3) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              _finishSetup();
            }
          },
          child: authState.isLoading 
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(_currentStep == 3 ? 'Complete Profile' : 'Next Step'),
        ),
      ),
    );
  }

  void _finishSetup() async {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    final success = await ref.read(authProvider.notifier).updateProfile(
      fullName: user.fullName,
      phone: user.phone ?? '',
      location: _locationController.text,
      degree: _degreeController.text,
      college: _collegeController.text,
      careerGoal: _goalController.text,
      skills: _selectedSkills,
      preferredLanguage: _preferredLanguage,
    );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  Widget _buildTextField(String label, String hint, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items, IconData icon, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20),
          ),
          hint: const Text('Select Option'),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

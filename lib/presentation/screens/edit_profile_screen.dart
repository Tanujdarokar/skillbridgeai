import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _degreeController;
  late TextEditingController _collegeController;
  late TextEditingController _goalController;
  String _preferredLanguage = 'English';
  final List<String> _selectedSkills = [];
  final List<String> _allSkills = ['Java', 'Python', 'Flutter', 'React', 'SQL', 'C++', 'Communication', 'Problem Solving', 'Leadership'];

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameController = TextEditingController(text: user?.fullName);
    _phoneController = TextEditingController(text: user?.phone);
    _locationController = TextEditingController(text: user?.location);
    _degreeController = TextEditingController(text: user?.education?.degree);
    _collegeController = TextEditingController(text: user?.education?.college);
    _goalController = TextEditingController(text: user?.careerGoal);
    _preferredLanguage = user?.preferredLanguage ?? 'English';
    if (user?.skills != null) {
      _selectedSkills.addAll(user!.skills!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _degreeController.dispose();
    _collegeController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (authState.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Basic Information'),
            const SizedBox(height: 16),
            _buildTextField('Full Name', _nameController, Icons.person_outline_rounded),
            const SizedBox(height: 20),
            _buildTextField('Phone Number', _phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            _buildTextField('Location', _locationController, Icons.location_on_outlined),
            const SizedBox(height: 20),
            _buildDropdownField('Preferred Language', ['English', 'Hindi', 'Gujarati', 'Marathi', 'Tamil'], Icons.translate_rounded, (val) {
              setState(() => _preferredLanguage = val!);
            }, initialValue: _preferredLanguage),
            
            const SizedBox(height: 32),
            _buildSectionTitle('Academic Details'),
            const SizedBox(height: 16),
            _buildTextField('Degree', _degreeController, Icons.school_outlined),
            const SizedBox(height: 20),
            _buildTextField('College/University', _collegeController, Icons.apartment_outlined),
            
            const SizedBox(height: 32),
            _buildSectionTitle('Career Goals'),
            const SizedBox(height: 16),
            _buildTextField('Dream Job Role', _goalController, Icons.track_changes_outlined),

            const SizedBox(height: 32),
            _buildSectionTitle('Skills'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _allSkills.map((skill) {
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
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items, IconData icon, Function(String?) onChanged, {String? initialValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: initialValue,
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

  void _saveProfile() async {
    final success = await ref.read(authProvider.notifier).updateProfile(
      fullName: _nameController.text,
      phone: _phoneController.text,
      location: _locationController.text,
      degree: _degreeController.text,
      college: _collegeController.text,
      careerGoal: _goalController.text,
      skills: _selectedSkills,
      preferredLanguage: _preferredLanguage,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: AppColors.success),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ref.read(authProvider).error ?? 'Update failed'), backgroundColor: AppColors.error),
      );
    }
  }
}

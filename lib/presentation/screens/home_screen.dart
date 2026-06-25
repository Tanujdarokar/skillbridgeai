import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/dashboard_cards.dart';
import 'resume_analyzer_screen.dart';
import 'ai_chatbot_screen.dart';
import 'mock_interview_screen.dart';
import 'learning_roadmap_screen.dart';
import 'jobs_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import 'assessment_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeDashboard(),
    AssessmentScreen(),
    AIChatbotScreen(),
    JobsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildModernNavBar(),
    );
  }

  Widget _buildModernNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(0, Icons.home_rounded, 'Home'),
          _buildNavItem(1, Icons.assignment_rounded, 'Assess'),
          _buildNavItem(2, Icons.smart_toy_rounded, 'Mentor'),
          _buildNavItem(3, Icons.work_rounded, 'Jobs'),
          _buildNavItem(4, Icons.person_rounded, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class HomeDashboard extends ConsumerWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Optimization: Watch only the fullName property for the greeting
    final userName = ref.watch(authProvider.select((s) => s.user?.fullName.split(' ')[0] ?? "Student"));
    final userInitial = ref.watch(authProvider.select((s) => s.user?.fullName[0] ?? 'S'));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, $userName 👋',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: AppColors.textPrimary),
                      ),
                      const Text(
                        'Ready to level up today?',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        radius: 20,
                        child: Text(userInitial, style: const TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
                        icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
                        style: IconButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.all(10)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Row(
                  children: [
                    Expanded(child: ScoreCard(label: 'Skill Score', score: '78', color: AppColors.primary, icon: Icons.psychology_rounded)),
                    SizedBox(width: 16),
                    Expanded(child: ScoreCard(label: 'Resume Score', score: '85', color: AppColors.secondary, icon: Icons.description_rounded)),
                  ],
                ),
                const SizedBox(height: 16),
                const _TopJobMatchCard(),
                const SizedBox(height: 24),
                const _ProgressOverviewSection(),
                const SizedBox(height: 32),
                const Text('Recommended Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 16),
                const _QuickActionsGrid(),
                const SizedBox(height: 32),
                const Text('Upcoming Tasks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 16),
                const _UpcomingTasksList(),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Skill Growth', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    TextButton(onPressed: () {}, child: const Text('View Report')),
                  ],
                ),
                const SizedBox(height: 16),
                const _SkillChartCard(),
                const SizedBox(height: 32),
                const Text('Learning Path', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 16),
                const _LearningCard(),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopJobMatchCard extends StatelessWidget {
  const _TopJobMatchCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.success.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.work_rounded, color: AppColors.success),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Top Job Match', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                Text('Flutter Developer at TechNova', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          const Column(
            children: [
              Text('95%', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: AppColors.success)),
              Text('Match', style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressOverviewSection extends StatelessWidget {
  const _ProgressOverviewSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Overall Readiness Score', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          const Text('78%', style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800)),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.78,
              minHeight: 10,
              backgroundColor: Colors.white24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              _StatsInfo(value: '4', label: 'Assigned'),
              SizedBox(width: 24),
              _StatsInfo(value: '12', label: 'Skills'),
              SizedBox(width: 24),
              _StatsInfo(value: '2', label: 'Interviews'),
            ],
          )
        ],
      ),
    );
  }
}

class _StatsInfo extends StatelessWidget {
  final String value;
  final String label;

  const _StatsInfo({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        ActionCard(
          icon: Icons.analytics_rounded,
          label: 'Resume\nAnalysis',
          bg: const Color(0xFFEEF2FF),
          color: AppColors.primary,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ResumeAnalyzerScreen())),
        ),
        ActionCard(
          icon: Icons.video_call_rounded,
          label: 'Mock\nInterview',
          bg: const Color(0xFFFFF7ED),
          color: Colors.orange,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MockInterviewScreen())),
        ),
        ActionCard(
          icon: Icons.map_rounded,
          label: 'Learning\nPath',
          bg: const Color(0xFFF0FDF4),
          color: Colors.green,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LearningRoadmapScreen())),
        ),
        const ActionCard(
          icon: Icons.psychology_rounded,
          label: 'Skill\nAssessment',
          bg: Color(0xFFFAF5FF),
          color: Colors.purple,
          // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AssessmentScreen())),
        ),
      ],
    );
  }
}

class _UpcomingTasksList extends StatelessWidget {
  const _UpcomingTasksList();

  @override
  Widget build(BuildContext context) {
    const tasks = [
      {'title': 'Complete Python Assessment', 'time': 'Today, 2:00 PM', 'icon': Icons.assignment_rounded, 'color': Colors.blue},
      {'title': 'Revise Mock Interview Tips', 'time': 'Tomorrow, 10:00 AM', 'icon': Icons.video_call_rounded, 'color': Colors.orange},
    ];

    return Column(
      children: tasks.map((task) => Container(
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: (task['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(task['icon'] as IconData, color: task['color'] as Color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(task['time'] as String, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
          ],
        ),
      )).toList(),
    );
  }
}

class _SkillChartCard extends StatelessWidget {
  const _SkillChartCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 200,
          child: LineChart(
            LineChartBarData(
              spots: const [FlSpot(0, 35), FlSpot(1, 45), FlSpot(2, 65), FlSpot(3, 80)],
              isCurved: true,
              color: AppColors.primary,
              barWidth: 6,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [AppColors.primary.withOpacity(0.2), AppColors.primary.withOpacity(0.0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ).toLineChartData(),
          ),
        ),
      ),
    );
  }
}

extension on LineChartBarData {
  LineChartData toLineChartData() {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [this],
    );
  }
}

class _LearningCard extends StatelessWidget {
  const _LearningCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.code_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data Science with Python', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Next: Intro to NumPy', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

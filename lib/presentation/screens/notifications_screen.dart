import 'package:flutter/material.dart';
import '../../core/theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'New Job Match Found!',
        'body': 'A Flutter Developer role at Google matches 98% of your profile.',
        'time': '2 mins ago',
        'icon': Icons.work_rounded,
        'color': Colors.blue,
      },
      {
        'title': 'Daily Task Reminder',
        'body': 'Don\'t forget to complete your "State Management" lesson today.',
        'time': '1 hour ago',
        'icon': Icons.task_alt_rounded,
        'color': Colors.orange,
      },
      {
        'title': 'Resume Score Improved',
        'body': 'Great job! Your recent updates improved your ATS score by 15%.',
        'time': 'Yesterday',
        'icon': Icons.description_rounded,
        'color': Colors.green,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(item['time'] as String, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['body'] as String,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

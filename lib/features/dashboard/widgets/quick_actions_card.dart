import 'package:flutter/material.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  Widget _action(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
  ) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("$title coming soon 🚀"),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(.15),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: color,
                size: 32,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _action(
          context,
          Icons.menu_book_rounded,
          "Courses",
          Colors.blue,
        ),
        const SizedBox(width: 12),
        _action(
          context,
          Icons.quiz_rounded,
          "Quiz",
          Colors.orange,
        ),
        const SizedBox(width: 12),
        _action(
          context,
          Icons.person,
          "Profile",
          Colors.green,
        ),
      ],
    );
  }
}
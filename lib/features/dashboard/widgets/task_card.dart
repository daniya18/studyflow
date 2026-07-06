import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key});

  Widget _task(String title, bool completed) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        completed
            ? Icons.check_circle
            : Icons.radio_button_unchecked,
        color: completed ? Colors.greenAccent : Colors.white70,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          decoration:
              completed ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Row(
            children: [
              Icon(
                Icons.task_alt_rounded,
                color: Colors.greenAccent,
              ),
              SizedBox(width: 10),
              Text(
                "Today's Tasks",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _task("Complete Authentication", true),
          _task("Firebase Integration", true),
          _task("Build Dashboard", false),
          _task("Create Quiz Module", false),

        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:studyflow/core/services/lesson_service.dart';
import 'package:studyflow/features/lessons/widgets/lesson_card.dart';
import 'package:studyflow/models/course_model.dart';
import 'package:studyflow/models/lesson_model.dart';
import 'lesson_details_screen.dart';

class LessonScreen extends StatelessWidget {
  final CourseModel course;

  const LessonScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(course.title),
      ),

      body: StreamBuilder<List<LessonModel>>(
        stream: LessonService.instance.getLessons(course.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No lessons available",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            );
          }

          final lessons = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: lessons.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return LessonCard(
                lesson: lessons[index],
                onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
     builder: (_) => LessonDetailsScreen(
  courseId: course.id,
  lesson: lessons[index],
),
    ),
  );
},
              );
            },
          );
        },
      ),
    );
  }
}
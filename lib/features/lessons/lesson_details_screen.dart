import 'package:flutter/material.dart';
import 'package:studyflow/core/services/lesson_service.dart';
import 'package:studyflow/models/lesson_model.dart';

class LessonDetailsScreen extends StatefulWidget {
  final String courseId;
  final LessonModel lesson;

  const LessonDetailsScreen({
    super.key,
    required this.courseId,
    required this.lesson,
  });

  @override
  State<LessonDetailsScreen> createState() =>
      _LessonDetailsScreenState();
}

class _LessonDetailsScreenState
    extends State<LessonDetailsScreen> {
  bool _loading = false;
  late bool _completed;

  @override
  void initState() {
    super.initState();
    _completed = widget.lesson.completed;
  }

  Future<void> _markComplete() async {
    if (_completed) return;

    setState(() {
      _loading = true;
    });

    try {
      await LessonService.instance.markCompleted(
        widget.courseId,
        widget.lesson.id,
        true,
      );

      if (!mounted) return;

      setState(() {
        _completed = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Lesson marked as completed 🎉",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.lesson.title),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(20),
                color: Colors.deepPurple,
              ),
              child: const Center(
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 90,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              widget.lesson.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              widget.lesson.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                const Icon(
                  Icons.schedule,
                  color: Colors.amber,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.lesson.duration,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _loading
                    ? null
                    : () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Video Player coming in next step",
                            ),
                          ),
                        );
                      },
                icon: const Icon(Icons.play_arrow),
                label: const Text(
                  "Play Lesson",
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed:
                    _loading || _completed
                        ? null
                        : _markComplete,
                icon: Icon(
                  _completed
                      ? Icons.check_circle
                      : Icons.task_alt,
                ),
                label: Text(
                  _completed
                      ? "Completed"
                      : "Mark as Complete",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:studyflow/core/services/course_service.dart';
import 'package:studyflow/features/courses/widgets/course_card.dart';
import 'package:studyflow/models/course_model.dart';
import 'course_details_screen.dart';
class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final TextEditingController _searchController = TextEditingController();

  String searchText = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Courses"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search Courses",
                hintStyle:
                    const TextStyle(color: Colors.white54),
                prefixIcon:
                    const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<List<CourseModel>>(
                stream: CourseService.instance.getCourses(),
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
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "No courses found",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    );
                  }

                  final courses = snapshot.data!
                      .where(
                        (course) => course.title
                            .toLowerCase()
                            .contains(searchText),
                      )
                      .toList();

                  return ListView.separated(
                    itemCount: courses.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return CourseCard(
                        course: courses[index],
                       onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CourseDetailsScreen(
        course: courses[index],
      ),
    ),
  );
},
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
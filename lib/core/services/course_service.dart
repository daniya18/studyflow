import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyflow/models/course_model.dart';

class CourseService {
  CourseService._();

  static final CourseService instance = CourseService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _courseRef =>
      _firestore.collection('courses');

  /// Stream all courses
  Stream<List<CourseModel>> getCourses() {
  return _courseRef
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
    for (final doc in snapshot.docs) {
      print("==========");
      print(doc.id);
      print(doc.data());
    }

    return snapshot.docs
        .map((doc) => CourseModel.fromFirestore(doc))
        .toList();
  });
}

  /// Featured course
  Stream<CourseModel?> getFeaturedCourse() {
    return _courseRef
        .where('featured', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return CourseModel.fromFirestore(snapshot.docs.first);
    });
  }

  /// Get single course
  Future<CourseModel?> getCourse(String courseId) async {
    final doc = await _courseRef.doc(courseId).get();

    if (!doc.exists) return null;

    return CourseModel.fromFirestore(doc);
  }

  /// Add Course
  Future<void> addCourse(CourseModel course) async {
    await _courseRef.add(course.toMap());
  }

  /// Update Course
  Future<void> updateCourse(CourseModel course) async {
    await _courseRef.doc(course.id).update(course.toMap());
  }

  /// Delete Course
  Future<void> deleteCourse(String id) async {
    await _courseRef.doc(id).delete();
  }
}
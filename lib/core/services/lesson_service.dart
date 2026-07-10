import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyflow/models/lesson_model.dart';

class LessonService {
  LessonService._();

  static final LessonService instance = LessonService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _lessonRef(
    String courseId,
  ) {
    return _firestore
        .collection('courses')
        .doc(courseId)
        .collection('lessons');
  }

  /// Get all lessons of a course
  Stream<List<LessonModel>> getLessons(String courseId) {
    return _lessonRef(courseId)
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LessonModel.fromFirestore(doc))
              .toList(),
        );
  }

  /// Get one lesson
  Future<LessonModel?> getLesson(
    String courseId,
    String lessonId,
  ) async {
    final doc = await _lessonRef(courseId).doc(lessonId).get();

    if (!doc.exists) return null;

    return LessonModel.fromFirestore(doc);
  }

  /// Add lesson
  Future<void> addLesson(
    String courseId,
    LessonModel lesson,
  ) async {
    await _lessonRef(courseId).add(
      lesson.toMap(),
    );
  }

  /// Update lesson
  Future<void> updateLesson(
    String courseId,
    LessonModel lesson,
  ) async {
    await _lessonRef(courseId)
        .doc(lesson.id)
        .update(
          lesson.toMap(),
        );
  }

  /// Mark lesson complete
  Future<void> markCompleted(
    String courseId,
    String lessonId,
    bool completed,
  ) async {
    await _lessonRef(courseId)
        .doc(lessonId)
        .update({
      'completed': completed,
    });
  }

  /// Delete lesson
  Future<void> deleteLesson(
    String courseId,
    String lessonId,
  ) async {
    await _lessonRef(courseId)
        .doc(lessonId)
        .delete();
  }
}
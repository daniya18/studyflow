import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final String teacher;
  final String category;
  final double rating;
  final int totalLessons;
  final int completedLessons;
  final double progress;
  final bool featured;
  final Timestamp? createdAt;

  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.teacher,
    required this.category,
    required this.rating,
    required this.totalLessons,
    required this.completedLessons,
    required this.progress,
    required this.featured,
    this.createdAt,
  });

  factory CourseModel.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;

  final ratingValue = data['rating'];
  final progressValue = data['progress'];

  return CourseModel(
    id: doc.id,
    title: data['title'] ?? '',
    description: data['description'] ?? '',
    image: data['image'] ?? '',
    teacher: data['teacher'] ?? '',
    category: data['category'] ?? '',
    rating: ratingValue is num ? ratingValue.toDouble() : 0.0,
    totalLessons: data['totalLessons'] ?? 0,
    completedLessons: data['completedLessons'] ?? 0,
    progress: progressValue is num ? progressValue.toDouble() : 0.0,
    featured: data['featured'] ?? false,
    createdAt: data['createdAt'] as Timestamp?,
  );
}

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'teacher': teacher,
      'category': category,
      'rating': rating,
      'totalLessons': totalLessons,
      'completedLessons': completedLessons,
      'progress': progress,
      'featured': featured,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? image,
    String? teacher,
    String? category,
    double? rating,
    int? totalLessons,
    int? completedLessons,
    double? progress,
    bool? featured,
    Timestamp? createdAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      teacher: teacher ?? this.teacher,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      totalLessons: totalLessons ?? this.totalLessons,
      completedLessons: completedLessons ?? this.completedLessons,
      progress: progress ?? this.progress,
      featured: featured ?? this.featured,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
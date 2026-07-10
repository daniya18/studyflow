import 'package:cloud_firestore/cloud_firestore.dart';

class LessonModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String duration;
  final int order;
  final bool completed;

  const LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.duration,
    required this.order,
    required this.completed,
  });

  factory LessonModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return LessonModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      duration: data['duration'] ?? '',
      order: (data['order'] ?? 0) as int,
      completed: data['completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'duration': duration,
      'order': order,
      'completed': completed,
    };
  }

  LessonModel copyWith({
    String? id,
    String? title,
    String? description,
    String? videoUrl,
    String? duration,
    int? order,
    bool? completed,
  }) {
    return LessonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      duration: duration ?? this.duration,
      order: order ?? this.order,
      completed: completed ?? this.completed,
    );
  }
}
class UserModel {
  final String name;
  final String email;
  final int progress;
  final int streak;
  final int achievements;

  UserModel({
    required this.name,
    required this.email,
    required this.progress,
    required this.streak,
    required this.achievements,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? 'Student',
      email: map['email'] ?? '',
      progress: map['progress'] ?? 0,
      streak: map['streak'] ?? 0,
      achievements: map['achievements'] ?? 0,
    );
  }
}
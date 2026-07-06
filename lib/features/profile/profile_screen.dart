import 'package:flutter/material.dart';

import '../../core/services/firestore_service.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/gradient_background.dart';
import '../../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: FutureBuilder<UserModel?>(
          future: FirestoreService.getCurrentUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  "User not found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final user = snapshot.data!;

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    const CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white24,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      user.email.isEmpty
                          ? "No Email Available"
                          : user.email,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 30),

                    GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 12,
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          children: [
                            _buildStat(
                              "Progress",
                              "${user.progress}%",
                              Icons.show_chart,
                              Colors.blue,
                            ),
                            _buildStat(
                              "Streak",
                              "${user.streak}",
                              Icons.local_fire_department,
                              Colors.orange,
                            ),
                            _buildStat(
                              "Badges",
                              "${user.achievements}",
                              Icons.emoji_events,
                              Colors.amber,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    GlassCard(
                      child: ListTile(
                        leading: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Edit Profile",
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white70,
                          size: 18,
                        ),
                        onTap: () {},
                      ),
                    ),

                    const SizedBox(height: 16),

                    GlassCard(
                      child: ListTile(
                        leading: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        title: const Text(
                          "Settings",
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white70,
                          size: 18,
                        ),
                        onTap: () {},
                      ),
                    ),

                    const SizedBox(height: 16),

                    GlassCard(
                      child: ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.redAccent,
                        ),
                        title: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white70,
                          size: 18,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStat(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 30,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
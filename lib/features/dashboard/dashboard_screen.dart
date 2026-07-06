import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/firestore_service.dart';
import '../../models/user_model.dart';

import '../auth/login_screen.dart';
import '../profile/profile_screen.dart';

import 'widgets/greeting_card.dart';
import 'widgets/progress_card.dart';
import 'widgets/stats_card.dart';
import 'widgets/task_card.dart';
import 'widgets/quick_actions_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "StudyFlow",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),

      body: FutureBuilder<UserModel?>(
        future: FirestoreService.getCurrentUserProfile(),
        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "No user data found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final user = snapshot.data!;

          return SafeArea(
            child: SingleChildScrollView(
  padding: const EdgeInsets.all(20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      GreetingCard(
        name: user.name,
      ),

      const SizedBox(height: 20),

      ProgressCard(
        progress: user.progress / 100,
      ),

      const SizedBox(height: 20),

      Row(
        children: [

          Expanded(
            child: StatsCard(
              icon: Icons.local_fire_department,
              iconColor: Colors.orange,
              value: user.streak.toString(),
              title: "Day Streak",
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: StatsCard(
              icon: Icons.emoji_events_rounded,
              iconColor: Colors.amber,
              value: user.achievements.toString(),
              title: "Achievements",
            ),
          ),

        ],
      ),

      const SizedBox(height: 20),

      const TaskCard(),

      const SizedBox(height: 20),

      const QuickActionsCard(),

      const SizedBox(height: 30),

      SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();

            final prefs =
                await SharedPreferences.getInstance();

            await prefs.setBool(
              "rememberMe",
              false,
            );

            if (!context.mounted) return;

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          icon: const Icon(Icons.logout),
          label: const Text(
            "Logout",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      const SizedBox(height: 30),
          ],
  ),
),
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          switch (index) {
            case 0:
              break;

            case 1:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Courses coming soon"),
                ),
              );
              break;

            case 2:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Quiz coming soon"),
                ),
              );
              break;

            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
              break;
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: "Courses",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz_rounded),
            label: "Quiz",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
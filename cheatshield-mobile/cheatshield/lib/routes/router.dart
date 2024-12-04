import 'package:cheatshield/screens/camera_screen.dart';
import 'package:cheatshield/screens/history_screen.dart';
import 'package:cheatshield/screens/home_screen.dart';
import 'package:cheatshield/screens/login_screen.dart';
import 'package:cheatshield/screens/profile_screen.dart';
import 'package:cheatshield/screens/quiz_screen.dart';
import 'package:cheatshield/screens/update_profile_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/quiz', builder: (context, state) => const QuizScreen()),
    GoRoute(path: '/camera', builder: (context, state) => const CameraScreen()),
    GoRoute(
        path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(
        path: '/history', builder: (context, state) => const HistoryScreen()),
    GoRoute(
        path: '/update-profile',
        builder: (context, state) => const UpdateProfileScreen()),
  ],
);

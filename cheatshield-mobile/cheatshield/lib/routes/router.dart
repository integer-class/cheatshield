import 'package:cheatshield/providers/web/auth_provider.dart';
import 'package:cheatshield/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cheatshield/components/footer/bottom_navbar.dart';
import 'package:cheatshield/screens/camera_screen.dart';
import 'package:cheatshield/screens/history_screen.dart';
import 'package:cheatshield/screens/home_screen.dart';
import 'package:cheatshield/screens/login_screen.dart';
import 'package:cheatshield/screens/profile_screen.dart';
import 'package:cheatshield/screens/quiz_screen.dart';
import 'package:cheatshield/screens/update_profile_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

GoRouter? _previousRouter;

final routerProvider = Provider((ref) {
  final auth = ref.watch(authProvider);

  return _previousRouter = GoRouter(
    initialLocation:
        _previousRouter?.routerDelegate.currentConfiguration.fullPath ??
            "/login",
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      try {
        if (auth["token"] != null && state.matchedLocation == '/login') {
          return '/home';
        }
        return null;
      } catch (e) {
        debugPrint(e.toString());
        return null;
      }
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: child,
            bottomNavigationBar: BottomNavbar(),
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/quiz',
            builder: (context, state) => const QuizScreen(),
          ),
          GoRoute(
            path: '/camera',
            builder: (context, state) => const CameraScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/update-profile',
            builder: (context, state) => const UpdateProfileScreen(),
          ),
        ],
      ),
    ],
  );
});

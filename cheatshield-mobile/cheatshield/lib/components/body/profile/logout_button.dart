import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cheatshield/providers/web/auth_provider.dart';

class LogoutButton extends StatelessWidget {
  final AuthNotifier authNotifier;
  const LogoutButton({required this.authNotifier, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton(
        onPressed: () async {
          // Logout using authNotifier
          await authNotifier.logout();
          // Redirect to login page
          if (context.mounted) {
            context.go('/');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEFC6C2), // neutral color
          minimumSize: const Size(double.infinity, 50),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Text(
          'Logout',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white, // neutral-content
              ),
        ),
      ),
    );
  }
}

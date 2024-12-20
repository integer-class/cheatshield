import 'package:cheatshield/services/web/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheatshield/providers/web/profile_provider.dart';
import 'package:cheatshield/providers/web/auth_provider.dart';
import 'package:go_router/go_router.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<UpdateProfileScreen> createState() =>
      UpdateProfileScreenState();
}

class UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nimController = TextEditingController();

  late ProfileService profileService;

  @override
  void initState() {
    profileService = ref.watch(profileServiceProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: profileService.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final profileData = snapshot.data as Map<String, dynamic>;
            _nameController.text = profileData['name'] ?? '';
            _emailController.text = profileData['email'] ?? '';
            _nimController.text = profileData['nim'] ?? '';
            return _buildBody(context);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 4.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ), // Secondary-content color
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Name cannot be empty' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 4.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ), // Secondary-content color
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Email cannot be empty' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nimController,
              decoration: InputDecoration(
                labelText: 'NIM',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 4.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ), // Secondary-content color
              ),
              validator: (value) =>
                  value!.isEmpty ? 'NIM cannot be empty' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final data = {
                    'name': _nameController.text,
                    'email': _emailController.text,
                    'nim': _nimController.text,
                  };

                  profileService.updateProfile(data).then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated!')),
                    );
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $error')),
                    );
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                minimumSize: const Size(double.infinity, 50),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                'Update Profile',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

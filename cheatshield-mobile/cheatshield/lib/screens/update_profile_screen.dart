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

  @override
  void initState() {
    super.initState();

    // Fetch profile data asynchronously
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileData = await ref.read(profileProvider("").future);

      // Set initial values to the controllers
      _nameController.text = profileData['name'] ?? '';
      _emailController.text = profileData['email'] ?? '';
      _nimController.text = profileData['nim'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FDEF), // bg color
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FDEF), // bg color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/profile'),
        ),
        title: Text(
          'Update Profile',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF010800), // primary-content
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Name cannot be empty' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Email cannot be empty' : null,
              ),
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(labelText: 'NIM'),
                validator: (value) =>
                    value!.isEmpty ? 'NIM cannot be empty' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final token = ref.read(authProvider); // Get the token
                    final data = {
                      'token': token,
                      'name': _nameController.text,
                      'email': _emailController.text,
                      'nim': _nimController.text,
                    };

                    ref.read(profileUpdateProvider(data).future).then((value) {
                      if (token != null) {
                        ref.invalidate(profileProvider(token));
                      }
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
                  backgroundColor: const Color(0xFF343300),
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
                        color: const Color(0xFFD2D3C7),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:food_application/state/app_state.dart';
import 'package:food_application/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().currentUser;
    nameController = TextEditingController(text: user?.name ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    phoneController = TextEditingController(text: user?.phone ?? '');
    bioController = TextEditingController(text: user?.bio ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                CircleIconButton(
                  icon: Icons.arrow_back_ios_new,
                  size: 40,
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                const Text('Edit Profile', style: TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 28),
            const Center(
              child: CircleAvatar(
                radius: 42,
                backgroundColor: Color(0xFFFFC3AA),
                child: Icon(Icons.person, size: 42, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Text('FULL NAME'),
            const SizedBox(height: 6),
            AppField(controller: nameController, hint: 'Your name'),
            const SizedBox(height: 16),
            const Text('EMAIL'),
            const SizedBox(height: 6),
            AppField(controller: emailController, hint: 'email@foodie.com'),
            const SizedBox(height: 16),
            const Text('PHONE NUMBER'),
            const SizedBox(height: 6),
            AppField(
              controller: phoneController,
              hint: '408-841-0926',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            const Text('BIO'),
            const SizedBox(height: 6),
            AppField(controller: bioController, hint: 'I love fast food'),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'SAVE',
              onPressed: () async {
                await context.read<AppState>().updateProfile(
                      name: nameController.text,
                      email: emailController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                    );
                if (!context.mounted) {
                  return;
                }
                showAppSnack(context, 'Profile saved');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

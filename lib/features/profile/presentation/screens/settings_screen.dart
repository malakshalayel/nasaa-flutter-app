import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasaa/config/locale_services.dart';
import 'package:nasaa/config/theme/theme_services.dart';
import 'package:nasaa/core/router/router_name.dart';
import 'package:nasaa/features/home/presentation/widgets/seetings_tile.dart';
import 'package:nasaa/features/login/presentation/cubit/auth_cubit.dart';
import 'package:nasaa/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:nasaa/features/profile/presentation/cubit/profile_state.dart';
import 'package:nasaa/features/profile/presentation/screens/info_user_login.dart';
import 'package:nasaa/generated/l10n.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ Load user data when screen opens
    context.read<ProfileCubit>().loadUser();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeServices>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), centerTitle: true),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ Extract user data from state
          String? name;
          String? profileImage;
          String? email;

          if (state is ProfileLoaded || state is ProfileUpdated) {
            final user = (state is ProfileLoaded)
                ? state.user
                : (state as ProfileUpdated).user;

            name = user.name;
            profileImage = user.profileImage;
            email = user.email;
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            children: [
              _buildProfileCard(name, profileImage, email),

              const SizedBox(height: 30),

              _buildSectionTitle('Appearance'),
              Card(
                child: Column(
                  children: [
                    SettingsTile(
                      icon: theme.isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      title: theme.isDarkMode
                          ? S.of(context).lightMode
                          : S.of(context).darkMode,
                      onTap: () async {
                        await theme.toggleTheme();
                      },
                    ),
                    const Divider(height: 1),
                    SettingsTile(
                      icon: Icons.language,
                      title: S.of(context).language,
                      trailing: DropdownButton<String>(
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: "ar", child: Text("Arabic")),
                          DropdownMenuItem(value: "en", child: Text("English")),
                        ],
                        onChanged: (value) async {
                          if (value != null) {
                            await context.read<LocaleServices>().choiceLanguge(
                              value,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _buildSectionTitle('General'),
              Card(
                child: Column(
                  children: [
                    SettingsTile(
                      icon: Icons.notifications,
                      title: S.of(context).notification,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Coming soon!')),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    SettingsTile(
                      icon: Icons.privacy_tip,
                      title: S.of(context).privacy,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Coming soon!')),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    SettingsTile(
                      icon: Icons.info,
                      title: S.of(context).aboutUs,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              _buildSectionTitle('Account'),
              Card(
                child: SettingsTile(
                  icon: Icons.logout,
                  title: S.of(context).logout,
                  iconColor: Colors.red,
                  onTap: () => _showLogoutDialog(),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(String? name, String? profileImage, String? email) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[200],
              backgroundImage: profileImage != null && profileImage.isNotEmpty
                  ? FileImage(File(profileImage))
                  : null,
              child: profileImage == null || profileImage.isEmpty
                  ? const Icon(Icons.person, size: 40, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? 'Guest User',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email ?? 'No email available',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                // ✅ Navigate to edit profile with BlocProvider.value
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (newContext) => BlocProvider.value(
                      value: context.read<ProfileCubit>(),
                      child: const InfoUserLogin(isEditMode: true),
                    ),
                  ),
                );

                if (mounted) {
                  context.read<ProfileCubit>().loadUser();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).logout),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthCubit>().logout(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouterName.login,
                (route) => false,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(S.of(context).logout),
          ),
        ],
      ),
    );
  }
}

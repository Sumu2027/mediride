import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login_screen.dart';
import 'home_screen.dart';
import 'driver_home_screen.dart';
import 'admin_dashboard.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<String?> _getUserRole() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      return null;
    }

    // Find the user's role in the profiles table.
    final profile = await supabase
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();

    if (profile == null) {
      return null;
    }

    return profile['role'] as String?;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session =
            snapshot.data?.session ??
            Supabase.instance.client.auth.currentSession;

        // No authenticated session: show login.
        if (session == null) {
          return const LoginScreen();
        }

        return FutureBuilder<String?>(
          future: _getUserRole(),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (roleSnapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Unable to load user role.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            await Supabase.instance.client.auth.signOut();

                            if (!context.mounted) return;

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text('Back to Login'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            final role = roleSnapshot.data;

            if (role == 'patient') {
              return const HomeScreen();
            }

            if (role == 'driver') {
              return const DriverHomeScreen();
            }

            if (role == 'admin') {
              return const AdminDashboard();
            }

            // Missing or unapproved role.
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_user_outlined,
                        size: 48,
                        color: Color(0xFF2563EB),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Your account role has not been assigned yet.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'If you applied as a driver, please wait for admin approval.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await Supabase.instance.client.auth.signOut();

                          if (!context.mounted) return;

                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text('Back to Login'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

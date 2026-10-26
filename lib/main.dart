
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/reset_password_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://xdldwtvwoejpvmrwphex.supabase.co',
    // ignore: deprecated_member_use
    anonKey: 'sb_publishable_44NXmDL9quKKxURFJy81vw_ZkLI6AfT',
  );

  runApp(const MediRideApp());
}

class MediRideApp extends StatelessWidget {
  const MediRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediRide',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
        useMaterial3: true,
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/reset-password': (context) =>
            const ResetPasswordScreen(),
      },
    );
  }
}

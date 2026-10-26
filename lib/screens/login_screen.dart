import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_gate.dart';
import 'register_screen.dart';
import 'driver_registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ================= CONTROLLERS =================

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  // ================= STATES =================

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  // ================= DISPOSE =================

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  // ================= EMAIL/PASSWORD LOGIN =================

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (response.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AuthGate()),
          (route) => false,
        );
      }
    } on AuthException catch (e) {
      if (!mounted) return;

      final message = e.message.toLowerCase().contains('invalid login')
          ? 'Invalid email or password.'
          : e.message;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ================= GOOGLE LOGIN =================

  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;

    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: Uri.base.origin,
      );

      // Google OAuth redirects the browser.
      // If the user returns to the app, the existing
      // Supabase session should be handled by AuthGate.
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google login failed: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      setState(() => _isLoading = false);
    }
  }

  // ================= EMAIL VALIDATION =================

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // ================= PASSWORD VALIDATION =================

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  // ================= FORGOT PASSWORD =================

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();

    // Email field check
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address first.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      _emailFocus.requestFocus();
      return;
    }

    // Validate email format
    if (_validateEmail(email) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_isLoading) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        redirectTo: '${Uri.base.origin}/reset-password',
      );

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(
            Icons.mark_email_read_outlined,
            color: Color(0xFF2563EB),
            size: 42,
          ),
          title: const Text('Check your email'),
          content: Text(
            'If an account exists for $email, '
            'you may receive a password reset link. '
            'Please check your inbox and spam folder.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } on AuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not send reset email: ${e.message}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again later.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ================= INPUT DECORATION =================

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 21, color: const Color(0xFF2563EB)),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF5F7FB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
    );
  }

  // ================= SECTION LABEL =================

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13.5,
        fontWeight: FontWeight.w700,
        color: Color(0xFF263238),
      ),
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_background.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // BACKGROUND OVERLAY
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0F3B78).withOpacity(0.25),
                    const Color(0xFF0F3B78).withOpacity(0.88),
                  ],
                ),
              ),
            ),
          ),

          // MAIN CONTENT
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 25,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    children: [
                      // APP LOGO
                      Container(
                        height: 72,
                        width: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.local_hospital_rounded,
                          size: 38,
                          color: Color(0xFF2563EB),
                        ),
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        'MediRide',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        'Emergency Ambulance Service',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),

                      const SizedBox(height: 22),

                      // LOGIN CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.22),
                              blurRadius: 30,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Welcome back',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF173B6B),
                                ),
                              ),

                              const SizedBox(height: 5),

                              const Text(
                                'Sign in to access your MediRide account.',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: Colors.black54,
                                ),
                              ),

                              const SizedBox(height: 23),

                              _fieldLabel('Email address'),

                              const SizedBox(height: 7),

                              TextFormField(
                                controller: _emailController,
                                focusNode: _emailFocus,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.email],
                                validator: _validateEmail,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(_passwordFocus);
                                },
                                decoration: _inputDecoration(
                                  hint: 'you@example.com',
                                  icon: Icons.email_outlined,
                                ),
                              ),

                              const SizedBox(height: 17),

                              _fieldLabel('Password'),

                              const SizedBox(height: 7),

                              TextFormField(
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.done,
                                autofillHints: const [AutofillHints.password],
                                validator: _validatePassword,
                                onFieldSubmitted: (_) => _login(),
                                decoration: _inputDecoration(
                                  hint: 'Enter your password',
                                  icon: Icons.lock_outline_rounded,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: 21,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              // REMEMBER ME + FORGOT PASSWORD
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Checkbox(
                                            value: _rememberMe,
                                            activeColor: const Color(
                                              0xFF2563EB,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _rememberMe = value ?? false;
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text(
                                          'Remember me',
                                          style: TextStyle(
                                            fontSize: 12.5,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _forgotPassword,
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Text(
                                      'Forgot password?',
                                      style: TextStyle(
                                        color: Color(0xFF2563EB),
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // EMAIL LOGIN BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2563EB),
                                    disabledBackgroundColor: const Color(
                                      0xFF93B4F5,
                                    ),
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 22,
                                          width: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Sign in',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // SOCIAL LOGIN DIVIDER
                              Row(
                                children: [
                                  const Expanded(child: Divider()),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      'OR CONTINUE WITH',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: Divider()),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // GOOGLE LOGIN BUTTON WITH LOCAL ASSET
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: OutlinedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : _signInWithGoogle,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF202124),
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(
                                      color: Color(0xFFD7DFEA),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/google_logo.jpg',
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.g_mobiledata,
                                                size: 30,
                                                color: Color(0xFF4285F4),
                                              );
                                            },
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Continue with Google',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // PATIENT REGISTRATION
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const Text(
                                    'New to MediRide?',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const RegisterScreen(),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 4,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Text(
                                      'Create Patient Account',
                                      style: TextStyle(
                                        color: Color(0xFF2563EB),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // DRIVER REGISTRATION
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const Text(
                                    'Are you a driver?',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const DriverRegistrationScreen(),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 4,
                                      ),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Text(
                                      'Apply as Driver',
                                      style: TextStyle(
                                        color: Color(0xFF2563EB),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 17),

                      // SECURITY MESSAGE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            size: 15,
                            color: Colors.white.withOpacity(0.75),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Your information is protected',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 11.5,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'MediRide • Emergency care when you need it',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:evently/ui/register.dart';
import 'package:evently/ui/forget_password.dart';
import 'package:evently/ui/home/home_screen.dart';
import 'package:evently/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/Logo.png',
                        height: 200,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  style: TextStyle(
                      color: isDark
                          ? Theme.of(context).colorScheme.onBackground
                          : Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined,
                        color: isDark
                            ? Theme.of(context).iconTheme.color
                            : Colors.grey),
                    filled: true,
                    fillColor: isDark
                        ? (Theme.of(context).inputDecorationTheme.fillColor ??
                            Theme.of(context).cardColor)
                        : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: isDark
                              ? Theme.of(context).dividerColor
                              : Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: isDark
                              ? Theme.of(context).dividerColor
                              : Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: isDark
                              ? Theme.of(context).colorScheme.primary
                              : Color(0xFF5669FF),
                          width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                if (_emailError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Text(
                      _emailError!,
                      style: TextStyle(
                          color: isDark
                              ? Theme.of(context).colorScheme.error
                              : Colors.red,
                          fontSize: 13),
                    ),
                  ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  style: TextStyle(
                      color: isDark
                          ? Theme.of(context).colorScheme.onBackground
                          : Colors.black),
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline,
                        color: isDark
                            ? Theme.of(context).iconTheme.color
                            : Colors.grey),
                    filled: true,
                    fillColor: isDark
                        ? (Theme.of(context).inputDecorationTheme.fillColor ??
                            Theme.of(context).cardColor)
                        : Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: isDark
                              ? Theme.of(context).dividerColor
                              : Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: isDark
                              ? Theme.of(context).dividerColor
                              : Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          color: isDark
                              ? Theme.of(context).colorScheme.primary
                              : Color(0xFF5669FF),
                          width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: isDark
                              ? Theme.of(context).iconTheme.color
                              : Colors.grey),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                if (_passwordError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Text(
                      _passwordError!,
                      style: TextStyle(
                          color: isDark
                              ? Theme.of(context).colorScheme.error
                              : Colors.red,
                          fontSize: 13),
                    ),
                  ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgetPasswordScreen()),
                      );
                    },
                    child: Text(
                      'Forget Password?',
                      style: TextStyle(
                        color: isDark
                            ? Theme.of(context).colorScheme.primary
                            : Color(0xFF5669FF),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        decorationColor: isDark
                            ? Theme.of(context).colorScheme.primary
                            : Color(0xFF5669FF),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? Theme.of(context).colorScheme.primary
                          : Color(0xFF5B7FFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Login',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't Have Account ? ",
                        style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? Theme.of(context).colorScheme.onBackground
                                : Colors.black)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: isDark
                              ? Theme.of(context).colorScheme.primary
                              : Color(0xFF5669FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                          decorationColor: isDark
                              ? Theme.of(context).colorScheme.primary
                              : Color(0xFF5669FF),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                            thickness: 1,
                            color: isDark
                                ? Theme.of(context).colorScheme.primary
                                : Color(0xFF5669FF))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Or',
                          style: TextStyle(
                              color: isDark
                                  ? Theme.of(context).colorScheme.primary
                                  : Color(0xFF5669FF))),
                    ),
                    Expanded(
                        child: Divider(
                            thickness: 1,
                            color: isDark
                                ? Theme.of(context).colorScheme.primary
                                : Color(0xFF5669FF))),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: _signInWithGoogle,
                    icon: Image.asset(
                      'assets/images/googlee.png',
                      height: 24,
                    ),
                    label: const Text(
                      'Login With Google',
                      style: TextStyle(
                        color: Color(0xFF5B7FFF),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: isDark
                              ? Theme.of(context).colorScheme.primary
                              : Color(0xFF5B7FFF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor:
                          isDark ? Theme.of(context).cardColor : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Replace with flag images if available
                    CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          isDark ? Theme.of(context).cardColor : Colors.white,
                      child: Text('🇺🇸', style: TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          isDark ? Theme.of(context).cardColor : Colors.white,
                      child: Text('🇪🇬', style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    setState(() {
      _emailError = null;
      _passwordError = null;
    });
    if (email.isEmpty) {
      setState(() => _emailError = 'Please enter your email.');
      return;
    } else if (!email.contains('@')) {
      setState(() => _emailError = 'Please enter a valid email address.');
      return;
    }
    if (password.isEmpty) {
      setState(() => _passwordError = 'Please enter your password.');
      return;
    } else if (password.length < 6) {
      setState(
          () => _passwordError = 'Password must be at least 6 characters.');
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Navigate to HomeScreen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() => _emailError = 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        setState(() => _passwordError = 'Invalid password');
      } else {
        // Suppress the default Firebase 'auth credential' message
        if (e.message != null &&
            e.message!.toLowerCase().contains('auth credential')) {
          setState(() => _emailError = 'Login failed.');
        } else {
          setState(() => _emailError = e.message ?? 'Login failed.');
        }
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      // Navigate to HomeScreen after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _emailError = e.message ?? 'Google sign-in failed.';
      });
      print('Google sign-in error: ${e.code} ${e.message}');
    } catch (e) {
      setState(() {
        _emailError = 'Google sign-in failed.';
      });
      print('Google sign-in error: ${e.toString()}');
    }
  }
}

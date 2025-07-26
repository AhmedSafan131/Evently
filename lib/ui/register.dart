import 'package:evently/ui/home/home_screen.dart';
import 'package:evently/ui/login.dart';
import 'package:evently/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  void _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });
    if (name.isEmpty) {
      setState(() => _nameError = 'Please enter your name.');
      return;
    }
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
    if (confirmPassword.isEmpty) {
      setState(() => _confirmPasswordError = 'Please confirm your password.');
      return;
    } else if (confirmPassword != password) {
      setState(() => _confirmPasswordError = 'Passwords do not match.');
      return;
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Set the display name
      await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
      // Navigate to HomeScreen after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() => _emailError = 'Email is already in use.');
      } else if (e.code == 'invalid-email') {
        setState(() => _emailError = 'Invalid email address.');
      } else if (e.code == 'weak-password') {
        setState(() => _passwordError = 'Password is too weak.');
      } else {
        setState(() => _emailError = e.message ?? 'Registration failed.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? Theme.of(context).colorScheme.onBackground
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      Image.asset(
                        'assets/images/Logo.png',
                        height: 200,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _nameController,
                        style: TextStyle(
                            color: isDark
                                ? Theme.of(context).colorScheme.onBackground
                                : Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Name',
                          prefixIcon: Icon(Icons.person_outline,
                              color: isDark
                                  ? Theme.of(context).iconTheme.color
                                  : Colors.grey),
                          filled: true,
                          fillColor: isDark
                              ? (Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor ??
                                  Theme.of(context).cardColor)
                              : Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 18),
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
                      ),
                      if (_nameError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Text(
                            _nameError!,
                            style: TextStyle(
                                color: isDark
                                    ? Theme.of(context).colorScheme.error
                                    : Colors.red,
                                fontSize: 13),
                          ),
                        ),
                      const SizedBox(height: 16),
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
                              ? (Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor ??
                                  Theme.of(context).cardColor)
                              : Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 18),
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
                              ? (Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor ??
                                  Theme.of(context).cardColor)
                              : Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 18),
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
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmPasswordController,
                        style: TextStyle(
                            color: isDark
                                ? Theme.of(context).colorScheme.onBackground
                                : Colors.black),
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock_outline,
                              color: isDark
                                  ? Theme.of(context).iconTheme.color
                                  : Colors.grey),
                          filled: true,
                          fillColor: isDark
                              ? (Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor ??
                                  Theme.of(context).cardColor)
                              : Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 18),
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
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: isDark
                                    ? Theme.of(context).iconTheme.color
                                    : Colors.grey),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                      ),
                      if (_confirmPasswordError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Text(
                            _confirmPasswordError!,
                            style: TextStyle(
                                color: isDark
                                    ? Theme.of(context).colorScheme.error
                                    : Colors.red,
                                fontSize: 13),
                          ),
                        ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? Theme.of(context).colorScheme.primary
                                : Color(0xFF5B7FFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Create Account',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? ",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: isDark
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                      : Colors.black)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Color(0xFF5669FF),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF5669FF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

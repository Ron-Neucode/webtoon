import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLogin = true;
  bool _obscurePassword = true;

  Future<Map<String, dynamic>> _getAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('accounts') ?? '{}';
    return jsonDecode(data);
  }

  Future<void> _saveAccounts(Map<String, dynamic> accounts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accounts', jsonEncode(accounts));
  }

  Future<void> _toggleForm() async {
    setState(() {
      isLogin = !isLogin;
    });
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final email = emailController.text.trim();

    final accounts = await _getAccounts();

    if (isLogin) {
      // LOGIN
      if (!accounts.containsKey(username) ||
          accounts[username]['password'] != password) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password.')),
        );
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loggedInUser', username);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      // REGISTER
      if (accounts.containsKey(username)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username already exists.')),
        );
        return;
      }
      accounts[username] = {'email': email, 'password': password};
      await _saveAccounts(accounts);

      // Auto-login after registration
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loggedInUser', username);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.web_stories, size: 80, color: Colors.purple),
                const SizedBox(height: 32),
                Text(
                  isLogin ? 'Welcome Back' : 'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  isLogin ? 'Login to your account' : 'Sign up to get started',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 3) {
                            return 'Username must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      if (!isLogin)
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email required';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value.trim())) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                        ),
                      if (!isLogin) const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(isLogin ? 'Login' : 'Register'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _toggleForm,
                  child: Text(
                    isLogin
                        ? "Don't have an account? Register"
                        : 'Have an account? Login',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

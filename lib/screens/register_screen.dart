import 'package:flutter/material.dart';
import '../services/parse_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _register() async {
    setState(() => _loading = true);
    try {
  final response = await ParseService.signUp(
      _emailController.text.trim(), _passwordController.text.trim());
  if (response.success) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Account created!')));
    Navigator.pop(context);
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response.error?.message ?? 'Error')));
  }
}  catch (e) {
  print("Registration failed: $e");
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Student Email')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _register, child: const Text('Register')),
          ],
        ),
      ),
    );
  }
}

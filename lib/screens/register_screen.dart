// lib/screens/register_screen.dart
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: RegisterFormContent(),
      ),
    );
  }
}

class RegisterFormContent extends StatefulWidget {
  const RegisterFormContent({Key? key}) : super(key: key);

  @override
  State<RegisterFormContent> createState() => _RegisterFormContentState();
}

class _RegisterFormContentState extends State<RegisterFormContent> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Password'),
        ),
        const SizedBox(height: 20),
        _loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
          onPressed: () async {
            setState(() => _loading = true);
            await Future.delayed(const Duration(seconds: 1));
            setState(() => _loading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registered!')),
            );
          },
          child: const Text('Register'),
        ),
      ],
    );
  }
}

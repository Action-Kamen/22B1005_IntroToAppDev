import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart'; // Import the HomeScreen widget

class LoginPage extends StatelessWidget {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                    title: Text('Login'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
        ),
        SizedBox(height: 12),
        TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        ),
        SizedBox(height: 24),
        ElevatedButton(
            onPressed: () async {
            String email = _emailController.text.trim();
            String password = _passwordController.text.trim();
            if (email.isNotEmpty && password.isNotEmpty) {
                try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email,
                    password: password,
                    );
                    // Navigate to HomeScreen after successful login
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                } catch (e) {
                    // Handle login errors (e.g., invalid credentials)
                    print('Login Error: $e');
                }
            }
        },
        child: Text('Login'),
        ),
        ],
        ),
        ),
        );
    }
}

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(BudgetTrackerApp());
}

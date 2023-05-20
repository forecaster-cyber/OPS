import 'main.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthManager authManager;
  LoginPage(this.authManager);

  @override
  Widget build(BuildContext context) {
    emailController.text = emailll??"";
    passwordController.text = passowrdd??"";
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;
                authManager.signIn(email, password).then((_) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MainScreen()));
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sign in failed: $error')),
                  );
                });
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setString('email', email);
                await prefs.setString('password', password);
              },
              child: Text('Sign In'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;
                authManager.signUp(email, password).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sign up successful')),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sign up failed: $error')),
                  );
                });
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setString('email', email);
                await prefs.setString('password', password);
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

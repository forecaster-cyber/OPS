import 'package:zushi_and_karrot/upload.dart';

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
    emailController.text = emailll ?? "";
    passwordController.text = passowrdd ?? "";
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Sign In',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 800,
                ),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 800,
                ),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor))),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
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
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white),
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
      ),
    );
  }
}

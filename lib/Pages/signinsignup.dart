import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zushi_and_karrot/utils/app_lifecycle_reactor.dart';
import 'package:zushi_and_karrot/utils/app_open_ad_manager.dart';

import '../main.dart';
import 'package:flutter/material.dart';
import '../utils/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final AuthManager authManager;
  const LoginPage(this.authManager, {super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    super.initState();
    appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.width / 1.2,
                color: Colors.transparent,
                child: SvgPicture.asset("assets/328.svg"),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor))),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0),
                            onPressed: () async {
                              final email = emailController.text;
                              final password = passwordController.text;
                              widget.authManager
                                  .signIn(email, password)
                                  .then((_) {
                                getLikedIds().then(
                                  (value) {
                                    getRowsForIds(value);
                                  },
                                );
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainScreen()));
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Sign in failed: $error')),
                                );
                              });
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString('email', email);
                              await prefs.setString('password', password);
                              emailll = email;
                            },
                            child: const Text('Sign In'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                foregroundColor: Colors.black),
                            onPressed: () async {
                              final email = emailController.text;
                              final password = passwordController.text;
                              widget.authManager
                                  .signUp(email, password)
                                  .then((_) async {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Sign up successful')),
                                );
                                await supabase.from("users").insert([
                                  {"user": email, "liked_posts": []}
                                ]);
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainScreen()));
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Sign up failed: $error')),
                                );
                              });
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString('email', email);
                              await prefs.setString('password', password);
                            },
                            child: const Text('Sign Up'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<List> getLikedIds() async {
  liked_ids = await supabase
      .from('users')
      .select("liked_posts")
      .match(({"user": emailll}));

  liked_ids = liked_ids[0]["liked_posts"];
  return liked_ids;
}

Future<int> getLikeCount(dynamic object) async {
  dynamic likes = await supabase
      .from('recipesJsons')
      .select("like_count")
      .eq("JSON", jsonEncode(object));
  print(likes[0]['like_count']);
  return likes[0]['like_count'];
}

Future<List> getRowsForIds(List ids) async {
  // Initialize Supabase client
  likedObjects = [];
  // Create a SELECT query with a WHERE clause to filter by IDs
  final response = await supabase
      .from('recipesJsons') // Replace with your table name
      .select("JSON")
      .in_('id', ids);

  for (var element in response) {
    Map<String, dynamic> decJson = jsonDecode(element["JSON"]);
    likedObjects.add(decJson);
  }
  return likedObjects;
}

void removeIdFromLikes(dynamic object) async {
  await supabase
      .from("recipesJsons")
      .select("id")
      .match({"JSON": jsonEncode(object)}).then((value) async {
    liked_ids.remove(value[0]["id"]);
    await supabase
        .from("users")
        .update({"liked_posts": liked_ids}).eq("user", emailll);

    likedObjects.remove(object);
  });
}

void addIdToLikes(dynamic object) async {
  dynamic id = await supabase
      .from("recipesJsons")
      .select("id")
      .eq("JSON", jsonEncode(object));
  liked_ids.add(id[0]["id"]);
  await supabase
      .from("users")
      .update({"liked_posts": liked_ids}).eq("user", emailll);
  likedObjects.add(object);
}

import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:zushi_and_karrot/auth.dart';
import 'package:zushi_and_karrot/profile.dart';
import 'dart:convert';
import 'recipe.dart';
import 'upload.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'signinsignup.dart';
import 'package:shared_preferences/shared_preferences.dart';

List myPostsList = [];
/*

var obj = {
  "image_url":
      "",
  "recipe_name": "",
  "ingredients": "",
  "steps": [
    
  ],
  "created_by": ""
};
*/
const supabaseUrl = 'https://jkrqnlckxphqtgzbgffs.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImprcnFubGNreHBocXRnemJnZmZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODQ0ODUyNDgsImV4cCI6MjAwMDA2MTI0OH0.2bkQ5zuEPKqhOl9aeSoNjgilokE1aKtq_Zk1mYOubfo';

var obj = {
  "image_url":
      "https://upload.wikimedia.org/wikipedia/commons/1/17/2014_0531_Cr%C3%A8me_br%C3%BBl%C3%A9e_Doi_Mae_Salong_%28cropped%29.jpg",
  "recipe_name": "Creme Brule",
  "ingredients": "I, dont, know",
  "steps": [
    "sgdfghdfgh",
    "dfnkgndfkghnkfghnklksdfgslkdgjkdjgfkdfgjkdfg",
    "kill the evil brocolis that are in your kitchen, kill them with data and graphs, big data! dfgfhdghfgdhjdfghdgfhdfghfdghdfgh"
  ],
  "created_by": "Yuval Noyman"
};

List objectsList = [];
final supabase = Supabase.instance.client;
final AuthManager authManager = AuthManager();
var aJson = jsonEncode(obj);
String? emailll = '';
String? passowrdd = '';
int _currentIndex = 0;
bool wantToUpload = false;
Map<String, dynamic> valuess = jsonDecode(aJson);
bool ProfilePage = false;

Future<void> main() async {
  //objectsList.add(valuess);
  //objectsList.add(valuess);
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final String? saved_email = prefs.getString('email');
  final String? saved_password = prefs.getString('password');
  emailll = saved_email;
  passowrdd = saved_password;
  final List listOfJsons =
      await supabase.from("recipesJsons").select<PostgrestList>("JSON");
  for (var element in listOfJsons) {
    // print(element["JSON"]);

    Map<String, dynamic> decJson = jsonDecode(element["JSON"]);
    // print(decJson);

    objectsList.add(decJson);
  }
  for (var amo in objectsList) {
    print(amo);
  }
  runApp(MainApp());
  // print(valuess["recipe_name"]);
  // print(json);
  // print(valuess["steps"][0]);
}

class MainApp extends StatefulWidget {
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          // primary: Color(0xFFe63946),
          primary: Color(0xFF415d59),
          // secondary: Color(0xFFe63946),
          secondary: Color(0xFFe7eeed),
          // background: Color(0xFFfbf5f3),
          background: Color(0xFFf6f9f8),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF415d59)),
          ),
        ),
        useMaterial3: true,
        // primaryColor: Color(0xFFe63946),
        primaryColor: Color(0xFF415d59),
      ),
      home: LoginPage(authManager),
      routes: {
        '/newRecipe': (context) => NewRecipe(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<void> refresh() async {
    final List listOfJsons =
        await supabase.from("recipesJsons").select<PostgrestList>("JSON");
    setState(() {
      objectsList = [];
    });
    for (var element in listOfJsons) {
      // print(element["JSON"]);

      Map<String, dynamic> decJson = jsonDecode(element["JSON"]);
      // print(decJson);
      setState(() {
        objectsList.add(decJson);
      });
    }
    for (var amo in objectsList) {
      print(amo);
    }
  }

  @override
  Widget build(BuildContext context) {
    List widgets = [recipesPage(voidCallback: refresh), profilePage()];
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          indicatorColor: Color(0xFF415d59),
          selectedIndex: _currentIndex,
          onDestinationSelected: (value) {
            setState(() {
              if (value == 0) {
                ProfilePage = false;
              } else if (value == 1) {
                ProfilePage = true;
              }

              _currentIndex = value;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: "Home",
              selectedIcon: Icon(Icons.home),
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: "Profile",
              selectedIcon: Icon(Icons.person),
            )
          ],
        ),
        // backgroundColor: Color(0xFFf1faee),
        // backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          scrolledUnderElevation: 0.0,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          title: kIsWeb
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('zushi&karrot'),
                    IconButton(
                      onPressed: refresh,
                      icon: Icon(Icons.refresh),
                    )
                  ],
                )
              : Text('zushi&karrot'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/newRecipe');
          },
          child: Icon(
            Icons.add_rounded,
            size: 38,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: widgets[_currentIndex]);
  }
}

class recipesPage extends StatefulWidget {
  const recipesPage({super.key, required this.voidCallback});
  final Future<void> Function() voidCallback;
  @override
  State<recipesPage> createState() => _recipesPageState();
}

class _recipesPageState extends State<recipesPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: RefreshIndicator(
          child: ListView.builder(
            itemCount: objectsList.length,
            itemBuilder: (context, index) {
              return RecipeWidget(
                values: objectsList[index],
              );
            },
          ),
          onRefresh: widget.voidCallback,
        ),
      ),
    );
  }
}

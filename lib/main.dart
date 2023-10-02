import 'dart:core';
//import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:zushi_and_karrot/auth.dart';
import 'package:zushi_and_karrot/profile.dart';
import 'package:zushi_and_karrot/recipe_page.dart';
import 'dart:convert';
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
TextEditingController searchController = TextEditingController();
Future<void> main() async {
  //objectsList.add(valuess);
  //objectsList.add(valuess);
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final String? savedEmail = prefs.getString('email');
  final String? savedPassword = prefs.getString('password');
  emailll = savedEmail;
  passowrdd = savedPassword;
  final List listOfJsons =
      await supabase.from("recipesJsons").select<PostgrestList>("JSON");
  for (var element in listOfJsons) {
    // print(element["JSON"]);

    Map<String, dynamic> decJson = jsonDecode(element["JSON"]);
    // print(decJson);

    objectsList.add(decJson);
  }
  final List listOfMyPostsJsons = await supabase
      .from("recipesJsons")
      .select<PostgrestList>("JSON")
      .textSearch(
          "created_by", extractUsername(emailll ??= "example@gmail.com"));
  for (var element in listOfMyPostsJsons) {
    // print(element["JSON"]);

    Map<String, dynamic> decJson = jsonDecode(element["JSON"]);
    // print(decJson);

    myPostsList.add(decJson);
  }
  runApp(const MainApp());
  // print(valuess["recipe_name"]);
  // print(json);
  // print(valuess["steps"][0]);
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Varela',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          // primary: Color(0xFFe63946),
          primary: const Color(0xFF415d59),
          // secondary: Color(0xFFe63946),
          secondary: const Color(0xFFe7eeed),
          // background: Color(0xFFfbf5f3),
          background: const Color(0xFFf6f9f8),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF415d59)),
          ),
        ),
        useMaterial3: true,
        // primaryColor: Color(0xFFe63946),
        primaryColor: const Color(0xFF415d59),
      ),
      home: LoginPage(authManager),
      routes: {
        '/newRecipe': (context) => NewRecipe(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

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
  }

  @override
  Widget build(BuildContext context) {
    List widgets = [RecipesPage(voidCallback: refresh), const ProfilePage()];
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.shade100,
        bottomNavigationBar: NavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          indicatorColor: const Color(0xFF415d59),
          selectedIndex: _currentIndex,
          onDestinationSelected: (value) {
            setState(() {
              // if (value == 0) {
              //   ProfilePage = false;
              // } else if (value == 1) {

              // }
              // else if (value == 2) {
              //   ProfilePage = true;
              // }

              _currentIndex = value;
            });
          },
          destinations: const [
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

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/newRecipe');
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add_rounded,
            size: 38,
          ),
        ),
        body: widgets[_currentIndex]);
  }
}

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key, required this.voidCallback});
  final Future<void> Function() voidCallback;
  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  var finalobjectslist = objectsList.reversed;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Good morning,",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    "what would you like \nto cook today?",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              CircleAvatar(
                backgroundImage:
                    NetworkImage(generateGravatarImageUrl(emailll!, 80)),
                radius: 25,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: TextField(
            onSubmitted: (value) async {
              objectsList = [];
              final List listOfsearchedJsons = await supabase
                  .from("recipesJsons")
                  .select<PostgrestList>("JSON")
                  .textSearch("created_by", searchController.text,
                      type: TextSearchType.websearch);
              for (var element in listOfsearchedJsons) {
                // print(element["JSON"]);

                Map<String, dynamic> decJson = jsonDecode(element["JSON"]);
                // print(decJson);

                objectsList.add(decJson);
              }
              setState(() {
                objectsList = objectsList;
              });
            },
            decoration: InputDecoration(
              hintText: "search any recipes",
              hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
              prefixIcon: const Icon(Icons.search),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              filled: true,
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    width: 3, color: Colors.transparent), //<-- SEE HERE
                borderRadius: BorderRadius.circular(50.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    width: 3, color: Colors.transparent), //<-- SEE HERE
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "categories",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: 75,
                  child: ListView.builder(
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          width: 75,
                          height: 75,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "🍕",
                                style: TextStyle(fontSize: 28),
                              ),
                              Text(
                                "pizza",
                                style: TextStyle(color: Colors.black54),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                // Wrap the "Recommended" column with Expanded
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Recommended",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: objectsList.length,
                      /*
                        var recipe_name = widget.values["recipe_name"];
                        var image_url = widget.values["image_url"];
                        var created_by = widget.values["created_by"];
                        var ingerdiants = widget.values["ingredients"];
                        var avatar_url = widget.values["avatar_url"];
                      */
                      itemBuilder: (context, index) {
                        if (index != 1) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RecipePage(
                                            index: index,
                                            // checking if needing to view a user created post, or another user post, because its 2 different lists, can be confused with the index
                                            currentUserCreated: false,
                                          )),
                                );
                              },
                              child: SizedBox(
                                width: 150,
                                height: 150,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      objectsList[index]["image_url"],
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ]),
    ));
  }
}

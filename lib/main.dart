import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zushi_and_karrot/utils/auth.dart';
import 'pages/profile.dart';
import 'dart:convert';
import 'Pages/upload.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Pages/signinsignup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart';
import 'utils/app_lifecycle_reactor.dart';
import 'utils/app_open_ad_manager.dart';

late AppOpenAdManager appOpenAdManager;
bool isLoading = false;
List likedObjects = [];
List names = [
  'breakfast',
  'dinner',
  'lunch',
  'breads',
  'italian',
  'mexaican',
  'side dish',
  'healthy'
];
String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Morning';
  }
  if (hour < 17) {
    return 'Afternoon';
  }
  return 'Evening';
}

List icons = ['🥞', '🍝', '🥙', '🍞', '🍕', '🌮', '🍟', '🥗'];
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
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
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
late List liked_ids;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
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
    Map<String, dynamic> decJson = jsonDecode(element["JSON"]);
    objectsList.add(decJson);
  }
  final List listOfMyPostsJsons = await supabase
      .from("recipesJsons")
      .select<PostgrestList>("JSON")
      .textSearch(
          "created_by", extractUsername(emailll ??= "example@gmail.com"));
  for (var element in listOfMyPostsJsons) {
    Map<String, dynamic> decJson = jsonDecode(element["JSON"]);
    myPostsList.add(decJson);
  }
  emailController.text = emailll ?? "";
  passwordController.text = passowrdd ?? "";
  runApp(const MainApp());
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
        // fontFamily: 'Varela',
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF222222),
            //222222
            secondary: const Color(0xFFe7eeed),
            background: const Color(0xFFf6f9f8),
            brightness: Brightness.dark),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF222222)),
          ),
        ),
        useMaterial3: true,
        primaryColor: const Color(0xFF222222),
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
      Map<String, dynamic> decJson = jsonDecode(element["JSON"]);
      setState(() {
        objectsList.add(decJson);
      });
    }
  }


  @override
  void initState() {
    appOpenAdManager.showAdIfAvailable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List widgets = [HomePage(voidCallback: refresh), const ProfilePage()];
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        bottomNavigationBar: NavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          indicatorColor: const Color(0xFF222222),
          selectedIndex: _currentIndex,
          onDestinationSelected: (value) {
            setState(() {
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/newRecipe').then((value) {
              setState(() {});
            });
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

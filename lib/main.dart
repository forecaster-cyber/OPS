import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'dart:convert';
import 'recipe.dart';
import 'upload.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

var aJson = jsonEncode(obj);

bool wantToUpload = false;
Map<String, dynamic> valuess = jsonDecode(aJson);

Future<void> main() async {

  objectsList.add(valuess);
  objectsList.add(valuess);
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );
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

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFFe63946),
          secondary: Color(0xFFe63946),
          background: Color(0xFFf1faee),
        ),
        primaryColor: Color(0xFFe63946),
      ),
      home: MainScreen(),
      routes: {
        '/newRecipe': (context) => NewRecipe(),
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf1faee),
      appBar: AppBar(
        title: Text('zushi&karrot'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/newRecipe');
        },
        child: Icon(
          Icons.add_rounded,
          size: 38,
        ),
      ),
      body: SafeArea(
        child: Center(
            child: new ListView.builder(
          itemCount: objectsList.length,
          itemBuilder: (context, index) {
            return RecipeWidget(
              values: objectsList[index],
            );
          },
        )),
      ),
    );
  }
}

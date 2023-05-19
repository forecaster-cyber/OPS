import 'package:flutter/material.dart';
import 'dart:convert';
import 'recipe.dart';
import 'upload.dart';

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

var json = jsonEncode(obj);
bool wantToUpload = false;
Map<String, dynamic> valuess = jsonDecode(json);
void main() {
  runApp(MainApp());
  print(valuess["recipe_name"]);
  print(json);
  print(valuess["steps"][0]);
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    void navigateToUpload() {
      setState(() {
        wantToUpload = true;
      });
    }

    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: wantToUpload ? NewRecipe() : Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: navigateToUpload),
        body: SafeArea(
          child: Center(
            child: ListView(
              children: [
                RecipeWidget(values: valuess, index: 1),
                RecipeWidget(values: valuess, index: 1)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart';


File? imageFile;
List<TextFieldModel> textFields = [];
List<String> steps = [];

class NewRecipe extends StatefulWidget {
  @override
  _NewRecipeState createState() => _NewRecipeState();
}

TextEditingController ingriedientsController = TextEditingController();

class _NewRecipeState extends State<NewRecipe> {
  @override
  void initState() {
    super.initState();
    // Add the initial text field
    textFields.add(TextFieldModel(controller: TextEditingController()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFFe63946),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFf1faee),
        appBar: AppBar(
          title: Text('share a recipe'),
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _getFromGallery();
                  });
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: imageFile != null
                        ? Colors.transparent
                        : Color(0xFFe63946),
                  ),
                  child: imageFile != null
                      ? Image.file(imageFile!)
                      : Center(
                          child: Icon(
                            Icons.add_a_photo,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 26),
              TextField(
                controller: ingriedientsController,
                decoration: InputDecoration(label: Text('ingridients: ')),
              ),
              SizedBox(height: 34),
              Text('steps:'),
              for (int i = 0; i < textFields.length; i++) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textFields[i].controller,
                        decoration: InputDecoration(
                          labelText: 'step ${i + 1}',
                        ),
                      ),
                    ),
                    if (i == textFields.length - 1)
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Color(0xFFe63946),
                        ),
                        onPressed: () {
                          setState(() {
                            // Create a new instance of TextEditingController for the new text field
                            TextEditingController newController =
                                TextEditingController();
                            textFields
                                .add(TextFieldModel(controller: newController));
                          });
                        },
                      ),
                  ],
                ),
                SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                      ),
                      onPressed: () {
                        getStepsOnSubmit();
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}

void getStepsOnSubmit() {
  for (int i = 0; i < textFields.length; i++) {
    print(textFields[i].controller.text);
    steps.add(textFields[i].controller.text);
  }
}

class TextFieldModel {
  final TextEditingController controller;

  TextFieldModel({required this.controller});
}

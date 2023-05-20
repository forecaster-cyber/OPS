import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'package:supabase/supabase.dart';
import 'package:crypto/crypto.dart';
import 'package:universal_io/io.dart';

File? imageFile;
List<TextFieldModel> textFields = [];
List<String> steps = [];
String? avatarararara = '';

class NewRecipe extends StatefulWidget {
  @override
  _NewRecipeState createState() => _NewRecipeState();
}

String generateGravatarImageUrl(String email, int size) {
  final hash = md5.convert(utf8.encode(email.trim().toLowerCase()));
  final url = 'https://www.gravatar.com/avatar/$hash?s=$size';
  print(url);
  print(url);
  print(url);
  print(url);
  print(url);
  return url;
}

String extractUsername(String email) {
  // Find the index of the "@" symbol
  final atIndex = email.indexOf('@');

  // Extract the substring before the "@" symbol
  final username = email.substring(0, atIndex);

  return username;
}

TextEditingController ingriedientsController = TextEditingController();
TextEditingController titleController = TextEditingController();

class _NewRecipeState extends State<NewRecipe> {
  @override
  void initState() {
    super.initState();
    // Add the initial text field
    textFields.add(TextFieldModel(controller: TextEditingController()));
  }

  @override
  Widget build(BuildContext context) {
    print("object");
    print("object");
    print("object");
    print("object");
    print(generateGravatarImageUrl("forecaster1310@gmail.com", 80));
    return Scaffold(
      backgroundColor: Color(0xFFf1faee),
      appBar: AppBar(
        title: Text('Share a Recipe'),
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
                      : Color(0xFF415d59),
                ),
                child: imageFile != null
                    ? kIsWeb
                        ? Image.network(imageFile!.path)
                        : Image.file(imageFile!)
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
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title:'),
            ),
            SizedBox(height: 34),
            TextField(
              controller: ingriedientsController,
              decoration: InputDecoration(labelText: 'Ingredients:'),
            ),
            SizedBox(height: 34),
            Text('Steps:'),
            for (int i = 0; i < textFields.length; i++) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textFields[i].controller,
                      decoration: InputDecoration(
                        labelText: 'Step ${i + 1}',
                      ),
                    ),
                  ),
                  if (i == textFields.length - 1)
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Color(0xFF415d59),
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
    );
  }

  // Get image from gallery
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

  void getStepsOnSubmit() async {
    for (int i = 0; i < textFields.length; i++) {
      print(textFields[i].controller.text);
      steps.add(textFields[i].controller.text);
    }

    textFields = [];
    textFields.add(TextFieldModel(controller: TextEditingController()));
    final List<FileObject> listOfPhotos =
        await supabase.storage.from("Photos").list();


    if (kIsWeb) {
      var avatarFile = File(imageFile!.path);
      final avatarfileBytes = await avatarFile.readAsBytes();
      await supabase.storage.from('Photos').uploadBinary(
          listOfPhotos.length.toString(), avatarfileBytes,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false));
    } else {
      var avatarFile = File(imageFile!.path);
      final String path = await supabase.storage.from('Photos').upload(
            listOfPhotos.length.toString(),
            avatarFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
    }
    //print("First path: $path");
    final String publicUrl = supabase.storage
        .from('Photos')
        .getPublicUrl("${listOfPhotos.length.toString()}");
    print("Second path: $publicUrl");
    final List<FileObject> new_listOfFiles =
        await supabase.storage.from("Photos").list();
    final int listLength = new_listOfFiles.length - 1;
    final avatarrrr = generateGravatarImageUrl(emailll!, 80);
    var newObj = {
      'image_url': publicUrl,
      'recipe_name': titleController.text,
      'ingredients': ingriedientsController.text,
      'steps': steps,
      'created_by': extractUsername(emailll!),
      'avatar_url': generateGravatarImageUrl(emailll!, 80)
    };
    print(generateGravatarImageUrl(emailll!, 80));
    print(avatarararara);
    print(emailll!);
    print(avatarrrr);
    var newJson = jsonEncode(newObj);

    await supabase.from("recipesJsons").insert([
      {"id": listLength, "JSON": newJson, "created_by": extractUsername(emailll!)}
    ]);
    

    Navigator.pop(context);
    setState(() {
      objectsList.add(newObj);
    });
  }
}

class TextFieldModel {
  final TextEditingController controller;

  TextFieldModel({required this.controller});
}

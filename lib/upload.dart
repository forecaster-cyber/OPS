import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart';
import 'package:supabase/supabase.dart';
import 'package:crypto/crypto.dart';
import 'package:universal_io/io.dart';
import 'package:http/http.dart' as http;

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
TextEditingController durationController = TextEditingController();
bool lodaing = false;

class _NewRecipeState extends State<NewRecipe> {
  @override
  void initState() {
    super.initState();
    // Add the initial text field
    textFields.add(TextFieldModel(controller: TextEditingController()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFf1faee),
      appBar: AppBar(
        title: Text('Share a Recipe'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: lodaing
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
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
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: titleController,
                          decoration: InputDecoration(labelText: 'Title:'),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: durationController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'mintues'),
                        ),
                      ),
                    ],
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
                                textFields.add(
                                    TextFieldModel(controller: newController));
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
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            getStepsOnSubmit();
                            setState(() {
                              lodaing = true;
                            });
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
    Future<List<double>> fetchOpenAIEmbeddings(String inputParam) async {
      final String apiKey =
          "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";
      final String apiUrl = "https://api.openai.com/v1/embeddings";

      final Map<String, dynamic> requestBody = {
        "input": inputParam,
        "model": "text-embedding-ada-002"
      };

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      };

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: headers,
          body: json.encode(requestBody),
        );

        if (response.statusCode == 200) {
          var jsonBody = json.decode(response.body);
          if (jsonBody['data'] is List && jsonBody['data'].isNotEmpty) {
            var embedding = jsonBody['data'][0]['embedding'];
            if (embedding is List) {
              return embedding.cast<double>();
            }
          }
          throw Exception("Invalid data format in the response.");
        } else {
          throw Exception("Failed to fetch data");
        }
      } catch (e) {
        throw Exception("Error: $e");
      }
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
      'avatar_url': generateGravatarImageUrl(emailll!, 80),
      'duration': durationController.text
    };
    print(generateGravatarImageUrl(emailll!, 80));
    print(avatarararara);
    print(emailll!);
    print(avatarrrr);
    var newJson = jsonEncode(newObj);

    await supabase.from("recipesJsons").insert([
      {
        "id": listLength,
        "JSON": newJson,
        "created_by": extractUsername(emailll!),
        "embeddings": await fetchOpenAIEmbeddings(titleController.text)
      }
    ]).then((value) {
      setState(() {
        objectsList.add(newObj);
        lodaing = false;
      });
      Navigator.pop(context);
    });
  }
}

class TextFieldModel {
  final TextEditingController controller;

  TextFieldModel({required this.controller});
}

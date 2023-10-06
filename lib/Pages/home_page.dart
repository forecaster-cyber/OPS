import 'dart:core';
//import 'dart:js_interop';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'recipe_page.dart';
import 'search_results_pafe.dart';
import 'upload.dart';
import 'package:zushi_and_karrot/main.dart';
import 'package:zushi_and_karrot/components/recipe_preview_componenet.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.voidCallback});
  final Future<void> Function() voidCallback;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<double>> fetchOpenAIEmbeddings(String inputParam) async {
    final String apiKey = "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";
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

  var finalobjectslist = objectsList.reversed;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, right: 15, left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good ' + greeting() + ",",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      Text(
                        "what would you like \nto cook today?",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, top: 15),
                  child: SizedBox(
                  width: 50,
                  height: 50,
                  child: BoringAvatars(
                      name: extractUsername(emailll!), type: BoringAvatarsType.beam)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0, left: 15, right: 15),
            child: isLoading ? CircularProgressIndicator() : TextField(
              controller: searchController,
              onSubmitted: (value) async {
                setState(() {
                  isLoading = true;
                });
                final List data =
                    await supabase.rpc('match_documents', params: {
                  'query_embedding':
                      await fetchOpenAIEmbeddings(searchController.text),
                  'match_threshold': 0.5,
                  'match_count': 2
                });
                print(data);
                List objectsList_temp = [];
                await supabase
                    .from("recipesJsons")
                    .select<PostgrestList>("JSON")
                    .textSearch("created_by", searchController.text,
                        type: TextSearchType.websearch)
                    .then((value) {
                  for (var element in data) {
                    // print(element["JSON"]);

                    Map<String, dynamic> decJson =
                        jsonDecode(element["content"]);
                    // print(decJson);

                    objectsList_temp.add(decJson);
                  }
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchResultsPage(
                            resultObjectslist: objectsList_temp,
                            searchText: searchController.text)),
                  );
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
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: const Text(
                    "categories",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    height: 75,
                    child: ListView.builder(
                      shrinkWrap: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: names.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            width: 75,
                            height: 75,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  icons[index],
                                  style: TextStyle(fontSize: 28),
                                ),
                                Text(
                                  names[index],
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
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: const Text(
                      "Recommended",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      height: 175,
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
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RecipePage(
                                              object: objectsList[index],
                                            )),
                                  );
                                },
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: RecipePreview(
                                      createdBy: objectsList[index]
                                          ['created_by'],
                                      imageUrl: objectsList[index]['image_url'],
                                      title: objectsList[index]['recipe_name']),
                                )),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ]),
      ),
    ));
  }
}

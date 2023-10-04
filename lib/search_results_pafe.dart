import 'package:zushi_and_karrot/recipe_page.dart';

import 'main.dart';
import 'package:flutter/material.dart';

class SearchResultsPage extends StatefulWidget {
  final List resultObjectslist;
  final String searchText;
  const SearchResultsPage(
      {super.key, required this.resultObjectslist, required this.searchText});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back)),
                  Text(
                    " results for '" + widget.searchText + " '",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: widget.resultObjectslist.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecipePage(
                                      object: widget.resultObjectslist[index],
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
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

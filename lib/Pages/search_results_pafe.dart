import 'recipe_page.dart';
import 'package:zushi_and_karrot/components/recipe_preview_componenet.dart';
import 'package:zushi_and_karrot/main.dart';
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
                        setState(() {
                          category_foods_list = [];
                        });
                      },
                      icon: Icon(Icons.arrow_back)),
                  Text(
                    " results for '" + widget.searchText + "'",
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
                      padding: index % 2 == 0
                          ? const EdgeInsets.only(right: 5, bottom: 5)
                          : const EdgeInsets.only(left: 5, bottom: 5),
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
                          child: RecipePreview(
                              createdBy: widget.resultObjectslist[index]
                                  ['created_by'],
                              imageUrl: widget.resultObjectslist[index]
                                  ['image_url'],
                              title: widget.resultObjectslist[index]
                                  ['recipe_name'])),
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

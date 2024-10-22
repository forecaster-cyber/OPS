import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// NOT USED
class RecipeWidget extends StatefulWidget {
  final Map<String, dynamic> values;

  const RecipeWidget({
    super.key,
    required this.values,
  });

  @override
  State<RecipeWidget> createState() => _RecipeWidgetState();
}

class _RecipeWidgetState extends State<RecipeWidget> {
  List<Widget> steps = [];
  final page_controller = PageController();
  final ExpansionTileController expansion_tile_first_controller =
      ExpansionTileController();

  final ExpansionTileController expansionTileSecondController =
      ExpansionTileController();
  @override
  Widget build(BuildContext context) {
    var recipe_name = widget.values["recipe_name"];
    var image_url = widget.values["image_url"];
    var created_by = widget.values["created_by"];
    var ingerdiants = widget.values["ingredients"];
    var avatar_url = widget.values["avatar_url"];
    List stepsss = widget.values['steps'];
    for (var i = 0; i < stepsss.length; i++) {
      steps.add(Text(widget.values['steps'][i]));
    }
    return Container(
      width: 100,
      constraints: BoxConstraints(
        maxWidth: 100,
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 100,
          ),
          child: Card(
            color: Color(0xFFe7eeed),
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 800,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    child: Image.network(
                      image_url,
                      width: 250,
                      height: 250,
                    ),
                    onTap: () {
                      if (expansion_tile_first_controller.isExpanded) {
                        expansion_tile_first_controller.collapse();
                      } else {
                        expansion_tile_first_controller.expand();
                      }
                    },
                  ),
                  ExpansionTile(
                    controller: expansion_tile_first_controller,
                    title: Text(
                      recipe_name.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    subtitle: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage: NetworkImage(avatar_url),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          created_by.toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    children: [
                      ExpansionTile(
                        controller: expansionTileSecondController,
                        title: Text("Ingerdiants:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(ingerdiants),
                          )
                        ],
                      ),
                      Text(
                        "Steps:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25.0),
                      ),
                      Center(
                        child: Container(
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PageView(
                              controller: page_controller,
                              children: steps,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SmoothPageIndicator(
                          onDotClicked: (index) {
                            page_controller.animateToPage(index,
                                duration: Duration(milliseconds: 250),
                                curve: Curves.linear);
                          },
                          controller: page_controller,
                          count: stepsss.length,
                          effect: WormEffect(
                            activeDotColor: Theme.of(context).primaryColor,
                            dotHeight: 8,
                            dotWidth: 8,
                            type: WormType.normal,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

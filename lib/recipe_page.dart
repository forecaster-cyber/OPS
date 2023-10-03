import 'package:flutter/material.dart';
import 'main.dart';

class RecipePage extends StatefulWidget {
  final int index;
  final bool currentUserCreated;
  const RecipePage(
      {super.key, required this.index, required this.currentUserCreated});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.grey.shade100,
            shadows: const <Shadow>[
              Shadow(color: Colors.black, blurRadius: 5.0)
            ],
            size: 42,
          ),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ClipRRect(
              child: Image.network(
                widget.currentUserCreated
                    ? myPostsList[widget.index]["image_url"]
                    : objectsList[widget.index]["image_url"],
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 1.6,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: ListView.builder(
                  itemCount: 1, // Set the itemCount to 1
                  padding: const EdgeInsets.only(top: 0), // Remove top padding
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.currentUserCreated
                                          ? myPostsList[widget.index]
                                              ['recipe_name']
                                          : objectsList[widget.index]
                                              ['recipe_name'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      softWrap: false,
                                      style: const TextStyle(
                                          fontSize: 24, color: Colors.black),
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      widget.currentUserCreated
                                          ? myPostsList[widget.index]
                                              ['avatar_url']
                                          : objectsList[widget.index]
                                              ['avatar_url'],
                                    ),
                                    radius: 20,
                                  ),
                                ],
                              ),
                              Text(
                                widget.currentUserCreated
                                    ? myPostsList[widget.index]['created_by']
                                    : objectsList[widget.index]['created_by'],
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                               Text(
                                widget.currentUserCreated ? (myPostsList[widget.index]['duration'] ?? "? ") + " min" : (objectsList[widget.index]['duration']?? "? ") + " min",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Ingredients",
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              ),
                              Text(
                                  widget.currentUserCreated
                                      ? myPostsList[widget.index]['ingredients']
                                      : objectsList[widget.index]
                                          ['ingredients'],
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black54))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Steps",
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List<Widget>.generate(
                                  widget.currentUserCreated
                                      ? myPostsList[widget.index]['steps']
                                          .length
                                      : objectsList[widget.index]['steps']
                                          .length,
                                  (index) {
                                    final stepText = widget.currentUserCreated
                                        ? myPostsList[widget.index]['steps']
                                            [index]
                                        : objectsList[widget.index]['steps']
                                            [index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        '${index + 1}. $stepText',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_boring_avatars/flutter_boring_avatars.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zushi_and_karrot/Pages/signinsignup.dart';
import 'package:zushi_and_karrot/Pages/upload.dart';
import 'package:zushi_and_karrot/main.dart';

class RecipePage extends StatefulWidget {
  // final int index;
  // final bool currentUserCreated;
  final dynamic object;
  const RecipePage({super.key, required this.object});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  late bool isLiked;

  Icon iconIcon = const Icon(Icons.favorite_border);
  @override
  void initState() {
    if (likedObjects.contains(widget.object)) {
      setState(() {
        iconIcon = const Icon(
          Icons.favorite,
          color: Colors.red,
        );
      });
    } else {
      setState(() {
        iconIcon = const Icon(
          Icons.favorite_border,
          color: Colors.black54,
        );
      });
    }

    getLikeCount(widget.object);
    super.initState();
  }

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
                widget.object["image_url"],
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.object['recipe_name'],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      softWrap: false,
                                      style: const TextStyle(
                                          fontSize: 24, color: Colors.black),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            if (likedObjects
                                                .contains(widget.object)) {
                                              removeIdFromLikes(widget.object);

                                              setState(() {
                                                iconIcon = const Icon(
                                                  Icons.favorite_border,
                                                  color: Colors.black54,
                                                );
                                              });
                                            } else {
                                              addIdToLikes(widget.object);
                                              setState(() {
                                                iconIcon = const Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                );
                                              });
                                            }
                                          },
                                          icon: iconIcon),
                                      // CircleAvatar(
                                      //   backgroundImage: NetworkImage(
                                      //     widget.object['avatar_url'],
                                      //   ),
                                      //   radius: 20,
                                      // ),

                                      SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: BoringAvatars(
                                              name: widget.object['created_by'],
                                              type: BoringAvatarsType.beam)),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                widget.object['created_by'],
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                              Text(
                                (widget.object['duration'] ?? "? ") + " min",
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
                              Text(widget.object['ingredients'],
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
                                  widget.object['steps'].length,
                                  (index) {
                                    final stepText =
                                        widget.object['steps'][index];
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

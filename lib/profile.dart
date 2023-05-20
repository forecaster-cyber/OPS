import 'package:flutter/material.dart';
import 'package:zushi_and_karrot/main.dart';
import 'upload.dart';
import 'recipe.dart';

class profilePage extends StatefulWidget {
  const profilePage({super.key});

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  @override
  Widget build(BuildContext context) {
    print(myPostsList);
    return SafeArea(
        child: Center(
      child: Column(children: [
        SizedBox(
          height: 20,
        ),
        CircleAvatar(
          backgroundImage: NetworkImage(generateGravatarImageUrl(emailll!, 80)),
          radius: 80,
        ),
        Text(
          extractUsername(emailll!),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        Container(
          height: 250,
          width: 250,
          child: PageView.builder(
            itemCount: myPostsList.length,
            itemBuilder: (context, index) {
              return RecipeWidget(
                values: myPostsList[index],
              );
            },
          ),
        )
      ]),
    ));
  }
}

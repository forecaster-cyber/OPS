import 'package:flutter/material.dart';
import 'package:zushi_and_karrot/main.dart';
import 'recipe_page.dart';
import 'upload.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
      child: Column(children: [
       const  SizedBox(
          height: 20,
        ),
        CircleAvatar(
          backgroundImage:
              NetworkImage(generateGravatarImageUrl(emailll!, 320)),
          radius: 80,
        ),
        Text(
          extractUsername(emailll!),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: SizedBox(
                height: 400,
                width: 400,
                child: GridView.builder(
                  itemCount: myPostsList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecipePage(
                                    index: index,
                                    // checking if needing to view a user created post, or another user post, because its 2 different lists, can be confused with the index
                                    currentUserCreated: true,
                                  )),
                        );
                      },
                      child: Image.network(myPostsList[index]["image_url"]),
                    );
                  },
                )),
          ),
        )
      ]),
    ));
  }
}

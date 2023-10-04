import 'package:flutter/material.dart';
import 'package:zushi_and_karrot/main.dart';
import 'package:zushi_and_karrot/recipe_preview_componenet.dart';
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
        child: Column(
          children: [
            const SizedBox(
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: myPostsList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
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
                                object: myPostsList[index],
                              ),
                            ),
                          );
                        },
                        child: recipePreview(
                          createdBy: myPostsList[index]['created_by'],
                          imageUrl: myPostsList[index]['image_url'],
                          title: myPostsList[index]['recipe_name'],
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
    );
  }
}

import 'package:flutter/material.dart';
import '../background/appbar_generic.dart';
import '../background/background_generic.dart';

class AdotePage extends StatelessWidget {
  AdotePage({super.key, });

  // List of comments to display
  List<String> comments = [
    'Great post!',
    'Amazing work!',
    'Keep it up!',
    'Beautiful picture!',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: const CustomAppBar(),
        body: GradientBackground(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  ' Adoção',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                    fontFamily: 'Handwritten',
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 16),
                      buildImageSection(
                          context, 'assets/images/diversion-board.png', 120, 45),
                      const SizedBox(height: 16),
                      buildImageSection(
                          context, 'assets/images/ImageHome.jpeg', 120, 45),
                      const SizedBox(height: 16),
                      buildImageSection(
                          context, 'assets/images/luna1.jpg', 95, 30),
                      const SizedBox(height: 16),
                      buildImageSection(
                          context, 'assets/images/luna1.jpg', 110, 25),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildImageSection(
      BuildContext context, String imagePath, int likes, int commentsCount) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.white.withOpacity(0.5),  // change this color to whatever you like
          width: 1.5,
        ),
      ),
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.pink),
                  const SizedBox(width: 4),
                  Text(
                    '$likes',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.comment, color: Colors.pink),
                    onPressed: () {
                      _showListBottomSheet(context);
                    },
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$commentsCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.pets, color: Colors.pink),
                    onPressed: () {
                      //_showListBottomSheet(context);
                    },
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showListBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.pink,
          child: ListView.builder(
            itemCount: comments.length,
            itemBuilder: (BuildContext context, int index) {
              String comment = comments[index];
              return ListTile(
                tileColor: Colors.white,
                title: Text(
                  comment,
                  style: const TextStyle(
                      color: Colors.white),
                ),
                onTap: () {
                  // Handle comment tap if needed
                },
              );
            },
          ),
        );
      },
    );
  }
}


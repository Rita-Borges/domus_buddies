import 'package:flutter/material.dart';
import 'AppBarGeneric.dart';
import 'BackgroundGeneric.dart';

class AdotePage extends StatelessWidget {
  AdotePage({Key? key});

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
        appBar: CustomAppBar(),
        body: GradientBackground(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
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
                      SizedBox(height: 16),
                      buildImageSection(
                          context, 'assets/images/ImageHome.jpeg', 120, 45),
                      SizedBox(height: 16),
                      buildImageSection(
                          context, 'assets/images/luna1.jpg', 95, 30),
                      SizedBox(height: 16),
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
                  Icon(Icons.favorite, color: Colors.pink),
                  SizedBox(width: 4),
                  Text(
                    '$likes',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 12),
                  IconButton(
                    icon: Icon(Icons.comment, color: Colors.pink),
                    onPressed: () {
                      _showListBottomSheet(context);
                    },
                  ),
                  SizedBox(width: 4),
                  Text(
                    '$commentsCount',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.pets, color: Colors.pink),
                    onPressed: () {
                      //_showListBottomSheet(context);
                    },
                  ),
                  SizedBox(width: 4),
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
                  style: TextStyle(
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

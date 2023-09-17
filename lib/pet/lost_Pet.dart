import 'package:domus_buddies/upload_page.dart';
import 'package:flutter/material.dart';
import '../background/appbar_generic.dart';
import '../background/background_generic.dart';

class LostPetPage extends StatelessWidget {
  LostPetPage({super.key,});
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: const CustomAppBar(),
        body: Stack(
          children: [
            GradientBackground(
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      ' Lost Pet',
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
                              context, 'assets/images/luna1.jpg', 300, 200),

                          SizedBox(
                            height: 300.0, // You can adjust this height as per your requirement
                            child: TextField(
                              controller: _textController,
                              style: const TextStyle(color: Colors.white),
                              maxLines: 4,
                              decoration: const InputDecoration(
                                labelText: "Escreve a tua descrição aqui...",
                                labelStyle: TextStyle(color: Colors.pink),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.pink, width: 2.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            //bottom: 16, // adjust as needed
                            left: 0,
                            right: 0,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add some padding to make the button look better
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink, // background color
                                    foregroundColor: Colors.white, // text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(color: Colors.white, width: 2.0),
                                    ),
                                    elevation: 5.0,
                                    padding: const EdgeInsets.all(16.0),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,  // Center the children horizontally
                                    children: [
                                      Icon(Icons.cloud_upload_outlined),  // This is your icon
                                      SizedBox(width: 10),  // Provides some spacing between icon and text
                                      Text('Upload Lost'),
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => UploadPage()),
                                    );
                                  },
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
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
          ],
        ),
      ),
    );
  }
}
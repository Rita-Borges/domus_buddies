import 'package:flutter/material.dart';
import 'AddPetToUser.dart';
import 'AppBarGeneric.dart';
import 'BackgroundGeneric.dart';
import 'NEWRegVeterinario.dart';
import 'lostPet.dart';

class MyPetsListPage extends StatelessWidget {
  MyPetsListPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(),
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
                      ' Os meus Pets ',
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
                              context, 'assets/images/luna1.jpg', 100, 50),
                          const SizedBox(height: 16),
                          buildImageSection(
                              context, 'assets/images/luna1.jpg', 100, 50),
                          const SizedBox(height: 16),
                          buildImageSection(
                              context, 'assets/images/luna1.jpg', 100, 50),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 24, // adjust as needed
              left: 0,
              right: 0,
              child: Center(
                // Add pet button
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddPetToUser()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(28.0),
                      border: Border.all(color: Colors.white, width: 2.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // position of shadow
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min, // To make the Container fit the content
                      children: [
                        Icon(Icons.pets_rounded, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          'Adicionar Pet',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Luna',
            style: TextStyle(
              color: Colors.pink,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.white.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          elevation: 4,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
             ]
          ),
        ),
        Positioned(
          bottom: 10,  // Keep the icons at the bottom.
          right: 10,  // Move the icons to the right.
          child: Row(
            children: [
              // Icon to navigate to the Lost Pet Page
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LostPetPage()),
                  );
                },
                child: const Icon(
                  Icons.vaccines_outlined, // You might want to replace this icon to better match its function
                  color: Colors.pink,
                ),
              ),
              const SizedBox(width: 8),  // Space after the icon
              // Text field after the vaccine icon
              Text(
                'Registo veterinário',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),  // Space between the text and the next icon
              // Icon to navigate to the Vet Registration Page
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VetRegisterPage())
                  );
                },
                child: const Icon(
                  Icons.search, // You might want to replace this icon to better match its function
                  color: Colors.pink,
                ),
              ),
              const SizedBox(width: 8),  // Space after the icon
              // Text field after the vaccine icon
              Text(
                'Pet Perdido',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }
}
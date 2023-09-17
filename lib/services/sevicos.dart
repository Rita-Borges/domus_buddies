import 'package:flutter/material.dart';
import '../background/appbar_generic.dart';
import '../background/background_generic.dart';

class SearchServices extends StatefulWidget {
  const SearchServices({super.key});

  @override
  _SearchServicesState createState() => _SearchServicesState();
}

class _SearchServicesState extends State<SearchServices> {
  final List<String> servicesList = [
    'Clínicas e Hospitais Veterinários',
    'Pet Shops',
    'Hotel para Animais (ou Pet Hotels)',
    'Pet Sitting:',
    'Dog Walkers',
    'Treinamento e Escolas para Cães',
    'Grooming (ou Tosquia e Banho)',
    'Transporte de Animais:',
    'Fotografia para Animais',
    'Creches para Animais:',
    'Terapias Alternativas',
    'Boutiques de animais',
    'Adoção e Abrigos',
    'Funerárias e Cemitérios para Animais',
  ];

  final List<String> locationsList = [
    'A sua localização atual GPS',
    'Aveiro',
    'Beja',
    'Braga',
    'Bragança',
    'Castelo Branco',
    'Coimbra',
    'Évora',
    'Faro',
    'Guarda',
    'Leiria',
    'Lisboa',
    'Portalegre',
    'Porto',
    'Santarém',
    'Setúbal',
    'Viana do Castelo',
    'Vila Real',
    'Viseu',
  ];

  String? selectedService;
  String? selectedLocation;

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
                      ' Serviços',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                        fontFamily: 'Handwritten',
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Dropdown menu for Service
                    Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButton<String>(
                        value: selectedService,
                        hint:const Text(
                          '    Selecionar serviço',
                          style: TextStyle(
                              color: Colors.pink, fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.pink),
                        // Set the arrow icon color to pink
                        items: servicesList.map((String service) {
                          return DropdownMenuItem<String>(
                            value: service,
                            child: Padding(
                              padding:const EdgeInsets.only(left: 16.0),
                              child: Text(
                                service,
                                style: const TextStyle(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedService = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Dropdown menu for Location
                    Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButton<String>(
                        value: selectedLocation,
                        hint:const Text(
                          '   Selecionar localização',
                          style: TextStyle(
                              color: Colors.pink, fontWeight: FontWeight.bold),
                        ),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.pink),
                        // Set the arrow icon color to pink
                        items: locationsList.map((String location) {
                          return DropdownMenuItem<String>(
                            value: location,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                location,
                                style:const TextStyle(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLocation = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                     SizedBox(
                      width: double.infinity,  // Set width to full screen
                      height: 50.0,  // Set a fixed height for the button
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Add the action to be triggered when the button is pressed
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,  // Set the color of the button to pink
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),  // Square shape
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Center align the Row's children
                          children: [
                            Icon(Icons.search, color: Colors.white),  // Search Icon
                            SizedBox(width: 10),  // Spacing between the icon and text
                            Text(
                              'pesquisar',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Image.asset(
                      'assets/images/diversion-board.png',
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
}
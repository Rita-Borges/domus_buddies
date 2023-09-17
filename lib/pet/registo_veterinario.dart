import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../background/appbar_generic.dart';
import '../background/background_generic.dart';
import '../User/get_keycloack_token.dart';
import 'animal_info.dart';
import 'registar_vacinas.dart';
import 'dart:async';

class ObterRegistoVeterinario extends StatefulWidget {
  final AnimalInfo animalInfo;

  const ObterRegistoVeterinario({Key? key, required this.animalInfo})
      : super(key: key);

  @override
  _ObterRegistoVeterinarioState createState() =>
      _ObterRegistoVeterinarioState();
}

class _ObterRegistoVeterinarioState extends State<ObterRegistoVeterinario> {
  List<dynamic>? clinicalRecords; // Change the type to List<dynamic>?
  bool isLoading = false;
  DateTime? nextAppointmentTime;

  void scheduleAppointment() {
    final now = DateTime.now();
    final scheduledTime =
    now.add(const Duration(minutes: 30)); // Example: 30 minutes from now

    setState(() {
      nextAppointmentTime = scheduledTime;
    });


    //print('Scheduled appointment for $scheduledTime');
  }

  @override
  void initState() {
    super.initState();
    // Fetch clinical records data when the page is loaded
    fetchClinicalRecords(widget.animalInfo);
  }

  Future<void> fetchClinicalRecords(AnimalInfo petInfo) async {
    // Retrieve the access token from your provider
    final accessTokenProvider =
    Provider.of<FetchUserData>(context, listen: false);
    final authToken = accessTokenProvider.accessToken;

    const apiUrl = 'http://domusbuddies.eu:8082/api/v1/clinicalInfo/list/';

    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse('$apiUrl${petInfo.uniqueId}'),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          clinicalRecords = jsonData;
          isLoading = false;
        });
      } else {
        //print('Failed to fetch clinical records');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      //print('Error fetching clinical records: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Registo veterinário',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                  fontFamily: 'Handwritten',
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildElevatedButton(
                        'Chip nº: ${widget.animalInfo.microchip ?? ""}'),
                    _buildElevatedButton('Nome: ${widget.animalInfo.name}'),
                    _buildElevatedButton(
                        'Idade: ${widget.animalInfo.calculateAge()} meses'),
                    _buildElevatedButton(
                        'Espécie: ${widget.animalInfo.specie}'),
                    _buildElevatedButton('Raça: ${widget.animalInfo.breed}'),
                    const SizedBox(height: 8),
                    _buildElevatedButton('Registo clínico', onPressed: () {
                      // Navigate to the ClinicalRecordsPage when the button is pressed
                      var animalInfoInner = widget.animalInfo;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RegistoVacinas(animalInfoInner),
                        ),
                      );
                    }),
                    isLoading
                        ? const CircularProgressIndicator() // Show a loading indicator while data is being fetched
                        : _buildTextField(
                        'Clinical Records', clinicalRecords ?? []),
                    const SizedBox(height: 8),
                    _buildElevatedButton('Próximo Agendamento',
                        onPressed: scheduleAppointment),
                    _buildTextField('Next Appointment = ''work in progress',[]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildElevatedButton(String text, {VoidCallback? onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(text),
      ),
    );
  }

  Widget _buildTextField(String labelText, List<dynamic> data) {
    final text = data.isNotEmpty
        ? data.map((record) {
      return 'Date: ${record['date']}\nName: ${record['name']}\nDescription: ${record['description']}\nDoctor: ${record['doctorName']}';
    }).join('\n\n') // Add two newline characters between records
        : 'No clinical records available ';

    return TextField(
      maxLines: null,
      // Allows multiple lines of text
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white), // Label text color
        border: const OutlineInputBorder(),
      ),
      controller: TextEditingController(text: text),
      readOnly: true,
      style:
      const TextStyle(color: Colors.white), // Clinical records text color
    );
  }
}

class ClinicalRecordsPage extends StatelessWidget {
  final List<dynamic> clinicalRecords;

  const ClinicalRecordsPage({super.key, required this.clinicalRecords});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clinical Records'),
      ),
      body: ListView.builder(
        itemCount: clinicalRecords.length,
        itemBuilder: (context, index) {
          final record = clinicalRecords[index];
          // Build a widget to display the clinical record data
          // You can customize the UI as needed
          return const ListTile();
        },
      ),
    );
  }
}

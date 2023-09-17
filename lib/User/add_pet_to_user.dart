import 'dart:convert';
import 'dart:io';
import 'package:domus_buddies/pet/pet_list.dart';
import 'package:domus_buddies/User/user_info.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../background/appbar_generic.dart';
import '../background/background_generic.dart';
import 'get_keycloack_token.dart';

class PetDataFetcher {
  static Future<List<String>> fetchSpecies() async {
    try {
      final response = await http.get(Uri.parse('http://domusbuddies.eu:8082/api/v1/specie/listAll'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data);
      } else {
        //print('Failed to fetch species and breeds');
        return [];
      }
    } catch (error) {
      //print('Error fetching species and breeds: $error');
      return [];
    }
  }

  static Future<List<String>> fetchBreeds(String selectedEspecie) async {
    try {
      final response = await http.get(Uri.parse('http://domusbuddies.eu:8082/api/v1/specie/$selectedEspecie/breeds'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data);
      } else {
        //print('Failed to fetch breeds');
        return [];
      }
    } catch (error) {
      //print('Error fetching breeds: $error');
      return [];
    }
  }
}

class AddPetToUser extends StatefulWidget {
  const AddPetToUser({Key? key}) : super(key: key);

  @override
  _AddPetToUserState createState() => _AddPetToUserState();
}

class _AddPetToUserState extends State<AddPetToUser> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _chipController = TextEditingController();
  DateTime? _selectedDate;
  File? _selectedImage;
  String? _selectedEspecie;
  String? _selectedRaca;
  String? _selectedGender;
  List<String> _species = [];
  List<String> _breeds = [];
  final List<String> _genders = ['Feminino', 'Masculino'];

  @override
  void initState() {
    super.initState();
    // Fetch species when the widget initializes
    _fetchEspecie();
  }

  Future<void> _fetchEspecie() async {
    final species = await PetDataFetcher.fetchSpecies();
    setState(() {
      _species = species;
    });
  }

  Future<void> _fetchBreed() async {
    final breeds = await PetDataFetcher.fetchBreeds(_selectedEspecie ?? "");
    setState(() {
      _breeds = breeds;
    });
  }

  Widget _buildEspecieDropdown() => _buildDropdown(_species, _selectedEspecie, (value) {
    setState(() {
      _selectedEspecie = value;
      // Reset the selected breed when the species changes
      _selectedRaca = null;
      _fetchBreed();
    });
  }, 'Espécie');

  Widget _buildRacaDropdown() => _buildDropdown(_breeds, _selectedRaca, (value) {
    setState(() {
      _selectedRaca = value;
    });
  }, 'Raça');

  Widget _buildGenderDropdown() => _buildDropdown(_genders, _selectedGender, (value) {
    setState(() {
      _selectedGender = value;
    });
  }, 'Sexo');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: GradientBackground(
        child: Column(
          children: [
            _buildTitle(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildPetImageSelector(),
                  const SizedBox(height: 16),
                  _buildNameField(),
                  const SizedBox(height: 8),
                  _buildChipNumberField(),
                  const SizedBox(height: 8),
                  _buildEspecieDropdown(),
                  const SizedBox(height: 8),
                  _buildRacaDropdown(),
                  const SizedBox(height: 8),
                  _buildGenderSelector(), // Add gender selector
                  const SizedBox(height: 8),
                  _buildDateOfBirthSelector(),
                  const SizedBox(height: 16),
                  _buildAddPetButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildTitle() {
    return const Text(
      'Adicione o seu Pet',
      style: TextStyle(
        color: Colors.pink,
        fontSize: 40.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Handwritten',
      ),
    );
  }
  Widget _buildGenderSelector() {
    return _buildGenderDropdown();
  }

  Widget _buildPetImageSelector() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipOval(
                child: Opacity(
                  opacity: 1.0,
                  child: _selectedImage != null
                      ? Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    'assets/images/logo2.png',
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Tooltip(
                  message: "Change Picture",
                  child: CircleAvatar(
                    backgroundColor: Colors.white54,
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.pink),
                      onPressed: _pickImage,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }


  Widget _buildNameField() => _buildTextField(_nameController, 'Nome');
  Widget _buildChipNumberField() => _buildTextField(_chipController, 'Número do chip');

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.pink),
        ),
      ),
    );
  }


  Widget _buildDropdown(List<String> items, String? selectedValue, ValueChanged<String?> onChanged, String label) {
    return DropdownButtonFormField(
      iconEnabledColor: Colors.pink,
      iconDisabledColor: Colors.pink,
      value: selectedValue,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.pink),
        ),
      ),
      items: items.map((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value, style: const TextStyle(color: Colors.pink)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDateOfBirthSelector() {
    return InkWell(
      onTap: () {
        _selectDate(context);
      },
      child: IgnorePointer(
        child: TextField(
          controller: TextEditingController(
            text: _selectedDate != null
                ? _selectedDate.toString().split(' ')[0]
                : '',
          ),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Data de Nascimento',
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.pink),
            ),
            suffixIcon: Icon(
              Icons.calendar_today,
              color: Colors.pink,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddPetButton() {
    return SizedBox(
      height: 50.0,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onAddPetPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets_rounded),
            SizedBox(width: 8.0),
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
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.pink,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onAddPetPressed() async {
    //print(_nameController.text);
    //print(_shipController.text);
    //print(_selectedGender);
    //print(_selectedEspecie);
    //print(_selectedRaca);
    //print(_selectedDate);
    if (_validateInputs()) {
      var gender = _selectedGender?.compareTo("Femenino") == 0 ? 'FEMALE' : 'MALE';
      var datebirth = _selectedDate?.toIso8601String();
      final petData = {
        'name': _nameController.text,
        'microchipNumber': _chipController.text,
        'specie': _selectedEspecie,
        'breed': _selectedRaca,
        'gender': gender, // Include the selected gender
        'birthDate': datebirth?.substring(0, datebirth.indexOf('T', 0)),
        'owner': UserSession.getLoggedInUsername(),
        // 'imagePath': _selectedImage?.path, // Sending image path is optional
      };

      // Get the token using the existing KeycloakServicePut object
      final accessTokenProvider =
      Provider.of<FetchUserData>(context,
          listen: false);
      String? accessToken =
          accessTokenProvider.accessToken;

      final response = await http.post(
        Uri.parse('http://domusbuddies.eu:8082/api/v1/animals/create'), // Replace with your actual API endpoint
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Include the token in the headers
        },
        body: jsonEncode(petData),
      );


      if (response.statusCode == 201) {
        const snackBar = SnackBar(content: Text('Pet added successfully!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Delay navigation for a few seconds to allow the user to see the message
        await Future.delayed(const Duration(seconds: 1));

        // Navigate to a different page after showing the success message
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MyPetsList()), // Replace SuccessPage with the actual page you want to navigate to
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add pet. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly.')),
      );
    }
  }

  bool _validateInputs() {
    return _nameController.text.isNotEmpty &&
        _chipController.text.isNotEmpty &&
        _selectedEspecie != null &&
        _selectedRaca != null &&
        _selectedDate != null ;
  }

}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:domus_buddies/User/get_keycloack_token.dart';
import 'package:domus_buddies/User/update_get_user_info_request.dart';
import 'package:domus_buddies/User/update_user_info_request.dart';
import 'package:domus_buddies/User/user_info.dart';
import 'package:provider/provider.dart';

import '../background/appbar_generic.dart';
import '../background/background_generic.dart';
import '../feed_page.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class ImageFromFile extends StatelessWidget {
  final File imageFile;

  const ImageFromFile({required this.imageFile, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.file(
      imageFile,
      key: key,
      width: 150.0,
      height: 150.0,
      fit: BoxFit.cover,
    );
  }
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _moradaRuaController = TextEditingController();
  final TextEditingController _moradaNumeroPorta = TextEditingController();
  final TextEditingController _moradaCodigoPostalController =
  TextEditingController();
  final TextEditingController _moradaCidadeController = TextEditingController();
  DateTime? _selectedDate;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final accessTokenProvider =
    Provider.of<FetchUserData>(context, listen: false);
    String? accessToken = accessTokenProvider.accessToken;
    String? loggedInUsername = UserSession.getLoggedInUsername();

    if (accessToken != null && loggedInUsername != null) {
      try {
        Map<String, dynamic> userData =
        await getUserInfo(loggedInUsername, accessToken);

        setState(() {
          _usernameController.text = loggedInUsername;
          _firstNameController.text = userData['firstName'] ?? '';
          _lastNameController.text = userData['lastName'] ?? '';
          _emailController.text = userData['email'] ?? '';
        });
      } catch (error) {
        //print('Error fetching user data: $error');
      }
    } else {
      //print('Failed to get access token or logged-in username.');
    }
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

  bool _isAnyFieldEmpty() {
    return [
      _firstNameController,
      _lastNameController,
      _emailController,
      _usernameController,
    ].any((controller) => controller.text.isEmpty);
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

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('User information updated successfully!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to the NovidadesPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const NovidadesPage()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          if (_isAnyFieldEmpty()) {
            //print("Please fill all the required fields.");
            return;
          }

          // Create a User object with entered data
          User user = User(
            username: _usernameController.text,
            email: _emailController.text,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            //aniversario: _birthDateController.text,
            moradaRua: _moradaRuaController.text,
            moradaPorta: _moradaNumeroPorta.text,
            moradaCodigoPostal: _moradaCodigoPostalController.text,
            moradaCidade: _moradaCidadeController.text,
            // Add other properties if needed
          );

          // Get the token using the existing KeycloakServicePut object
          final accessTokenProvider =
          Provider.of<FetchUserData>(context, listen: false);
          String? accessToken = accessTokenProvider.accessToken;

          if (accessToken != null) {
            // Perform the PUT request to update user
            await updateUser(user, accessToken);
            _showSuccessDialog(); // Show the success dialog
          } else {
            //print("Failed to get access token.");
          }
        },
        icon: const Icon(Icons.person_outlined, color: Colors.white),
        label: const Text(
          'Atualizar',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: const CustomAppBar(),
        body: GradientBackground(
          child: Column(
            children: [
              _buildProfileHeader(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      _buildImagePicker(),
                      const SizedBox(height: 16.0),
                      _buildTextFields(),
                      const SizedBox(height: 24.0),
                      _buildUpdateButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return const Column(
      children: [
        Text(
          'Atualizar perfil ',
          style: TextStyle(
            color: Colors.pink,
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Handwritten',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
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
                      ? ImageFromFile(
                    imageFile: _selectedImage!,
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

  Widget _buildTextFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _usernameController,
          labelText: 'Username',
        ),
        const SizedBox(height: 16.0),
        _buildTextField(
          controller: _firstNameController,
          labelText: 'Primeiro Nome',
        ),
        const SizedBox(height: 16.0),
        _buildTextField(
          controller: _lastNameController,
          labelText: 'Último Nome',
        ),
        const SizedBox(height: 16.0),
        _buildDateOfBirthSelector(),
        const SizedBox(height: 16.0),
        _buildTextField(
          controller: _emailController,
          labelText: 'Email',
        ),
        const SizedBox(height: 16.0),
        _buildTextField(
          controller: _moradaRuaController,
          labelText: 'Morada - Rua',
        ),
        const SizedBox(height: 16.0),
        _buildTextField(
          controller: _moradaNumeroPorta,
          labelText: 'Morada - Número da Porta',
        ),
        const SizedBox(height: 16.0),
        _buildTextField(
          controller: _moradaCodigoPostalController,
          labelText: 'Morada - Código Postal',
        ),
        const SizedBox(height: 16.0),
        _buildTextField(
          controller: _moradaCidadeController,
          labelText: 'Morada - Cidade',
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.pink,
          ),
        ),
      ),
    );
  }
}

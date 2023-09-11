import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../background/background_generic.dart';
import '../login.dart';
import '../services/register_keycloack.dart';
import 'dart:io';

class RegisterPage1 extends StatefulWidget {
  const RegisterPage1({Key? key}) : super(key: key);

  @override
  _RegisterPage1State createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  File? _selectedImage;

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
      _usernameController,
      _emailController,
      _passwordController,
      _confirmPasswordController,
    ].any((controller) => controller.text.isEmpty);
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegExp.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    return password.length >= 4;
  }

  final KeycloakServiceRegister keycloak = KeycloakServiceRegister(
    baseUrl: 'https://lemur-6.cloud-iam.com',
    realm: 'domusbuddies',
    clientId: 'domusbuddies-app',
    clientSecret: 'a8XIyFyT9EpUBqegN2EncuZkgJXTEJfP',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade200,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.pink),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Efetuar Registo ',
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Handwritten',
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildImagePicker(),
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
                      _buildTextField(
                        controller: _usernameController,
                        labelText: 'Username',
                      ),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                        controller: _emailController,
                        labelText: 'Email',
                      ),
                      const SizedBox(height: 16.0),
                      _buildPasswordField(
                        controller: _passwordController,
                        labelText: 'Password',
                      ),
                      const SizedBox(height: 16.0),
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        labelText: 'Confirma a tua Password',
                      ),
                      const SizedBox(height: 24.0),
                      _buildRegisterButton(),
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

  Widget _buildImagePicker() {
    return Stack(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: ClipOval(
            child: Opacity(
              opacity: 1.0,
              child: _selectedImage != null
                  ? Image.file(_selectedImage!,
                  width: 150.0, height: 150.0, fit: BoxFit.cover)
                  : Image.asset(
                'assets/images/logo2.png',
                width: 150.0,
                height: 150.0,
                fit: BoxFit.cover,
              ),
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
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String labelText}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      onChanged: (text) {
        controller.text = text.toLowerCase();
        controller.selection =
            TextSelection.fromPosition(TextPosition(offset: controller.text.length));
      },
      decoration: InputDecoration(
        labelText: labelText,
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

  Widget _buildPasswordField(
      {required TextEditingController controller, required String labelText}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.pink),
        ),
      ),
      obscureText: true,
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          if (_isAnyFieldEmpty()) {
            _showErrorDialog(context, 'Por favor, preencha todos os campos.');
            return;
          }

          if (!_isValidEmail(_emailController.text)) {
            _showErrorDialog(context, 'Por favor, insira um endereço de email válido.');
            return;
          }

          if (!_isPasswordValid(_passwordController.text)) {
            _showErrorDialog(context, 'A senha deve ter pelo menos 4 caracteres.');
            return;
          }

          _showLocationPermissionDialog(context);

          final success = await keycloak.registerUser(
            username: _usernameController.text,
            email: _emailController.text,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            password: _passwordController.text,
          );

          if (success) {
            print('User registered successfully!');
            // Show a success message and navigate to the login page
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('User registered successfully!'),
                backgroundColor: Colors.pink,
              ),
            );

            // Delay navigation to give time for the user to see the success message
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const LoginPagev0(), // Replace with your login page widget
              ));
            });
          } else {
            _showErrorDialog(context, 'Falha ao registrar usuário.');
          }
        },
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text(
          'Registar',
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

  void _showLocationPermissionDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Location Permission'),
          content: const Text('Do you allow the application to use your location via GPS?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Yes'),
              onPressed: () {
                // Handle location permission logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

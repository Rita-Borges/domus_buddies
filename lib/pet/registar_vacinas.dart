import 'package:domus_buddies/pet/pet_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../background/appbar_generic.dart';
import '../background/background_generic.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../User/get_keycloack_token.dart';
import 'animal_info.dart';

class RegistoVacinas extends StatefulWidget {
  final AnimalInfo animalInfo;

  const RegistoVacinas(this.animalInfo, {Key? key}) : super(key: key);

  @override
  _RegistoVacinasState createState() => _RegistoVacinasState();
}

class _RegistoVacinasState extends State<RegistoVacinas> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  bool _isAnyFieldEmpty() {
    return [
      _nameController,
      _descricaoController,
      _dataController,
      _doctorNameController,
    ].any((controller) => controller.text.isEmpty);
  }

  Future<void> requestPostClinico(String token) async {
    const url = 'http://domusbuddies.eu:8082/api/v1/clinicalInfo/create';

    // Format the date using the intl package
    final formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateTime.now());

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'animalAppId': widget.animalInfo.uniqueId,
        'type': 'APPOINTMENT',
        'name': _nameController.text,
        'description': _descricaoController.text,
        'date': formattedDate, // Use the formatted date
        'doctorName': _doctorNameController.text,
      }),
    );

    if (response.statusCode == 200) {
      //print('Clinic record added successfully.');
    } else {
      //print('Error adding clinic record: ${response.statusCode} ${response.reasonPhrase}');
    }
  }


  @override
  void initState() {
    super.initState();
    // Initialize fields here if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Registo Clinico',
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Handwritten',
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(_nameController, 'Nome', _validateField),
                        _buildTextField(_descricaoController, 'Descrição', _validateField),
                        _buildDateField(),
                        const SizedBox(height: 16.0),
                        _buildTextField(_doctorNameController, 'Veterinário', _validateField),
                        const SizedBox(height: 16.0),
                        _buildRegisterButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;

  Widget _buildTextField(
      TextEditingController controller, String labelText, String? Function(String?)? validator) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pink),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final accessTokenProvider =
          Provider.of<FetchUserData>(context, listen: false);
          String? accessToken = accessTokenProvider.accessToken;

          if (_formKey.currentState!.validate()) {
            String authToken = accessToken ?? ""; // Replace with your authentication token

            if (_isAnyFieldEmpty()) {
              _showErrorDialog(context, 'Por favor, preencha todos os campos.');
              return;
            }

            requestPostClinico(authToken);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyPetsList( )),
            );
          }
        },
        icon: const Icon(Icons.vaccines_outlined, color: Colors.white),
        label: const Text(
          'Adicionar',
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
        _dataController.text = picked.toString().split(' ')[0];
      });
    }
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: () {
        _selectDate(context);
      },
      child: IgnorePointer(
        child: TextFormField(
          controller: _dataController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: 'Data',
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
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
}
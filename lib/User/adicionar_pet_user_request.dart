import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  //final String aniversario;
  final String moradaRua;
  final String moradaPorta;
  final String moradaCodigoPostal;
  final String moradaCidade;

  User({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    //required this.aniversario,
    required this.moradaRua,
    required this.moradaPorta,
    required this.moradaCodigoPostal,
    required this.moradaCidade,

  });

// You can add other properties like birthday, address, etc. here.
}

Future<void> adicionarPetAUser(User user, String token) async {
  const url = 'http://domusbuddies.eu:8080/api/v1/user/update';

  final response = await http.put(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'username': user.username,
      'email': user.email,
      'firstName': user.firstName,
      'lastName': user.lastName,
      //'profileImageName': 'string'
      //'birthDate': user.aniversario,
      'address': {
      'street': user.moradaRua,
      'doorNumber': user.moradaPorta,
      'postalCode': user.moradaCodigoPostal,
      'city': user.moradaCidade,
      }
      // Add other fields like birthday, address, etc. here.
    }),                
  );

  if (response.statusCode == 200) {
    //print('User updated successfully.');
  } else {
    //print('Error updating user: ${response.statusCode} ${response.reasonPhrase}');
    //print('Error updating user: ${response.reasonPhrase} ${response.contentLength}');
    //print('Error updating user: ${String.fromCharCodes(response.bodyBytes)} ${response.reasonPhrase}');
    //print('Error updating user: ${response.statusCode} ${response.reasonPhrase}');
  }
}

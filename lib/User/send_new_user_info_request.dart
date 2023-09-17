import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> createUser(User user, String token) async {
  const url = 'http://domusbuddies.eu:8080/api/v1/user/create';

  final response = await http.post(
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
    }),
  );

  if (response.statusCode == 201) {
    //print('User created successfully.');
  } else {
    //print('Error creating user: ${response.body}');
  }
}

class User {
  final String username;
  final String email;
  final String firstName;
  final String lastName;

  User({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
  });
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../User/send_new_user_info_request.dart';

class KeycloakServiceRegister {
  final String baseUrl;
  final String realm;
  final String clientId;
  final String clientSecret;

  KeycloakServiceRegister({
    required this.baseUrl,
    required this.realm,
    required this.clientId,
    required this.clientSecret,
  });

  Future<String?> getAccessToken() async {
    final tokenEndpoint =
        '$baseUrl/auth/realms/$realm/protocol/openid-connect/token';
    final response = await http.post(
      Uri.parse(tokenEndpoint),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access_token'];
    } else {
      //print('Error fetching access token: ${response.body}');
      return null;
    }
  }

  Future<bool> registerUser({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    final String? accessToken = await getAccessToken();
    if (accessToken == null) {
      return false;
    }

    final usersEndpoint = '$baseUrl/auth/admin/realms/$realm/users';
    final response = await http.post(
      Uri.parse(usersEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'username': username,
        'emailVerified': true,
        'enabled': true,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'credentials': [
          {
            'type': 'password',
            'value': password,
            'temporary': false,
          }
        ],
      }),
    );
    final newUser = User(
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      //password: 'securePassword123',
    );

    createUser(newUser, accessToken);
    return response.statusCode == 201;
  }
}

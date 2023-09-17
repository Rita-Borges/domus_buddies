import 'dart:convert';
import 'package:http/http.dart' as http;
import 'animal_info.dart';

class PostRegistoClinico {
  final String nome;
  final String descricao;
  final String data;
  final String veterinario;

  PostRegistoClinico ({
    required this.nome,
    required this.descricao,
    required this.data,
    required this.veterinario,
  });

  Future<void> requestPostClinico(AnimalInfo animal, String token) async {
    const url = 'http://domusbuddies.eu:8082/api/v1/clinicalInfo/create';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'animalAppId': animal.uniqueId,
        'type': '',
        'name': nome,
        'description': descricao,
        'date': data,
        'doctorName': veterinario,
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
}




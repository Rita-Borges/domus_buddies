import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'animal_info.dart';

class PetDataProvider extends ChangeNotifier {
  List<AnimalInfo> petNames = List.empty();

  Future<String> fetchPetNames(String authToken, String username) async {
    final Uri uri = Uri.parse('http://domusbuddies.eu:8082/api/v1/animals/listByUser/$username');
    final Map<String, String> headers = {
      'Authorization': 'Bearer $authToken',
    };
    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        petNames = parsePets(response.body);
        notifyListeners();
        petNames.forEach((element) {
          print(element.name);
        });
        return "Success"; // Indicate success
      } else {
        print('Error fetching pet names: ${response.statusCode}');
        print('Response body: ${response.body}');
        return 'Error fetching pet names: ${response.statusCode}';
      }
    } catch (error) {
      print('Error fetching pet names: $error');
      return 'Error fetching pet names: $error';
    }
  }

  List<AnimalInfo> parsePets(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<AnimalInfo>((json) => AnimalInfo.fromJson(json)).toList();
  }
}

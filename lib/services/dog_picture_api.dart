
import 'dart:convert';
import 'package:http/http.dart' as http;

class DogPictureApi {
  Future<List<String>> fetchDogImages({int count = 1}) async {
    try {
      final response = await http.get(Uri.parse('https://random.dog/woof.json'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        final List<String> images = data.cast<String>().toList();

        if (images.length >= count) {
          return images.take(count).toList();
        } else {
          // Handle the case where there are fewer images available than requested.
          return images;
        }
      } else {
        throw Exception('Failed to fetch dog images');
      }
    } catch (error) {
      rethrow;
    }
  }
}

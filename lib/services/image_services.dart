import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageServices{
  List<int>? image;

  Future<List<int>?> fetchImage(String authToken, String? mediaName) async {
    if(mediaName == null || mediaName == "") return null;
    final Uri uri = Uri.parse('http://domusbuddies.eu:8081/api/v1/media/get/$mediaName');
    //final Uri uri = Uri.parse('https://random.dog/woof.json');
    final Map<String, String> headers = {
      'Authorization': 'Bearer $authToken',
    };
    try {
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        image = parseFeedImage(response.body);
        return image;
      } else {
        //print('Error fetching image: ${response.statusCode}');
        //print('Error fetching image: ${response.reasonPhrase}');
      }
    } catch (error) {
      //print('Error fetching image: $error');
    }
    return null;
  }

  List<int> parseFeedImage(String jsonString) {
    final parsed = json.decode(jsonString);
    final imageContent = parsed['content'];
    List<int> arrayImage = List.from(imageContent);
    return arrayImage;
    //return Uint8List.fromList(arrayImage);
  }
}
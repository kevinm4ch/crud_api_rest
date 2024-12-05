import 'package:http/http.dart' as http;

class AlbumService {
  final String baseUrl;

  AlbumService({required this.baseUrl});

  Future<http.Response> get() async {
    final url = Uri.parse('$baseUrl/albums');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load albums');
    }

    return response;
  }
}

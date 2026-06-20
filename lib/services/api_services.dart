import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://mapi.trycatchtech.com/v3/ganesha/";

  static Future<List<dynamic>> getData(String endpoint) async {
    final url = Uri.parse(baseUrl + endpoint);

    try {
      final response = await http.get(url);

      print("URL: $url");
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("Server Error: ${response.statusCode}");
      }

      final decoded = jsonDecode(response.body);

      if (decoded is List) return decoded;

      if (decoded is Map<String, dynamic>) {
        if (decoded["data"] is List) return decoded["data"];
        if (decoded["result"] is List) return decoded["result"];
      }

      throw Exception("Invalid API format");
    } catch (e) {
      throw Exception("API Error: $e");
    }
  }
}
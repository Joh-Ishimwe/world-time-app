import 'dart:convert';
import 'package:http/http.dart' as http;

class WorldTimeService {
  static Future<Map<String, dynamic>> fetchTime(String timezone) async {
    final String apiUrl = 'https://worldtimeapi.org/api/timezone/$timezone';
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extract datetime and day information
        return {
          'datetime': data['datetime'],
          'is_daytime': data['datetime'].contains('T')
              ? data['datetime'].split('T')[1].startsWith(RegExp(r'[0-1][0-9]|2[0-3]'))
              : false,
        };
      } else {
        // If status code is not 200, throw an error
        throw Exception('Failed to load time. HTTP Status: ${response.statusCode}');
      }
    } catch (e) {
      // Log any errors and rethrow for the caller to handle
      print('Error fetching time: $e');
      throw e;
    }
  }
}

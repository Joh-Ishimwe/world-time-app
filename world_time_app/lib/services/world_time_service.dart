import 'dart:convert';
import 'package:http/http.dart' as http;

class WorldTimeService {
  static Future<Map<String, dynamic>> fetchTime(String timezone) async {
    final url = 'http://worldtimeapi.org/api/timezone/$timezone';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final isDaytime = data['datetime'].contains('T') && int.parse(data['datetime'].split('T')[1].split(':')[0]) < 18;

      return {
        'datetime': data['datetime'],
        'is_daytime': isDaytime,
      };
    } else {
      throw Exception('Failed to fetch time');
    }
  }
}

import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location; // Location name for UI
  late String time; // Mark as `late` to delay initialization
  String flag; // URL to an asset flag icon
  String url; // Location URL for API endpoint
  late bool isDaytime; // Mark as `late` to delay initialization

  WorldTime({required this.location, required this.flag, required this.url});

  Future<void> getTime() async {
    try {
      // Make the request
      Response response = await get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);

        // Get properties from JSON
        String datetime = data['datetime'];
        String offset = data['utc_offset'].substring(0, 3);

        // Create DateTime object
        DateTime now = DateTime.parse(datetime);
        now = now.add(Duration(hours: int.parse(offset)));

        // Set the time property
        isDaytime = now.hour > 6 && now.hour < 20 ? true : false;
        time = DateFormat.jm().format(now);
      } else {
        throw 'Failed to fetch time data';
      }
    } catch (e) {
      print('Error: $e');
      time = 'Could not fetch time data';
    }
  }
}

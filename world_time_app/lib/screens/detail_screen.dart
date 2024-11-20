import 'package:flutter/material.dart';
import 'package:world_time_app/services/world_time_service.dart';

class DetailScreen extends StatefulWidget {
  final String country;
  final String timezone;

  const DetailScreen({Key? key, required this.country, required this.timezone}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late String currentTime = "Loading...";
  late bool isDaytime = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchCountryTime();
  }

  void fetchCountryTime() async {
    try {
      print('Fetching time for timezone: ${widget.timezone}');
      final result = await WorldTimeService.fetchTime(widget.timezone);

      setState(() {
        currentTime = result['datetime'];
        isDaytime = result['is_daytime'];
        hasError = false;
      });
    } catch (e) {
      print('Error in fetchCountryTime: $e');
      setState(() {
        currentTime = "Error loading time";
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String bgImage = isDaytime ? 'assets/day.png' : 'assets/night.png';
    Color? bgColor = isDaytime ? Colors.blue : Colors.indigo[700];

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bgImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // "Edit Location" at the top
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Redirect back to the HomeScreen
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.edit_location, color: Colors.white, size: 30),
                        SizedBox(width: 10),
                        Text(
                          'Edit Location',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                // Main content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Current Time in ${widget.country}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        currentTime,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Retry button in case of error
                      if (hasError)
                        ElevatedButton.icon(
                          onPressed: fetchCountryTime,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

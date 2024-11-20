import 'package:flutter/material.dart';
import 'package:world_time_app/services/world_time_service.dart';

class DetailScreen extends StatefulWidget {
  final String country;
  final String timezone;
  final String flag;

  DetailScreen({
    required this.country,
    required this.timezone,
    required this.flag,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? currentTime;
  String? currentDate;
  String backgroundImage = 'day.png'; // Default background
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchTime();
  }

  void fetchTime() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final timeData = await WorldTimeService.fetchTime(widget.timezone);

      if (!mounted) return;

      setState(() {
        final dateTime = DateTime.parse(timeData['datetime']);
        currentTime = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
        currentDate = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
        backgroundImage = timeData['is_daytime'] ? 'day.png' : 'night.png';
        // ignore: unused_local_variable
        Color? bgColor = timeData['isDaytime'] ? Colors.blue : Colors.indigo[700];
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching time: $e');
      if (!mounted) return;

      setState(() {
        errorMessage = 'Failed to load time. Please check your connection and try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.country,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/$backgroundImage',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Center(
            child: isLoading
                ? CircularProgressIndicator()
                : errorMessage != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, color: Colors.red, size: 50),
                          SizedBox(height: 10),
                          Text(
                            errorMessage!,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: fetchTime,
                            child: Text('Retry'),
                          ),
                        ],
                      )
                    : AnimatedOpacity(
                        opacity: isLoading ? 0 : 1,
                        duration: Duration(seconds: 1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.flag, style: TextStyle(fontSize: 50)),
                            SizedBox(height: 20),
                            Text(
                              widget.country,
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Time: ${currentTime ?? ''}',
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Date: ${currentDate ?? ''}',
                              style: TextStyle(fontSize: 20, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

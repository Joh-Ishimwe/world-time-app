import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> countries = [];
  List<Map<String, String>> filteredCountries = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCountries();
    searchController.addListener(_filterCountries);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void fetchCountries() async {
    const url = 'https://restcountries.com/v3.1/all';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final List<Map<String, String>> fetchedCountries = data.map((country) {
          final name = country['name']['common'] as String;
          final flag = (country['flag'] ?? '🏳️') as String;
          final timezones = (country['timezones'] ?? []) as List<dynamic>;
          final timezone = timezones.isNotEmpty ? timezones[0] as String : 'Unknown';
          return {'name': name, 'timezone': timezone, 'flag': flag};
        }).toList();

        setState(() {
          countries = fetchedCountries..sort((a, b) => a['name']!.compareTo(b['name']!));
          filteredCountries = List.from(countries);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching countries: $e');
    }
  }

  void _filterCountries() {
    setState(() {
      filteredCountries = countries
          .where((country) => country['name']!.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a Country')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : countries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 50),
                      const SizedBox(height: 10),
                      const Text(
                        'Failed to load countries. Please try again.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: fetchCountries,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: 'Search for a country',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: filteredCountries.isEmpty
                          ? const Center(
                              child: Text(
                                'No countries found. Try a different search.',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredCountries.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 4,
                                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: ListTile(
                                    leading: Text(filteredCountries[index]['flag']!),
                                    title: Text(
                                      filteredCountries[index]['name']!,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailScreen(
                                            country: filteredCountries[index]['name']!,
                                            timezone: filteredCountries[index]['timezone']!,
                                            flag: filteredCountries[index]['flag']!,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}

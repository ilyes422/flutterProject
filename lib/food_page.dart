import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodPage extends StatefulWidget {
  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  late Future<List<dynamic>> _meals;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _meals = fetchMealsByLetter('a'); 
  }

  Future<List<dynamic>> fetchMealsByLetter(String letter) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?f=$letter'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<List<dynamic>> searchMealsByName(String query) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$query'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('Failed to search meals');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Explorer'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _meals = searchMealsByName(value);
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Meals',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          DropdownButton<String>(
            hint: Text('Select First Letter'),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _meals = fetchMealsByLetter(value);
                });
              }
            },
            items: 'abcdefghijklmnopqrstuvwxyz'
                .split('')
                .map((letter) => DropdownMenuItem<String>(
                      value: letter,
                      child: Text(letter.toUpperCase()),
                    ))
                .toList(),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _meals,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data!.isEmpty) {
                  return Center(child: Text('No meals found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final meal = snapshot.data![index];
                      return ListTile(
                        leading: Image.network(
                          meal['strMealThumb'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(meal['strMeal']),
                        subtitle: Text('Category: ${meal['strCategory'] ?? 'N/A'}'),
                        onTap: () {
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

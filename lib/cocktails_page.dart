import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CocktailsPage extends StatefulWidget {
  @override
  _CocktailsPageState createState() => _CocktailsPageState();
}

class _CocktailsPageState extends State<CocktailsPage> {
  late Future<List<dynamic>> _cocktails;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _cocktails = fetchCocktailsByLetter('a');
  }

  Future<List<dynamic>> fetchCocktailsByLetter(String letter) async {
    final response = await http.get(
      Uri.parse(
          'https://www.thecocktaildb.com/api/json/v1/1/search.php?f=$letter'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['drinks'] ?? [];
    } else {
      throw Exception('Failed to load cocktails');
    }
  }

  Future<List<dynamic>> searchCocktailsByName(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://www.thecocktaildb.com/api/json/v1/1/search.php?i=$query'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['drinks'] ?? [];
    } else {
      throw Exception('Failed to search cocktails');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cocktails Explorer'),
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
                  _cocktails = searchCocktailsByName(value);
                });
              },
              decoration: InputDecoration(
                labelText: 'Search Cocktails',
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
                  _cocktails = fetchCocktailsByLetter(value);
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
              future: _cocktails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data!.isEmpty) {
                  return Center(child: Text('No cocktails found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final cocktail = snapshot.data![index];
                      return ListTile(
                        leading: Image.network(
                          cocktail['strDrinkThumb'] ??
                              'https://via.placeholder.com/50',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title:
                            Text(cocktail['strDrink'] ?? 'No name available'),
                        subtitle: Text(
                            'Category: ${cocktail['strCategory'] ?? 'N/A'}'),
                        onTap: () {},
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

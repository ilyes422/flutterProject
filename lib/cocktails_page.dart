import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'coktail_detail_page.dart';


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
          'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$query'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['drinks'] ?? [];
    } else {
      throw Exception('Failed to search cocktails');
    }
  }

  Future<dynamic> fetchCocktailDetails(String id) async {
    final response = await http.get(
      Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=$id'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['drinks'] != null ? data['drinks'][0] : null;
    } else {
      throw Exception('ERROR.');
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      if (_searchQuery.isEmpty) {
        _cocktails = fetchCocktailsByLetter('a');
      } else {
        _cocktails = searchCocktailsByName(_searchQuery);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Available Cocktails',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,  
              ),
            ),
           backgroundColor: Colors.purple,
        ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                labelText: 'Search Cocktails',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
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
                  final drinks = snapshot.data!;
                  return ListView.builder(
                    itemCount: drinks.length,
                    itemBuilder: (context, index) {
                      final cocktail = drinks[index];
                      return Card(
                        child: ListTile(
                          leading: cocktail['strDrinkThumb'] != null
                              ? Image.network(
                                  cocktail['strDrinkThumb'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.fastfood),
                          title: Text(cocktail['strDrink'] ?? 'Unknown cocktail'),
                          subtitle:
                              Text(
                              cocktail['strCategory'] ?? 'Unknown category'),
                          onTap: () async {
                            final cocktailDetails =
                                await fetchCocktailDetails(cocktail['idDrink']);
                            if (cocktailDetails != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CocktailDetailPage(cocktailDetails),
                                ),
                              );
                            }
                          },
                        ),
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

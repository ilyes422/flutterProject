import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cocktail_detail_page.dart';
import 'form_add_resource.dart';

class CocktailsPage extends StatefulWidget {
  final bool data;
  final String selectedValue;
  final String name;
  final String category;
  final String description;

  const CocktailsPage({
    super.key,
    this.data = true,
    required this.selectedValue,
    required this.name,
    required this.category,
    required this.description,
  });

  const CocktailsPage.empty({
    super.key,
    this.data = false,
    this.selectedValue = "",
    this.name = "",
    this.category = "",
    this.description = "",
  });

  @override
  _CocktailsPageState createState() => _CocktailsPageState();
}

class _CocktailsPageState extends State<CocktailsPage> {
  late Future<List<dynamic>> _cocktails;
  String _searchQuery = '';
  String _selectedLetter = 'a';
  final List<String> letters = List.generate(26, (index) => String.fromCharCode(97 + index));

  @override
  void initState() {
    super.initState();
    _cocktails = fetchCocktailsByLetter(_selectedLetter);
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
        _cocktails = fetchCocktailsByLetter(_selectedLetter);
      } else {
        _cocktails = searchCocktailsByName(_searchQuery);
      }
    });
  }

  void _onLetterSelected(String letter) {
    setState(() {
      _selectedLetter = letter;
      if (_searchQuery.isEmpty) {
        _cocktails = fetchCocktailsByLetter(letter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Cocktails'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormAddResource(selectedValue: 'Drink'),
                ),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
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
                if (widget.data)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last drink created',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 16),
                        Card(
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            title: Text(
                        widget.name.isNotEmpty
                            ? widget.name
                            : 'Unknown drink',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              widget.category.isNotEmpty
                                  ? widget.category
                                  : 'Unknown category',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                      ],
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
                          title:
                              Text(cocktail['strDrink'] ?? 'Unknown cocktail'),
                          subtitle: Text(
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
          ),
          Container(
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border(
                left: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: ListView.builder(
              itemCount: letters.length,
              itemBuilder: (context, index) {
                final letter = letters[index];
                return GestureDetector(
                  onTap: () => _onLetterSelected(letter),
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _selectedLetter == letter 
                          ? Colors.purple 
                          : Colors.transparent,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      letter.toUpperCase(),
                      style: TextStyle(
                        color: _selectedLetter == letter 
                            ? Colors.white 
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
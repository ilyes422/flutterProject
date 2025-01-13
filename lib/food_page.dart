import 'package:flutter/material.dart';
import 'package:flutter_application_1/form_add_resource.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'meals_details_page.dart';


class FoodPage extends StatefulWidget {
  final bool data;
  final String selectedValue;
  final String name;
  final String category;
  final String description;

  const FoodPage({
    super.key,
    this.data = true,
    required this.selectedValue,
    required this.name,
    required this.category,
    required this.description,
  });

  const FoodPage.empty({
    super.key,
    this.data = false,
    this.selectedValue = "",
    this.name = "",
    this.category = "",
    this.description = "",
  });

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  late Future<List<dynamic>> _futureMeals;
  String _searchQuery = '';
  String _selectedLetter = 'a';
  final List<String> letters = List.generate(26, (index) => String.fromCharCode(97 + index));

  @override
  void initState() {
    super.initState();
    _futureMeals = fetchMealsByFirstLetter(_selectedLetter);
  }

  Future<List<dynamic>> fetchMealsByFirstLetter(String letter) async {
     final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?f=$letter'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('ERROR.');
    }
  }

  Future<List<dynamic>> fetchMealsByName(String name) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$name'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception('ERROR.');
    }
  }

  Future<dynamic> fetchMealDetails(String id) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'] != null ? data['meals'][0] : null;
    } else {
      throw Exception('ERROR.');
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      if (_searchQuery.isEmpty) {
        _futureMeals = fetchMealsByFirstLetter(_selectedLetter);
      } else {
        _futureMeals = fetchMealsByName(_searchQuery);
      }
    });
  }

  void _onLetterSelected(String letter) {
    setState(() {
      _selectedLetter = letter;
      if (_searchQuery.isEmpty) {
        _futureMeals = fetchMealsByFirstLetter(letter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals available'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormAddResource(selectedValue: 'Meal')),
              );
            },
          ),
        ],
      ),
      body:Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Check the meals',
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
                        SizedBox(height: 16),
                        Card(
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            title: Text(
                              widget.name.isNotEmpty ? widget.name : 'Unknown food',
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
                    future: _futureMeals,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('ERROR : ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No meal found.'));
                      } else {
                        final meals = snapshot.data!;
                        return ListView.builder(
                          itemCount: meals.length,
                          itemBuilder: (context, index) {
                            final meal = meals[index];
                            return Card(
                              child: ListTile(
                                leading: meal['strMealThumb'] != null
                                    ? Hero(
                                      tag: meal['idMeal'], 
                                      child: Image.network(
                                        meal['strMealThumb'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ) 
                                    : Icon(Icons.fastfood),
                                title: Text(meal['strMeal'] ?? 'Unknown meal'),
                                subtitle:
                                    Text(meal['strCategory'] ?? 'Unknown category'),
                                onTap: () async {
                                  final mealDetails =
                                      await fetchMealDetails(meal['idMeal']);
                                  if (mealDetails != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MealDetailPage(mealDetails),
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
                          ? Colors.orange 
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

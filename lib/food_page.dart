import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodPage extends StatefulWidget {
  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  late Future<List<dynamic>> _futureMeals;
  String _searchQuery = ''; // Stocke la requête de recherche

  @override
  void initState() {
    super.initState();
    _futureMeals = fetchMealsByFirstLetter('a'); // Chargement initial avec 'a'
  }

  // Fonction pour récupérer les plats par la première lettre
  Future<List<dynamic>> fetchMealsByFirstLetter(String letter) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?f=$letter'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'] ?? []; // Retourne une liste vide si aucune donnée
    } else {
      throw Exception('Erreur lors du chargement des plats.');
    }
  }

  // Fonction pour rechercher des plats par nom
  Future<List<dynamic>> fetchMealsByName(String name) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$name'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'] ?? []; // Retourne une liste vide si aucune donnée
    } else {
      throw Exception('Erreur lors de la recherche des plats.');
    }
  }

  // Fonction pour récupérer les détails d'un plat par son ID
  Future<dynamic> fetchMealDetails(String id) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'] != null ? data['meals'][0] : null;
    } else {
      throw Exception('Erreur lors de la récupération des détails du plat.');
    }
  }

  // Gestion de la recherche
  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      if (_searchQuery.isEmpty) {
        // Recharge la liste initiale si aucun texte saisi
        _futureMeals = fetchMealsByFirstLetter('a');
      } else {
        // Recherche les plats par nom
        _futureMeals = fetchMealsByName(_searchQuery);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plats disponibles'),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Recherchez un plat...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _futureMeals,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Aucun plat trouvé.'));
                } else {
                  final meals = snapshot.data!;
                  return ListView.builder(
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return Card(
                        child: ListTile(
                          leading: meal['strMealThumb'] != null
                              ? Image.network(
                                  meal['strMealThumb'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.fastfood),
                          title: Text(meal['strMeal'] ?? 'Plat inconnu'),
                          subtitle: Text(meal['strCategory'] ?? 'Catégorie inconnue'),
                          onTap: () async {
                            final mealDetails = await fetchMealDetails(meal['idMeal']);
                            if (mealDetails != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MealDetailPage(mealDetails),
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

class MealDetailPage extends StatelessWidget {
  final dynamic mealDetails;

  MealDetailPage(this.mealDetails);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mealDetails['strMeal']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              mealDetails['strMealThumb'] != null
                  ? Image.network(mealDetails['strMealThumb'])
                  : Icon(Icons.fastfood, size: 100),
              SizedBox(height: 16),
              Text(
                'Catégorie: ${mealDetails['strCategory'] ?? 'Inconnue'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Description: ${mealDetails['strInstructions'] ?? 'Aucune description disponible.'}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CocktailDetailPage extends StatelessWidget {
  final dynamic cocktailDetails;

  CocktailDetailPage(this.cocktailDetails);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cocktailDetails['strDrink']),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              cocktailDetails['strDrinkThumb'] != null
                  ? Hero(
                      tag: cocktailDetails['idDrink'], 
                      child: Image.network(
                        cocktailDetails['strDrinkThumb']
                      ) 
                    )
                  : Icon(Icons.fastfood, size: 100),
              SizedBox(height: 16),
              Text(
                'Category: ${cocktailDetails['strCategory'] ?? 'Unknown'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Description: ${cocktailDetails['strInstructions'] ?? 'No description available.'}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

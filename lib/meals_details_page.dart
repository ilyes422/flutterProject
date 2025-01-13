import 'package:flutter/material.dart';

class MealDetailPage extends StatelessWidget {
  final dynamic mealDetails;

  MealDetailPage(this.mealDetails);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mealDetails['strMeal']),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              mealDetails['strMealThumb'] != null
                  ? Hero(
                    tag: mealDetails['idMeal'],
                    child:  Image.network(mealDetails['strMealThumb']
                    ),
                   )
                  : Icon(Icons.fastfood, size: 100),
              SizedBox(height: 16),
              Text(
                'Category: ${mealDetails['strCategory'] ?? 'Unknown Category'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Description: ${mealDetails['strInstructions'] ?? 'No description for this meal.'}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
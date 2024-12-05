import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
                  ? Image.network(mealDetails['strMealThumb'])
                  : Icon(Icons.fastfood, size: 100),
              SizedBox(height: 16),
              Text(
                'Categorie: ${mealDetails['strCategory'] ?? 'Unknown'}',
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
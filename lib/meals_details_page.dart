import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MealDetailPage extends StatelessWidget {
  final dynamic mealDetails;

  MealDetailPage(this.mealDetails);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(
        mealDetails['strMeal'],
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.orange,
      actions: [
        IconButton(
          icon: Icon(Icons.star_border, color: Colors.white),
          onPressed: () {
          },
        ),
      ],
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
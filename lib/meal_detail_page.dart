import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MealDetailPage extends StatelessWidget {
  final String mealId;
  MealDetailPage(this.mealId);

  @override
  Widget build(BuildContext context) {
    final apiUrl = 'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId';
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Detail'),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: http.get(Uri.parse(apiUrl)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load meal details'));
          }
          final meal = json.decode(snapshot.data!.body)['meals'][0];
          List<String> ingredients = [];
          for (int i = 1; i <= 20; i++) {
            if (meal['strIngredient$i'] != null && meal['strIngredient$i'].trim().isNotEmpty) {
              ingredients.add('${meal['strIngredient$i']} - ${meal['strMeasure$i']}');
            } else {
              break;
            }
          }

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: ListView(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200, // Set the height as needed
                  child: Image.network(
                    meal['strMealThumb'],
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  meal['strMeal'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Ingredients:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: ingredients.map((ingredient) {
                    return Text(ingredient);
                  }).toList(),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Instructions:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  meal['strInstructions'],
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 16.0),
              ],
            ),
          );
        },
      ),
    );
  }
}

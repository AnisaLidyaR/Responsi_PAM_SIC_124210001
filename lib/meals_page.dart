import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'meal_detail_page.dart';

class MealsByCategoryPage extends StatelessWidget {
  final String category;
  MealsByCategoryPage(this.category);

  @override
  Widget build(BuildContext context) {
    final apiUrl = 'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category';
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Meals'),
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
            return Center(child: Text('Failed to load meals'));
          }
          final meals = json.decode(snapshot.data!.body)['meals'];
          return ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealDetailPage(meal['idMeal']),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  child: Stack(
                    children: [
                      Image.network(
                        meal['strMealThumb'],
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Text(
                          meal['strMeal'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

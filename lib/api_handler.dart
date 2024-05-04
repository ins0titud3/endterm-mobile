import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

class Meal {
  final String name;
  final String imageUrl;
  final String category;
  final String instructions;
  final List<String> ingredients;
  int price;

  Meal({
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.instructions,
    required this.ingredients,
    required this.price, 
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    // Extract ingredients from JSON
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      if (json['strIngredient$i'] != null && json['strIngredient$i'].trim().isNotEmpty) {
        ingredients.add(json['strIngredient$i']);
      } else {
        break;
      }
    }

  
    int price = _generateRandomPrice();

    return Meal(
      name: json['strMeal'] ?? '',
      imageUrl: json['strMealThumb'] ?? '',
      category: json['strCategory'] ?? '',
      instructions: json['strInstructions'] ?? '',
      ingredients: ingredients,
      price: price, 
    );
  }


  static int _generateRandomPrice() {
    Random random = Random();
    return 1500 + random.nextInt(1001); 
  }
}

Future<Meal?> fetchRandomMeal() async {
  final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    if (data['meals'] != null && data['meals'].length > 0) {
      return Meal.fromJson(data['meals'][0]);
    }
  }

  return null;
}

Future<List<Meal>> fetchMealsByCategory(String category) async {
  final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=$category'));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    List<dynamic> mealsData = data['meals'];
    List<Meal> meals = mealsData.map((json) => Meal.fromJson(json)).toList();
    return meals;
  } else {
    throw Exception('Failed to load meals');
  }
}

// Класс для представления продукта в корзине
class CartProduct {
  final Meal meal;
  int quantity;

  CartProduct({required this.meal, this.quantity = 1});
}


Future<List<Meal>> searchMealsByName(String query) async {
  final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    if (data['meals'] != null) {
      List<dynamic> mealsData = data['meals'];
      List<Meal> meals = mealsData.map((e) => Meal.fromJson(e)).toList();
      return meals;
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load meals');
  }
}
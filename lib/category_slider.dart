import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_handler.dart'; // Import your API handler file

class CategorySlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      height: 40, // Height of the block
      child: ListView(
        scrollDirection: Axis.horizontal, // Horizontal scroll
        children: [
          buildCategoryButton('Breakfast', context),
          buildCategoryButton('Dessert', context),
          buildCategoryButton('Vegetarian', context),
          buildCategoryButton('Beef', context),
          buildCategoryButton('Chicken', context),
          buildCategoryButton('Side', context),
          buildCategoryButton('Seafood', context),
          buildCategoryButton('Pasta', context),
          buildCategoryButton('Other...', context),
          // Other categories
        ],
      ),
    );
  }

  Widget buildCategoryButton(String category, BuildContext context) {
    return Container(
      width: 120,
      margin: EdgeInsets.symmetric(horizontal: 10), // Spacing between elements
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:Color.fromARGB(255, 236, 236, 236),
          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17), // Rounded corners
          ),
        ),
        onPressed: () async {
          // Handle category selection
          List<Meal> meals = await fetchMealsByCategory(category);
          // Navigate to a new page to display meals from the selected category
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealsPage(meals: meals, category: category),
            ),
          );
        },
        child: Text(
          category,
          style: TextStyle(
            fontFamily: 'YandexSans',
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 0, 0, 0)
          ),
        ),
      ),
    );
  }
}

class MealsPage extends StatelessWidget {
  final List<Meal> meals;
  final String category;
  

  MealsPage({required this.meals, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 244, 242, 1),
      appBar: AppBar(
        title: Text(category), // Display the selected category as the page title
      ),
      body: ListView.builder(
        itemCount: meals.length,
        itemBuilder: (context, index) {
          Meal meal = meals[index];
          return Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(meal.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        meal.instructions.isNotEmpty ? meal.instructions : 'Lorem Ipsum', // Display meal instructions or "Lorem Ipsum" if empty
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          '${meal.price.toStringAsFixed(2)}₸', // Выводим цену с двумя десятичными знаками
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_handler.dart'; // Импортируйте обновленный файл обработчика API
import 'package:flutter_application_1/home_screen.dart'; // Импортируйте файл home_screen.dart для доступа к addToCart

class SearchResultsPage extends StatelessWidget {
  final List<Meal> searchResults;

  SearchResultsPage({required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 244, 242, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(245, 244, 242, 1),
        title: Text('Search Results'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              thickness: 0.4,
              color: Colors.grey,
              indent: 17,
              endIndent: 18,
            ),
            SizedBox(height: 20), // Отступ сверху
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Запрещаем прокрутку внутреннему ListView
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                Meal meal = searchResults[index];
                return GestureDetector(
                  onTap: () {
                    // Обработка нажатия на элемент поискового результата
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
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
                                  fontFamily: 'YandexSans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                meal.instructions ?? 'Lorem Ipsum', // Заполнение отсутствующего текста инструкции заполнителем
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      '${meal.price.toStringAsFixed(2)}₸', // Вывод цены с двумя десятичными знаками
                                      style: TextStyle(
                                        fontFamily: 'YandexSans',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Searcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search food...', // Search field placeholder
          hintStyle: TextStyle(
            fontFamily: 'YourFontFamily', // Specify your font family
            fontWeight: FontWeight.w300, // Light font weight
            fontSize: 16, // Text size
            color: const Color.fromARGB(255, 99, 99, 99), // Text color
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(19), // Rounded border
            borderSide: BorderSide(color: Colors.grey, width: 0.5),
          ),
          filled: false, // Fill the search field background
          fillColor: Color.fromARGB(255, 221, 217, 217), // Background color (grayish)
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          suffixIcon: IconButton(
            icon: Icon(Icons.search), // Search icon inside the field
            onPressed: () {
              // Handle search icon tap
              // Do nothing here as search is performed in the onSubmitted method below
            },
          ),
          suffixIconConstraints: BoxConstraints(
            minWidth: 30, // Minimum search icon width
            minHeight: 30, // Minimum search icon height
          ),
        ),
        onChanged: (value) {
          // Handle text changes in the search field
          // Add search logic here if needed
        },
        onSubmitted: (value) async {
          // Called when Enter or search button on keyboard is pressed
          List<Meal> searchResults = await searchMealsByName(value);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResultsPage(searchResults: searchResults),
            ),
          );
        },
      ),
    );
  }
}
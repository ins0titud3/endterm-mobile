# FoodApp

FoodApp is a mobile application built with Flutter and Dart that allows users to browse and discover various meals. The app fetches data from TheMealDB API to provide information about different categories of food.

## Features

- Browse meals by categories
- View detailed information about each meal
- Search for meals by name
- User-friendly interface with smooth navigation

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine.

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK: Comes pre-installed with Flutter
- A code editor (VS Code, Android Studio, etc.)

### Installation

1. Clone the repository:
 ```bash
   git clone https://github.com/yourusername/foodapp.git
   cd foodapp 
```
   

3. Install dependencies:
   ```bash
      flutter pub get
   ```

5. Run the app:
   ```bash
      flutter run
   ```

## API Integration

This app uses TheMealDB API to fetch meal data. The endpoint used is:
https://www.themealdb.com/api/json/v1/1/filter.php?c=$category
Replace $category with the desired food category (e.g., "Seafood", "Beef", etc.).

### Example Usage

To fetch meals of a specific category:
```
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> fetchMealsByCategory(String category) async {
  final response = await http.get('https://www.themealdb.com/api/json/v1/1/filter.php?c=$category');

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    // Process the data
  } else {
    throw Exception('Failed to load meals');
  }
}
```
## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

- Group: SE-2206
- Authors: Zhakiya Nurzhan & Bakeyeva Darina
- GitHub: [ins0titud3 & vuilae](https://github.com/ins0titud3 & https://github.com/vuilae)

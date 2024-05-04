import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_handler.dart'; // Импортируем файл с обработчиком API
import 'package:flutter_application_1/search_bar.dart'; // Импортируем файл с поисковым виджетом
import 'package:flutter_application_1/category_slider.dart'; // Импортируем файл с слайдером категорий

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dámdi',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Meal>> mealsFuture;
  bool _isSliderVisible = true; // Добавлено состояние для видимости слайдера

  // Список продуктов в корзине
  List<CartProduct> cartProducts = [];

  @override
  void initState() {
    super.initState();
    mealsFuture = fetchRandomMeals(); // Получаем случайные блюда при инициализации экрана
  }

  Future<List<Meal>> fetchRandomMeals() async {
    List<Meal> meals = [];
    // Используем API, чтобы получить список случайных блюд (25 для примера)
    for (int i = 1; i <= 30; i++) {
      Meal? meal = await fetchRandomMeal();
      if (meal != null) {
        meals.add(meal);
      }
    }
    return meals;
  }

  // Функция для добавления продукта в корзину
  void addToCart(Meal meal) {
    setState(() {
      // Проверяем, есть ли уже этот продукт в корзине
      int index = cartProducts.indexWhere((element) => element.meal.name == meal.name);
      if (index != -1) {
        // Если продукт уже есть, увеличиваем количество
        cartProducts[index].quantity++;
      } else {
        // Иначе добавляем новый продукт в корзину
        cartProducts.add(CartProduct(meal: meal));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 244, 242, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(245, 244, 242, 1),
        title: Row(
          children: [
            Text(
              'Dámdi',
              style: TextStyle(
                fontFamily: 'YandexSans',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10), // Пространство между названием и поисковым полем
            Searcher(), // Используем SearchBar из отдельного файла
          ],
        ),
        actions: [
          // Кнопка корзины
          IconButton(
            onPressed: () {
              // Переход к странице корзины при нажатии на кнопку
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(cartProducts: cartProducts)),
              );
            },
            icon: Icon(Icons.shopping_cart),
          ),
        ],
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
            Padding(
              padding: const EdgeInsets.only(top: 20), // Отступ сверху
              child: CategorySlider(),
            ),
            SizedBox(height: 14),
            FutureBuilder<List<Meal>>(
              future: mealsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return Center(child: Text('Error fetching data'));
                } else {
                  List<Meal> meals = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Запрещаем прокрутку внутреннему ListView
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      Meal meal = meals[index];
                      return GestureDetector(
                        
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
                                      meal.instructions,
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
                                            '${meal.price.toStringAsFixed(2)}₸', // Выводим цену с двумя десятичными знаками
                                            style: TextStyle(
                                              fontFamily: 'YandexSans',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            // Добавляем продукт в корзину при нажатии на плюсик
                                            addToCart(meal);
                                          },
                                          icon: Icon(Icons.add),
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
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  final List<CartProduct> cartProducts;

  CartPage({required this.cartProducts});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 244, 242, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(245, 244, 242, 1),
        title: Text('Shopping Cart'),
      ),
      body: ListView.builder(
        
        itemCount: widget.cartProducts.length,
        itemBuilder: (context, index) {
          CartProduct cartProduct = widget.cartProducts[index];
          return Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(cartProduct.meal.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Divider(
              thickness: 0.4,
              color: Colors.grey,
              indent: 17,
              endIndent: 18,
            ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartProduct.meal.name,
                        style: TextStyle(
                          fontFamily: 'YandexSans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        cartProduct.meal.instructions,
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
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (cartProduct.quantity > 1) {
                                      cartProduct.quantity--;
                                    } else {
                                      widget.cartProducts.removeAt(index);
                                    }
                                  });
                                },
                                icon: Icon(Icons.remove),
                              ),
                              Text(
                                '(${cartProduct.quantity})', // Показываем количество продукта в корзине
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Увеличиваем количество продукта на 1 при нажатии на кнопку плюса
                                  setState(() {
                                    cartProduct.quantity++;
                                  });
                                },
                                icon: Icon(Icons.add),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              '${cartProduct.meal.price.toStringAsFixed(2)}₸',
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
          );
        },
      ),
    );
  }
}


import 'package:flutter/material.dart';
import './favorite_meals.dart';
import './meal_categories.dart';

class TopTabBar extends StatelessWidget {
  static String routePath = '/toptabbar';
  final bool currentTheme;
  final Function switchTheme;
  const TopTabBar(
      {Key? key, required this.switchTheme, required this.currentTheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final applicationBar = AppBar(
        title: const Text('Meal Menu'),
        actions: [
          Switch(value: currentTheme, onChanged: (value) => switchTheme(value))
        ],
        bottom: const TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.star),
              text: 'Meal Categories',
            ),
            Tab(
              icon: Icon(Icons.category),
              text: 'Favorite Meals',
            ),
          ],
        ));
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: applicationBar,
          body: const TabBarView(children: [
            MealCategories(),
            FavoriteMeals(
              favoriteMeals: [],
            )
          ]),
        ));
  }
}

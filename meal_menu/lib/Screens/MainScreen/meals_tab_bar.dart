import 'package:flutter/material.dart';
import './favorite_meals.dart';
import './meal_categories.dart';
import './ChildWidgets/main_drawer.dart';

class MealsTabBar extends StatefulWidget {
  static String routePath = '/tabbar';
  final bool currentTheme;
  final Function switchTheme;
  const MealsTabBar(
      {Key? key, required this.switchTheme, required this.currentTheme})
      : super(key: key);

  @override
  State<MealsTabBar> createState() => _MealsTabBarState();
}

class _MealsTabBarState extends State<MealsTabBar> {
  final List<Map<String, Object>> tabs = [
    {
      'tab': const MealCategories(),
      'title': 'Meal Categories',
    },
    {
      'tab': const FavoriteMeals(),
      'title': 'Favorite Meals',
    },
  ];

  int selectedTabIndex = 0;

  void _selectTab(int index) {
    setState(
      () {
        selectedTabIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final applicationBar = AppBar(
      title: Text(tabs[selectedTabIndex]['title'].toString()),
      actions: [
        Switch(
            value: widget.currentTheme,
            onChanged: (value) => widget.switchTheme(value))
      ],
    );
    return Scaffold(
      appBar: applicationBar,
      drawer: MainDrawer(),
      body: tabs[selectedTabIndex]['tab'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectTab,
        currentIndex: selectedTabIndex,
        // selectedItemColor: Theme.of(context).primaryColor,
        // unselectedItemColor: Theme.of(context).secondaryHeaderColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Meal Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline),
            activeIcon: Icon(Icons.star),
            label: 'Favorite Meals',
          ),
        ],
      ),
    );
  }
}

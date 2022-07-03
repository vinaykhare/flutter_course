import 'package:flutter/material.dart';
import '../../Model/meal.dart';
import './favorite_meals.dart';
import './meal_categories.dart';
import './ChildWidgets/main_drawer.dart';

class MealsTabBar extends StatefulWidget {
  static String routePath = '/tabbar';

  final List<Meal> favoriteMeals;
  final Function switchTheme, toggleFavoriteMeal, isFavorite;
  final Map<String, bool> appPreferences;

  const MealsTabBar({
    Key? key,
    required this.switchTheme,
    required this.appPreferences,
    required this.toggleFavoriteMeal,
    required this.isFavorite,
    required this.favoriteMeals,
  }) : super(key: key);

  @override
  State<MealsTabBar> createState() => _MealsTabBarState();
}

class _MealsTabBarState extends State<MealsTabBar> {
  List<Map<String, Object>> tabs = [];

  int selectedTabIndex = 0;

  void _selectTab(int index) {
    setState(
      () {
        selectedTabIndex = index;
      },
    );
  }

  @override
  void initState() {
    super.initState();

    tabs = [
      {
        'tab': const MealCategories(),
        'title': 'Meal Categories',
      },
      {
        'tab': FavoriteMeals(
          favoriteMeals: widget.favoriteMeals,
        ),
        'title': 'Favorite Meals',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    bool themeMode = widget.appPreferences['theme'] ?? false;
    final applicationBar = AppBar(
      title: Text(tabs[selectedTabIndex]['title'].toString()),
      actions: [
        Switch(
            value: themeMode, onChanged: (value) => widget.switchTheme(value))
      ],
    );
    return Scaffold(
      appBar: applicationBar,
      drawer: const MainDrawer(),
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

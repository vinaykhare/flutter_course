import 'package:flutter/material.dart';
import '../../Model/meal.dart';
import './Screens/MealFilters/meal_filters.dart';
import './Screens/MainScreen/meals_tab_bar.dart';
//import './Screens/MainScreen/top_tab_bar.dart';
import './Screens/MealDetails/meal_detail_page.dart';
import './Screens/MealCategoryScreen/meal_category.dart';
//import './Screens/MainScreen/meal_categories.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  Map<String, bool> appPreferences = {
    'theme': false,
    'isGlutenFree': false,
    'isVegan': false,
    'isVegetarian': false,
    'isLactoseFree': false,
  };

  List<Meal> favoriteMeals = [];

  switchTheme(bool currentTheme) {
    setState(() {
      appPreferences['theme'] = currentTheme;
    });
  }

  void setFilterPreferences(updatedPreferences) {
    setState(
      () {
        appPreferences = updatedPreferences;
      },
    );
  }

  void toggleFavoriteMeal(Meal meal) {
    int mealIndex = favoriteMeals.indexWhere((m) => m.id == meal.id);

    setState(() {
      if (mealIndex < 0) {
        favoriteMeals.add(meal);
      } else {
        favoriteMeals.removeAt(mealIndex);
      }
    });
  }

  bool isFavorite(Meal meal) {
    return favoriteMeals.any((m) => m.id == meal.id);
  }

  @override
  Widget build(BuildContext context) {
    // MaterialColor darkColors = const MaterialColor(1, {
    //   50: Colors.black,
    //   100: Colors.black12,
    //   200: Colors.black26,
    //   300: Colors.black38,
    //   400: Colors.black45,
    //   500: Colors.black54,
    //   600: Colors.black87,
    //   700: Colors.grey,
    //   800: Color.fromRGBO(8, 4, 0, 1),
    //   900: Color.fromRGBO(4, 4, 0, 1),
    // });
    bool themeMode = appPreferences['theme'] ?? false;
    return MaterialApp(
      title: 'Meal Menu',
      debugShowCheckedModeBanner: false,
      theme: themeMode
          ? ThemeData(
              scaffoldBackgroundColor: Colors.black,
              colorScheme: const ColorScheme.dark(),
              appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
            )
          : ThemeData(
              primarySwatch: Colors.amber,
            ),
      // home: MealCategories(
      //   currentTheme: theme,
      //   switchTheme: switchTheme,
      // ),
      initialRoute: MealsTabBar.routePath,
      routes: {
        // MealCategories.routePath: (context) => const MealCategories(
        //       currentTheme: theme,
        //       switchTheme: switchTheme,
        //     ),
        MealCategory.routePath: (context) => MealCategory(
              appPreferences: appPreferences,
            ),
        MealDetailsPage.routePath: (context) => MealDetailsPage(
              isFavorite: isFavorite,
              toggleFavoriteMeal: toggleFavoriteMeal,
            ),
        // TopTabBar.routePath: (context) => TopTabBar(
        //       currentTheme: theme,
        //       switchTheme: switchTheme,
        //     ),
        MealsTabBar.routePath: (context) => MealsTabBar(
              appPreferences: appPreferences,
              switchTheme: switchTheme,
              favoriteMeals: favoriteMeals,
              toggleFavoriteMeal: toggleFavoriteMeal,
              isFavorite: isFavorite,
            ),
        MealFilters.routePath: (context) => MealFilters(
              appPreferences: appPreferences,
              setFilterPreferences: setFilterPreferences,
              switchTheme: switchTheme,
            ),
      },
    );
  }
}

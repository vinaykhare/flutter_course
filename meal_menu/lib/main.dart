import 'package:flutter/material.dart';
import './Screens/MainScreen/meals_tab_bar.dart';
import './Screens/MainScreen/top_tab_bar.dart';
import './Screens/MealDetails/meal_detail_page.dart';
import './Screens/MealCategoryScreen/meal_category.dart';
import './Screens/MainScreen/meal_categories.dart';

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

  bool darkTheme = false;
  switchTheme(bool currentTheme) {
    setState(() {
      darkTheme = currentTheme;
    });
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

    return MaterialApp(
      title: 'Meal Menu',
      debugShowCheckedModeBanner: false,
      theme: darkTheme
          ? ThemeData(
              scaffoldBackgroundColor: Colors.black,
              colorScheme: const ColorScheme.dark(),
              appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
            )
          : ThemeData(
              primarySwatch: Colors.amber,
            ),
      // home: MealCategories(
      //   currentTheme: darkTheme,
      //   switchTheme: switchTheme,
      // ),
      initialRoute: MealsTabBar.routePath,
      routes: {
        MealCategories.routePath: (context) => const MealCategories(
            //currentTheme: darkTheme,
            //switchTheme: switchTheme,
            ),
        MealCategory.routePath: (context) => const MealCategory(),
        MealDetailsPage.routePath: (context) => const MealDetailsPage(),
        TopTabBar.routePath: (context) => TopTabBar(
              currentTheme: darkTheme,
              switchTheme: switchTheme,
            ),
        MealsTabBar.routePath: (context) => MealsTabBar(
              currentTheme: darkTheme,
              switchTheme: switchTheme,
            ),
      },
    );
  }
}

// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../../Model/dummy_data.dart';
import './ChildWidgets/meal_category_item.dart';

class MealCategory extends StatelessWidget {
  static String routePath = '/meal_category_page';

  final Map<String, bool> appPreferences;
  //final String cateogryTitle;
  const MealCategory({
    Key? key,
    required this.appPreferences,
    //required this.cateogryTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final String cateogryTitle = routeArgs['title'] ?? "Default Value";
    final String categoryId = routeArgs['id'] ?? "Default Value";

    final categoryMeals = dummyMeals.where((meal) {
      return meal.categories.contains(categoryId) &&
          (appPreferences['isGlutenFree'] == false ||
              meal.isGlutenFree == appPreferences['isGlutenFree']) &&
          (appPreferences['isVegan'] == false ||
              meal.isVegan == appPreferences['isVegan']) &&
          (appPreferences['isVegetarian'] == false ||
              meal.isVegetarian == appPreferences['isVegetarian']) &&
          (appPreferences['isLactoseFree'] == false ||
              meal.isLactoseFree == appPreferences['isLactoseFree']);
    }).toList();

    for (var meal in categoryMeals) {
      print(
          '*************************************************************************');
      print('${meal.title} :');
      print(
          'isGlutenFree: ${meal.isGlutenFree} and ${appPreferences['isGlutenFree']}');
      print('isVegan: ${meal.isVegan} and ${appPreferences['isVegan']}');
      print(
          'isVegetarian: ${meal.isVegetarian} and ${appPreferences['isVegetarian']}');
      print(
          'isLactoseFree: ${meal.isLactoseFree} and ${appPreferences['isLactoseFree']}');
    }
    final pageBar = AppBar(
      title: Text(cateogryTitle),
    );
    final medQry = MediaQuery.of(context);
    double appHeight =
        medQry.size.height - pageBar.preferredSize.height - medQry.padding.top;

    return Scaffold(
      appBar: pageBar,
      body: SizedBox(
        height: appHeight,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return MealCategoryItem(
              title: categoryMeals[index].title,
              imageUrl: categoryMeals[index].imageUrl,
              duration: categoryMeals[index].duration,
              affordability: categoryMeals[index].affordability,
              complexity: categoryMeals[index].complexity,
              mealId: categoryMeals[index].id,
            );
          },
          itemCount: categoryMeals.length,
        ),
      ),
    );
  }
}

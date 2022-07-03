import 'package:flutter/material.dart';
import './ChildWidgets/meal_categories_item.dart';
import '../../Model/dummy_data.dart';

class MealCategories extends StatelessWidget {
  static String routePath = '/mealcategories';
  //final bool currentTheme;
  //final Function switchTheme;
  const MealCategories({
    Key? key,
    //required this.switchTheme,
    //required this.currentTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size mediaQuerySize = MediaQuery.of(context).size;
    // final applicationBar = AppBar(
    //   title: const Text('Meal Menu'),
    //   // actions: [
    //   //   Switch(value: currentTheme, onChanged: (value) => switchTheme(value))
    //   // ],
    // );
    return Scaffold(
      //appBar: applicationBar,
      body: GridView(
        //scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: mediaQuerySize.width * 0.50,
          childAspectRatio:
              (mediaQuerySize.width * 0.25) / (mediaQuerySize.height * 0.25),
          crossAxisSpacing: mediaQuerySize.width * 0.003,
          mainAxisSpacing: mediaQuerySize.height * 0.005,
          mainAxisExtent: mediaQuerySize.height * 0.25,
        ),
        children: dummyCategories
            .map(
              (category) => MealCategoriesItem(
                mealCat: category,
              ),
            )
            .toList(),
      ),
    );
  }
}

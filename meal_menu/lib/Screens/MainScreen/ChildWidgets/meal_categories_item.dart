import 'package:flutter/material.dart';
import '../../MealCategoryScreen/meal_category.dart';
import '../../../Model/category.dart';

class MealCategoriesItem extends StatelessWidget {
  final Category mealCat;
  const MealCategoriesItem({
    Key? key,
    required this.mealCat,
  }) : super(key: key);

  void navigateToCategoryPage(BuildContext context) {
    // Simple Route
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (_) {
    //       return MealCategoryPage(cateogryTitle: mealCat.title);
    //     },
    //   ),
    // );

    // Named Route
    Navigator.of(context).pushNamed(
      MealCategory.routePath,
      arguments: {
        'title': mealCat.title,
        'id': mealCat.id,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //ThemeData appTheme = Theme.of(context);
    return InkWell(
      onTap: () => navigateToCategoryPage(context),
      child: Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // appTheme.primaryColor,
              // appTheme.secondaryHeaderColor,
              mealCat.color,
              mealCat.color.withOpacity(0.5),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            mealCat.title,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      ),
    );
  }
}

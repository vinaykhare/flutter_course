import 'package:flutter/material.dart';
import '../MealCategoryScreen/ChildWidgets/meal_category_item.dart';
import '../../Model/meal.dart';

class FavoriteMeals extends StatelessWidget {
  final List<Meal> favoriteMeals;
  const FavoriteMeals({
    Key? key,
    required this.favoriteMeals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var meals = favoriteMeals.map((e) => e.title).toString();
    final pageBar = AppBar(
      title: const Text('Favorite Meals'),
    );
    final medQry = MediaQuery.of(context);
    double appHeight =
        medQry.size.height - pageBar.preferredSize.height - medQry.padding.top;
    return SizedBox(
      height: appHeight,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return MealCategoryItem(
            title: favoriteMeals[index].title,
            imageUrl: favoriteMeals[index].imageUrl,
            duration: favoriteMeals[index].duration,
            affordability: favoriteMeals[index].affordability,
            complexity: favoriteMeals[index].complexity,
            mealId: favoriteMeals[index].id,
          );
        },
        itemCount: favoriteMeals.length,
      ),
    );
  }
}

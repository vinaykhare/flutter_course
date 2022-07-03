import 'package:flutter/material.dart';
import './ChildWidgets/meal_category_item.dart';
import '../../Model/dummy_data.dart';

class MealCategory extends StatelessWidget {
  static String routePath = '/meal_category_page';
  //final String cateogryTitle;
  const MealCategory({
    Key? key,
    //required this.cateogryTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final String cateogryTitle = routeArgs['title'] ?? "Default Value";
    final String categoryId = routeArgs['id'] ?? "Default Value";

    final categoryMeals = dummyMeals.where((meal) {
      return meal.categories.contains(categoryId);
    }).toList();

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

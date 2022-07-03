import 'package:flutter/material.dart';
import '../../MealDetails/meal_detail_page.dart';
import '../../../HelperWidgets/icon_text_row_button.dart';
import '../../../Model/meal.dart';

class MealCategoryItem extends StatelessWidget {
  final String mealId;
  final String title;
  final String imageUrl;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;

  const MealCategoryItem({
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.complexity,
    required this.affordability,
    key,
    required this.mealId,
  }) : super(key: key);

  String get getAffordability {
    switch (affordability) {
      case Affordability.affordable:
        return 'Affordable';
      case Affordability.pricey:
        return 'Pricey';
      case Affordability.luxurious:
        return 'Luxurious';
    }
  }

  String get getComplexity {
    switch (complexity) {
      case Complexity.challenging:
        return 'Challenging';
      case Complexity.simple:
        return 'Simple';
      case Complexity.hard:
        return 'Hard';
    }
  }

  void navigateToMealDetailsPage(BuildContext context) {
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
      MealDetailsPage.routePath,
      arguments: mealId,
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData medQry = MediaQuery.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          InkWell(
            onTap: () => navigateToMealDetailsPage(context),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    // height: (medQry.size.height -
                    //     medQry.padding.top -
                    //     appHeight -
                    //     20),
                    width: medQry.size.width,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: medQry.size.width * 0.50,
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headline5,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconTextRowButton(
                  icon: Icons.timelapse,
                  buttonText: '$duration Minutes',
                ),
                IconTextRowButton(
                  icon: Icons.currency_rupee,
                  buttonText: getAffordability,
                ),
                IconTextRowButton(
                  icon: Icons.compare_arrows_outlined,
                  buttonText: getComplexity,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../Model/dummy_data.dart';
import '../../Model/meal.dart';

class MealDetailsPage extends StatelessWidget {
  static String routePath = '/meal_details_page';
  //final String cateogryTitle;
  const MealDetailsPage({
    Key? key,
    //required this.cateogryTitle,
  }) : super(key: key);

  Widget _buildContainerDescription(
      BuildContext context, double appWidth, String title, Widget content) {
    return Container(
      width: appWidth,
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headline6,
          ),
          content,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String mealId = ModalRoute.of(context)?.settings.arguments as String;
    Meal meal = dummyMeals.firstWhere((element) => element.id == mealId);

    final pageBar = AppBar(
      title: Text(meal.title),
    );

    String ingredientsString = meal.ingredients.toString().substring(1);
    ingredientsString =
        ingredientsString.substring(0, ingredientsString.length - 1);
    MediaQueryData medQry = MediaQuery.of(context);
    double appHeight = (medQry.size.height -
        pageBar.preferredSize.height -
        medQry.padding.top);
    double appWidth = medQry.size.width;
    return Scaffold(
      appBar: pageBar,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              SizedBox(
                height: appHeight * 0.35,
                width: medQry.size.width,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  child: Image.network(
                    meal.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              _buildContainerDescription(
                context,
                appWidth,
                'Ingredients',
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  child: Text(
                    ingredientsString,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              // Container(
              //   height: appHeight * 0.38,
              //   width: appWidth,
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       width: 5,
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
              _buildContainerDescription(
                context,
                appWidth,
                'Steps',
                SizedBox(
                  height: appHeight * 0.30,
                  child: ListView.builder(
                    itemCount: meal.steps.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                                child: Text((index + 1).toString())),
                            title: Text(
                              meal.steps.elementAt(index),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

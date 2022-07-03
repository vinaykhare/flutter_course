import 'package:flutter/material.dart';
import '../../MealFilters/meal_filters.dart';
import '../meals_tab_bar.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medQry = MediaQuery.of(context);
    final appTheme = Theme.of(context);
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: medQry.padding.top,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            child: Text(
              'Cooking Up!',
              style: appTheme.textTheme.headline3,
            ),
          ),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(MealsTabBar.routePath),
            leading: const Icon(Icons.home),
            title: Text(
              'Meal Categories',
              style: appTheme.textTheme.headline6,
            ),
          ),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(MealFilters.routePath),
            leading: const Icon(Icons.settings),
            title: Text(
              'Filters',
              style: appTheme.textTheme.headline6,
            ),
          ),
        ],
      ),
    );
  }
}

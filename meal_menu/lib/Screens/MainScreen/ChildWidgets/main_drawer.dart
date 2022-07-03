import 'package:flutter/material.dart';

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
            leading: const Icon(Icons.home),
            title: Text(
              'Meal Categories',
              style: appTheme.textTheme.headline6,
            ),
          ),
          ListTile(
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

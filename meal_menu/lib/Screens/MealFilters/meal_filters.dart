import 'package:flutter/material.dart';
import '../MainScreen/ChildWidgets/main_drawer.dart';

class MealFilters extends StatelessWidget {
  static String routePath = 'filters';

  final Map<String, bool> appPreferences;
  final Function switchTheme, setFilterPreferences;
  const MealFilters({
    Key? key,
    required this.appPreferences,
    required this.switchTheme,
    required this.setFilterPreferences,
  }) : super(key: key);

  @override
  Widget build(Object context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Filters'),
        ),
        drawer: const MainDrawer(),
        body: Column(
          children: [
            SwitchListTile(
              value: appPreferences['theme'] ?? false,
              title: const Text("Dark Theme"),
              onChanged: (val) => switchTheme(val),
            ),
            SwitchListTile(
              value: appPreferences['isGlutenFree'] ?? false,
              title: const Text("isGlutenFree"),
              onChanged: (val) {
                var appPref = appPreferences;
                appPreferences['isGlutenFree'] = val;
                setFilterPreferences(appPref);
              },
            ),
            SwitchListTile(
              value: appPreferences['isVegan'] ?? false,
              title: const Text("isVegan"),
              onChanged: (val) {
                var appPref = appPreferences;
                appPreferences['isVegan'] = val;
                setFilterPreferences(appPref);
              },
            ),
            SwitchListTile(
              value: appPreferences['isVegetarian'] ?? false,
              title: const Text("isVegetarian"),
              onChanged: (val) {
                var appPref = appPreferences;
                appPreferences['isVegetarian'] = val;
                setFilterPreferences(appPref);
              },
            ),
            SwitchListTile(
              value: appPreferences['isLactoseFree'] ?? false,
              title: const Text("isLactoseFree"),
              onChanged: (val) {
                var appPref = appPreferences;
                appPreferences['isLactoseFree'] = val;
                setFilterPreferences(appPref);
              },
            ),
          ],
        ));
  }
}

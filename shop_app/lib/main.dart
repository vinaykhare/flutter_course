import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_items.dart';

import './models/products.dart';
import './models/cart.dart';
import './screens/product_details.dart';
import './screens/products_overview.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'MyShop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.pink,
            accentColor: Colors.pinkAccent,
          ),
          fontFamily: 'Lato',
        ),
        //home: const ProductsOverview(),
        initialRoute: ProductsOverview.routePath,
        routes: {
          ProductDetails.routePath: (context) => const ProductDetails(),
          ProductsOverview.routePath: (context) => const ProductsOverview(),
          CartScreen.routePath: (context) => const CartScreen(),
        },
      ),
    );

    // return ChangeNotifierProvider(
    //   create: (context) => Products(),
    //   child: MaterialApp(
    //     title: 'MyShop',
    //     debugShowCheckedModeBanner: false,
    //     theme: ThemeData(
    //       colorScheme: ColorScheme.fromSwatch(
    //         primarySwatch: Colors.pink,
    //         accentColor: Colors.pinkAccent,
    //       ),
    //       fontFamily: 'Lato',
    //     ),
    //     //home: const ProductsOverview(),
    //     initialRoute: ProductsOverview.routePath,
    //     routes: {
    //       ProductDetails.routePath: (context) => const ProductDetails(),
    //       ProductsOverview.routePath: (context) => const ProductsOverview(),
    //       CartScreen.routePath: (context) => const CartScreen(),
    //     },
    //   ),
    // );
  }
}

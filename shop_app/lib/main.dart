import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';
import 'models/orders.dart';
import 'models/products.dart';
import 'screens/cart_items.dart';
import 'screens/orders_page.dart';
import 'screens/product_details.dart';
import 'screens/products_overview.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider.value(
        //   value: Products(),
        // ),
        // ChangeNotifierProvider.value(
        //   value: Cart(),
        // ),
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
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
          OrdersPage.routePath: (context) => const OrdersPage(),
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

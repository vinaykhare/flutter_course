// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

// import '../models/products.dart';
// import '../models/product.dart';
import '../models/cart.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';
import 'cart_items.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverview extends StatefulWidget {
  static String routePath = '/productoverview';

  const ProductsOverview({Key? key}) : super(key: key);

  @override
  State<ProductsOverview> createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  bool isFavoriteScreen = false;
  @override
  Widget build(BuildContext context) {
    //Cart cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              setState(
                () {
                  isFavoriteScreen = value == FilterOptions.favorites;
                },
              );
            },
            icon: const Icon(Icons.more_vert_sharp),
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: FilterOptions.favorites,
                  child: ListTile(
                    leading: Icon(Icons.folder_special),
                    title: Text('Favoriots'),
                  ),
                ),
                const PopupMenuItem(
                  value: FilterOptions.all,
                  child: ListTile(
                    leading: Icon(Icons.folder_shared),
                    title: Text('All Products'),
                  ),
                ),
              ];
            },
          ),
          // Badge(
          //   key: const Key("1"),
          //   value: cart.numberOfCartItems.toString(),
          //   color: Colors.brown,
          //   child: IconButton(
          //     onPressed: () {
          //       Navigator.of(context).pushNamed(CartScreen.routePath);
          //     },
          //     icon: const Icon(
          //       Icons.shopping_basket,
          //     ),
          //   ),
          // )
          Consumer<Cart>(
            builder: (ctx, cart, childWidget) {
              return Badge(
                value: cart.numberOfCartItems.toString(),
                color: Colors.brown,
                child: childWidget!,
              );
            },
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routePath);
              },
              icon: const Icon(
                Icons.shopping_basket,
              ),
            ),
          ),
        ],
      ),
      //drawer: const AppDrawer(),
      drawer: const AppDrawer(),
      body: ProductsGrid(isFavorite: isFavoriteScreen),
    );
  }
}

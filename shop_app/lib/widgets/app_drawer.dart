import 'package:flutter/material.dart';
import 'package:shop_app/screens/manage_products.dart';

import '../screens/cart_items.dart';
import '../screens/orders_page.dart';
import '../screens/products_overview.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Our Shop App'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.branding_watermark),
            title: const Text('Products'),
            onTap: () {
              Navigator.of(context).pushNamed(ProductsOverview.routePath);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopify),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context).pushNamed(OrdersPage.routePath);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_basket),
            title: const Text('Shopping Cart'),
            onTap: () {
              Navigator.of(context).pushNamed(CartScreen.routePath);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_basket),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.of(context).pushNamed(ManageProducts.routePath);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}

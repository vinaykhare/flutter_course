import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/manage_products.dart';

import '../models/auth_service.dart';
import '../screens/cart_items.dart';
import '../screens/orders_page.dart';
import '../screens/products_overview.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String email = Provider.of<AuthService>(context, listen: true).email;
    String name = email.split("@")[0].toUpperCase();
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: email == ""
                ? const Text('Our Shop App')
                : Text('$name\'s Shop App'),
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
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/");
              Provider.of<AuthService>(context, listen: false).logout();
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}

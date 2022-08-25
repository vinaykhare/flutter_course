import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/manage_product_item.dart';
import '../models/products.dart';
import 'add_edit_product.dart';

class ManageProducts extends StatefulWidget {
  static String routePath = "/manage-products";
  const ManageProducts({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ManageProductsState();
  }
}

class ManageProductsState extends State<ManageProducts> {
  Future<void> refershProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchaAllPrducts();
  }

  @override
  Widget build(BuildContext context) {
    Products products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddEditProduct.routePath);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => refershProducts(context),
        child: ListView.builder(
          itemCount: products.allProducts.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ManageProductItem(
                  product: products.allProducts[index],
                ),
                const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}

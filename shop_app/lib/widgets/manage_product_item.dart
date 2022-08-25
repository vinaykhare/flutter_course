import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/add_edit_product.dart';

import '../models/product.dart';
import '../models/products.dart';

class ManageProductItem extends StatelessWidget {
  final Product product;
  const ManageProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          product.imageUrl,
        ),
      ),
      title: Text(product.title),
      trailing: FittedBox(
        //width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AddEditProduct.routePath, arguments: product);
              },
              icon: const Icon(
                Icons.edit,
              ),
            ),
            IconButton(
              onPressed: () async {
                String? removeResponse =
                    await Provider.of<Products>(context, listen: false)
                        .removeProduct(product);
                if (removeResponse != null) {
                } else {}
              },
              icon: const Icon(
                Icons.remove_circle_outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

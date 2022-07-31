import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/products.dart';
import './product_item.dart';
import '../models/product.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    Key? key,
    required this.isFavorite,
  }) : super(key: key);

  final bool isFavorite;
  @override
  Widget build(BuildContext context) {
    Products productsListener = Provider.of<Products>(context);
    List<Product> products = isFavorite
        ? productsListener.favoriteProducts
        : productsListener.allProducts;
    final size = MediaQuery.of(context).size;
    return GridView.builder(
      //padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: size.width < 480 ? 2 : 4,
        crossAxisSpacing: size.width < 480 ? 2 : 4,
        mainAxisSpacing: size.width < 480 ? 2 : 4,
        childAspectRatio: 1,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: const ProductItem(
              //product: products[index],
              ),
        );
      },
    );
  }
}

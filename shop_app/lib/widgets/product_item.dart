import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/badge.dart';

import '../screens/product_details.dart';
import '../models/product.dart';
import '../models/cart.dart';

class ProductItem extends StatelessWidget {
  //final Product product;

  const ProductItem({
    super.key,
    //required this.product,
  });
  @override
  Widget build(BuildContext context) {
    Product product = Provider.of<Product>(context);
    Cart cart = Provider.of<Cart>(context);
    var scMessenger = ScaffoldMessenger.of(context);
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(ProductDetails.routePath, arguments: product),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Theme.of(context).bottomAppBarColor.withOpacity(0.7),
          leading: IconButton(
            onPressed: () async {
              String? response;
              response = await product.toggleFavorite(context);
              if (response != null) {
                scMessenger.clearSnackBars();
                scMessenger.showSnackBar(
                  SnackBar(
                    content: Text(response),
                  ),
                );
              }
            },
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            color: Theme.of(context).colorScheme.primary,
          ),
          title: Text(
            product.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          trailing: Badge(
            value: cart.getItemQuantityOf(product.id).toString(),
            color: Colors.red,
            child: IconButton(
              onPressed: () async {
                String? message = await cart.addItemToCart(product);
                scMessenger.hideCurrentSnackBar();
                scMessenger.showSnackBar(
                  SnackBar(
                    content: Text(message ?? "Item added to the Cart!"),
                    duration: const Duration(seconds: 5),
                  ),
                );
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.primary,
              ),
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: Hero(
            tag: product.id,
            child: product.imageUrl.startsWith("http")
                ? FadeInImage(
                    placeholder: const AssetImage(
                        "assets/images/product-placeholder.png"),
                    image: NetworkImage(product.imageUrl),
                    // child: Image.network(
                    //   product.imageUrl,
                    //   fit: BoxFit.cover,
                    // ),
                  )
                : FadeInImage(
                    placeholder: const AssetImage(
                        "assets/images/product-placeholder.png"),
                    //image: FileImage(File(product.imageUrl)),
                    image: MemoryImage(product.image),
                  ),
          ),
        ),
      ),
    );
  }
}

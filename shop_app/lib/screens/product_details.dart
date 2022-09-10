import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/product.dart';
import '../models/products.dart';
import '../widgets/badge.dart';
import 'cart_items.dart';

class ProductDetails extends StatelessWidget {
  static String routePath = '/productDetails';

  const ProductDetails({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context)!.settings.arguments as Product;
    Product providerProduct =
        Provider.of<Products>(context).findById(product.id);
    final appBarWidget = AppBar(
      title: Text(product.title),
    );
    final mq = MediaQuery.of(context);
    final appHeight = mq.size.height -
        mq.padding.top -
        appBarWidget.preferredSize.height -
        70;
    Cart cart = Provider.of<Cart>(context);
    ScaffoldMessengerState scMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      //appBar: appBarWidget,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: appHeight * 0.80,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.background,
            //collapsedHeight: appBarWidget.preferredSize.height,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                child: Text(
                  product.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              background: Hero(
                tag: product.id,
                child: product.imageUrl.startsWith("http")
                    ? Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                      )
                    : Image.memory(product.image),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: appHeight * 0.10,
                  width: double.infinity,
                  child: FittedBox(
                    child: Text(
                      '\$ ${product.price}/-',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: appHeight * 0.10,
                  width: double.infinity,
                  child: FittedBox(
                    child: Text(
                      product.description,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 1000,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.elliptical(0, 30)),
                    color: Theme.of(context).colorScheme.primary,
                    border: Border.all(
                      width: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      String? response = await product.toggleFavorite(context);
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
                      providerProduct.isFavorite
                          ? Icons.star
                          : Icons.star_border,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.elliptical(30, 0)),
                    color: Theme.of(context).colorScheme.primary,
                    border: Border.all(
                      width: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  child: IconButton(
                      onPressed: () async {
                        String? response;
                        response = await cart.addItemToCart(product);
                        scMessenger.clearSnackBars();
                        scMessenger.showSnackBar(
                          SnackBar(
                            content: Text(response ?? "Item Added to Cart"),
                          ),
                        );
                      },
                      icon: Icon(
                        cart.cartItems.containsKey(product.id)
                            ? Icons.shopping_bag
                            : Icons.shopping_bag_outlined,
                      )),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).colorScheme.inversePrimary,
              border: Border.all(
                width: 1.0,
                color: Colors.grey,
              ),
            ),
            child: Consumer<Cart>(
              builder: (ctx, cart, childWidget) {
                return Badge(
                  value: cart.cartItems[product.id]?.quantity.toString() ?? "0",
                  color: Colors.brown,
                  child: childWidget!,
                );
              },
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routePath);
                },
                icon: Icon(cart.cartItems.containsKey(product.id)
                    ? Icons.shopping_basket
                    : Icons.shopping_basket_outlined),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

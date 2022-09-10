import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
//import '../widgets/app_drawer.dart';
import '../models/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/cart_item.dart';
import '../widgets/saved_for_later_item.dart';
import 'address_page.dart';

class CartScreen extends StatelessWidget {
  static String routePath = '/cartscreen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final mq = MediaQuery.of(context);
    final cart = Provider.of<Cart>(context);
    //cart.fetchaAllCartItems();
    var appBarWidget = AppBar(
      title: const Text('Cart Items'),
    );
    //final appHeight =        mq.size.height - mq.padding.top - appBarWidget.preferredSize.height;
    ScaffoldMessengerState scMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: appBarWidget,
      drawer: const AppDrawer(),
      body: Column(
        children: <Widget>[
          Card(
            //margin: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    cart.cartTotal.toStringAsFixed(2),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                TextButton(
                  onPressed: cart.cartTotal > 0
                      ? () {
                          Navigator.of(context)
                              .pushNamed(AddressPage.routePath);
                        }
                      : null,
                  child: const Text('Place Order'),
                )
              ],
            ),
          ),
          //const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.cartItems.length,
              itemBuilder: (ctx, i) => CartItem(
                Provider.of<Products>(context, listen: false)
                    .findById(cart.cartItems.keys.toList()[i]),
                allowEdit: true,
              ),
            ),
          ),
          if (cart.savedForLater.isNotEmpty)
            Card(
              //margin: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Saved For Later',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const Spacer(),
                  TextButton(
                    child: const Text('Add All Back to Cart'),
                    onPressed: () async {
                      String? response;
                      response = await cart.addAllItemToCartFromSaveForLater();
                      scMessenger.clearSnackBars();
                      scMessenger.showSnackBar(
                        SnackBar(
                          content: Text(response ??
                              "All Items saved for later are Added to Cart"),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          if (cart.savedForLater.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: cart.savedForLater.length,
                itemBuilder: (ctx, i) => SavedForLater(
                  savedForLaterItem:
                      Provider.of<Products>(context, listen: false)
                          .findById(cart.savedForLater.keys.toList()[i]),
                ),
              ),
            )
        ],
      ),
    );
  }
}

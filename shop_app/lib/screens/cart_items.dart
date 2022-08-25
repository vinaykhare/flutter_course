import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';
import '../models/orders.dart';
//import '../widgets/app_drawer.dart';
//import '../models/product.dart';
import '../widgets/app_drawer.dart';
import '../widgets/cart_item.dart';
import '../widgets/saved_for_later_item.dart';
import 'orders_page.dart';

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
    var scMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: appBarWidget,
      drawer: const AppDrawer(),
      body: Center(
        child: SizedBox(
          //height: appHeight,
          //width: mq.size.width < 450 ? mq.size.width : mq.size.width / 2,
          child: Column(
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
                              showDialog(
                                context: context,
                                builder: (ctx) {
                                  var navigatorCtx = Navigator.of(ctx);
                                  var navigatorContext = Navigator.of(context);
                                  return AlertDialog(
                                    title: const Text("Are you Sure?"),
                                    content: const Text(
                                        "Are you sure about placing this order?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          String message =
                                              await Provider.of<Orders>(context,
                                                      listen: false)
                                                  .addOrder(cart);

                                          scMessenger.hideCurrentSnackBar();
                                          scMessenger.showSnackBar(
                                            SnackBar(
                                              content: Text(message),
                                              duration:
                                                  const Duration(seconds: 5),
                                            ),
                                          );
                                          navigatorCtx.pop(true);

                                          if (message ==
                                                  "Order Placed Successfully!" &&
                                              cart.clearCart()) {
                                            navigatorContext.pushNamed(
                                                OrdersPage.routePath);
                                          } else {
                                            scMessenger.hideCurrentSnackBar();
                                            scMessenger.showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text("Cannot Clear Cart"),
                                                duration: Duration(seconds: 5),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text("Yes"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop(false);
                                        },
                                        child: const Text("No"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          : null,
                      child: const Text('ORDER NOW'),
                    )
                  ],
                ),
              ),
              //const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: cart.cartItems.length,
                  itemBuilder: (ctx, i) => CartItem(
                    cart.cartItems.values.toList()[i],
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
                        onPressed: () {
                          cart.addAllItemToCartFromSaveForLater();
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
                      savedForLaterItem: cart.savedForLater.values.toList()[i],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

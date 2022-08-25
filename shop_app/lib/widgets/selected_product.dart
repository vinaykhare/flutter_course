import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';

import '../models/cart.dart';

class SelectedProducts extends StatelessWidget {
  const SelectedProducts({
    Key? key,
    required this.cartItem,
    required this.allowEdit,
    required this.scMessenger,
  }) : super(key: key);

  final Product cartItem;
  final bool allowEdit;
  final ScaffoldMessengerState scMessenger;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: ListTile(
        leading: CircleAvatar(
          // child: Padding(
          //   padding: const EdgeInsets.all(5),
          //   child: FittedBox(child: Image.network(cartItem.imageUrl)),
          // ),
          backgroundImage: NetworkImage(cartItem.imageUrl),
        ),
        title: Text(cartItem.title),
        subtitle: Text('Total: \$${(cartItem.price * cartItem.quantity)}'),
        trailing: FittedBox(
          child: Consumer<Cart>(
            builder: (context, cart, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (allowEdit)
                    IconButton(
                      onPressed: () async {
                        String message =
                            await cart.removeSingleItemFromCart(cartItem);
                        scMessenger.hideCurrentSnackBar();
                        scMessenger.showSnackBar(
                          SnackBar(
                            content: Text(message),
                            duration: const Duration(seconds: 5),
                            action: SnackBarAction(
                              label: "UNDO",
                              onPressed: () {
                                cart.addItemToCart(cartItem);
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.remove),
                    ),
                  Text('${cartItem.quantity}'),
                  if (allowEdit)
                    IconButton(
                      onPressed: () async {
                        String message = await cart.addItemToCart(cartItem);
                        scMessenger.hideCurrentSnackBar();
                        scMessenger.showSnackBar(
                          SnackBar(
                            content: Text(message),
                            duration: const Duration(seconds: 5),
                            action: SnackBarAction(
                              label: "UNDO",
                              onPressed: () {
                                cart.removeSingleItemFromCart(cartItem);
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

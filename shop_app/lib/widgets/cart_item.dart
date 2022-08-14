import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';

import '../models/cart.dart';

class CartItem extends StatelessWidget {
  final Product cartItem;
  final bool allowEdit;
  const CartItem(this.cartItem, {Key? key, required this.allowEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            color: Theme.of(context).hintColor,
            alignment: Alignment.centerLeft,
            //padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4,
            ),
            child: const Icon(
              Icons.watch_later,
              color: Colors.white,
              size: 40,
            ),
          ),
          Container(
            color: Theme.of(context).errorColor,
            alignment: Alignment.centerRight,
            //padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4,
            ),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
      //direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          Provider.of<Cart>(context, listen: false)
              .addItemToSaveForLater(cartItem);
        }
        String message = Provider.of<Cart>(context, listen: false)
            .removeItemFromCart(cartItem.id);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 5),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(child: Image.network(cartItem.imageUrl)),
            ),
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
                        onPressed: () {
                          String message =
                              cart.removeSingleItemFromCart(cartItem.id);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
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
                        onPressed: () {
                          String message = cart.addItemToCart(cartItem);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              duration: const Duration(seconds: 5),
                              action: SnackBarAction(
                                label: "UNDO",
                                onPressed: () {
                                  cart.removeSingleItemFromCart(cartItem.id);
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
      ),
    );
  }
}

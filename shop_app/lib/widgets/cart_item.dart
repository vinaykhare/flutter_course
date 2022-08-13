import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';

import '../models/cart.dart';

class CartItem extends StatelessWidget {
  final Product cartItem;
  const CartItem(this.cartItem, {Key? key}) : super(key: key);

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
        Provider.of<Cart>(context, listen: false)
            .removeItemFromCart(cartItem.id);
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
            child: Text('${cartItem.quantity}'),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';

import '../models/cart.dart';
import 'selected_product.dart';

class CartItem extends StatelessWidget {
  final Product cartItem;
  final bool allowEdit;
  const CartItem(this.cartItem, {Key? key, required this.allowEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scMessenger = ScaffoldMessenger.of(context);
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
      onDismissed: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          Provider.of<Cart>(context, listen: false)
              .addItemToSaveForLater(cartItem);
        }
        String message = await Provider.of<Cart>(context, listen: false)
            .removeItemFromCart(cartItem);
        scMessenger.hideCurrentSnackBar();
        scMessenger.showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 5),
          ),
        );
      },
      child: SelectedProducts(
        cartItem: cartItem,
        allowEdit: allowEdit,
        scMessenger: scMessenger,
      ),
    );
  }
}

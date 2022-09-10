import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/products.dart';

import '../models/cart.dart';
import '../models/product.dart';
import '../screens/product_details.dart';

class SelectedProducts extends StatelessWidget {
  const SelectedProducts({
    Key? key,
    required this.product,
    required this.allowEdit,
    required this.scMessenger,
  }) : super(key: key);

  final Product product;
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
        onTap: () => Navigator.of(context).pushNamed(
          ProductDetails.routePath,
          arguments: Provider.of<Products>(context, listen: false).findById(
            product.id,
          ),
        ),
        leading: product.imageUrl.startsWith("http")
            ? CircleAvatar(
                // child: Padding(
                //   padding: const EdgeInsets.all(5),
                //   child: FittedBox(child: Image.network(product.imageUrl)),
                // ),
                backgroundImage: NetworkImage(product.imageUrl),
              )
            : CircleAvatar(
                // child: Padding(
                //   padding: const EdgeInsets.all(5),
                //   child: FittedBox(child: Image.network(product.imageUrl)),
                // ),
                //backgroundImage: FileImage(File(product.imageUrl)),
                backgroundImage: MemoryImage(product.image, scale: 10.0),
                // backgroundImage:
                //     AssetImage('assets/images/product-placeholder.png'),
              ),
        title: Text(product.title),
        subtitle: Text('Total: \$${(product.price * product.quantity)}'),
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
                        String? message =
                            await cart.removeSingleItemFromCart(product);
                        scMessenger.hideCurrentSnackBar();
                        scMessenger.showSnackBar(
                          SnackBar(
                            content: Text(message ?? "Item removed from Cart"),
                            duration: const Duration(seconds: 5),
                            action: SnackBarAction(
                              label: "UNDO",
                              onPressed: () {
                                //cart.addItemToCart(product);
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.remove),
                    ),
                  Text('${cart.cartItems[product.id]?.quantity ?? 0}'),
                  if (allowEdit)
                    IconButton(
                      onPressed: () async {
                        //await cart.addItemToCart(product);
                        String? message = await cart.addItemToCart(product);
                        scMessenger.hideCurrentSnackBar();
                        scMessenger.showSnackBar(
                          SnackBar(
                            content: Text(message ?? "Item Added to the Cart"),
                            duration: const Duration(seconds: 5),
                            action: SnackBarAction(
                              label: "UNDO",
                              onPressed: () {
                                cart.removeSingleItemFromCart(product);
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

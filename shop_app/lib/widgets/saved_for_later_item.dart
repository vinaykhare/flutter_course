import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../models/product.dart';

class SavedForLater extends StatelessWidget {
  final Product savedForLaterItem;

  const SavedForLater({required this.savedForLaterItem, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    return Card(
      child: ListTile(
        leading: savedForLaterItem.imageUrl.startsWith("http")
            ? CircleAvatar(
                backgroundImage: NetworkImage(savedForLaterItem.imageUrl),
                // child: Padding(
                //   padding: const EdgeInsets.all(5),
                //   child: FittedBox(child: Image.network(savedForLaterItem.imageUrl)),
                // ),
              )
            : const CircleAvatar(
                //backgroundImage: FileImage(File(savedForLaterItem.imageUrl)),
                //backgroundImage: MemoryImage(savedForLaterItem.image),
                backgroundImage:
                    AssetImage('assets/images/product-placeholder.png'),
                // child: Padding(
                //   padding: const EdgeInsets.all(5),
                //   child: FittedBox(child: Image.network(savedForLaterItem.imageUrl)),
                // ),
              ),
        title: Text(savedForLaterItem.title),
        subtitle: Text(
          'Total: \$${(savedForLaterItem.price * savedForLaterItem.quantity)}',
        ),
        trailing: FittedBox(
          child: Row(
            children: [
              IconButton(
                onPressed: () =>
                    cart.addItemToCartFromSaveForLater(savedForLaterItem),
                icon: const Icon(Icons.move_up),
              ),
              IconButton(
                onPressed: () =>
                    cart.removeItemFromSavedForLater(savedForLaterItem.id),
                icon: const Icon(Icons.delete_forever),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

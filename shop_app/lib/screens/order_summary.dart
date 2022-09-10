import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../models/cart_item.dart';
import '../models/orders.dart';
import '../models/address.dart';
import '../models/products.dart';
import '../widgets/selected_product.dart';
import 'orders_page.dart';

class OrderSummary extends StatelessWidget {
  static String routePath = "/order_summary";
  const OrderSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScaffoldMessengerState scMessenger = ScaffoldMessenger.of(context);
    NavigatorState navContext = Navigator.of(context);
    Address address = ModalRoute.of(context)?.settings.arguments as Address;
    Map<String, CartItem> cartitems = Provider.of<Cart>(context).cartItems;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Summary",
        ),
      ),
      body: Card(
        elevation: 4,
        borderOnForeground: true,
        color: Theme.of(context).colorScheme.background.withOpacity(0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Following Products",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: cartitems.values.toList().length,
                  itemBuilder: (context, index) {
                    return SelectedProducts(
                      product: Provider.of<Products>(context, listen: false)
                          .findById(
                        cartitems.keys.toList()[index],
                      ),
                      allowEdit: false,
                      scMessenger: scMessenger,
                    );
                  }),
            ),
            const Divider(),
            Text(
              "Will be Deliverd to following Address",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
            Expanded(
              child: Card(
                elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${address.houseNo}",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      "${address.addressLine}",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      "Near ${address.landmark}",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      "${address.city} - ${address.pincode}",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      "${address.state}",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Cart cart = Provider.of<Cart>(context, listen: false);
                String? response =
                    await Provider.of<Orders>(context, listen: false)
                        .addOrder(cart, address);
                if (response != null) {
                  scMessenger.hideCurrentSnackBar();
                  scMessenger.showSnackBar(
                    SnackBar(
                      content: Text(response),
                    ),
                  );
                } else {
                  String? clearCartResponse;

                  clearCartResponse = await cart.clearCart();
                  if (clearCartResponse != null) {
                    scMessenger.hideCurrentSnackBar();
                    scMessenger.showSnackBar(
                      SnackBar(
                        content: Text(clearCartResponse),
                      ),
                    );
                  } else {
                    navContext.pushReplacementNamed(OrdersPage.routePath);
                  }
                }
              },
              icon: const Icon(Icons.card_giftcard_sharp),
              label: const Text("Confirm Order"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'orders_page.dart';

class OrderSummary extends StatelessWidget {
  static String routePath = "/order_summary";
  const OrderSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Summary"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_location_alt_rounded),
          )
        ],
      ),
      body: Column(
        children: [
          Column(
            children: const [
              Card(
                child: Text('Cart Item 1'),
              ),
              Card(
                child: Text('Cart Item 2'),
              )
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context)
                .pushReplacementNamed(OrdersPage.routePath),
            icon: const Icon(Icons.card_giftcard_sharp),
            label: const Text("Confirm Order"),
          ),
        ],
      ),
    );
  }
}

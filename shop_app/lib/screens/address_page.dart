import 'package:flutter/material.dart';
import 'order_summary.dart';

class AddressPage extends StatelessWidget {
  static String routePath = "/address_page";
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Address"),
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
                child: Text('Address 1'),
              ),
              Card(
                child: Text('Address 2'),
              )
            ],
          ),
          ElevatedButton.icon(
            onPressed: () =>
                Navigator.of(context).pushNamed(OrderSummary.routePath),
            icon: const Icon(Icons.location_pin),
            label: const Text("Confirm Address"),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/orders.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
//import '../widgets/app_drawer.dart';

class OrdersPage extends StatelessWidget {
  static String routePath = "/orders";
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Orders orders = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      drawer: const AppDrawer(),
      body: SizedBox(
        height: 500,
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Text("Error on loading Orders");
            } else {
              return Consumer<Orders>(
                builder: (context, orders, child) => ListView.builder(
                  itemCount: orders.allOrders.length,
                  itemBuilder: (ctx, index) {
                    return OrderItem(order: orders.allOrders[index]);
                  },
                ),
              );
            }
          },
          future: Provider.of<Orders>(context, listen: false).fetchaAllOrders(),
        ),
      ),
    );
  }
}

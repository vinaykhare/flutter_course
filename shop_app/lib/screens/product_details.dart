import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetails extends StatelessWidget {
  static String routePath = '/productDetails';

  const ProductDetails({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context)!.settings.arguments as Product;
    final appBarWidget = AppBar(
      title: Text(product.title),
    );
    final bottomBarWidget = BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.star,
          ),
          label: 'Add to Favorites',
          backgroundColor: Colors.amber,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_bag,
          ),
          label: 'Add to Cart',
          backgroundColor: Colors.amber,
        )
      ],
    );
    final mq = MediaQuery.of(context);
    final appHeight = mq.size.height -
        mq.padding.top -
        appBarWidget.preferredSize.height -
        70;
    return Scaffold(
      //appBar: appBarWidget,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: appHeight * 0.80,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.background,
            //collapsedHeight: appBarWidget.preferredSize.height,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                child: Text(
                  product.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: appHeight * 0.10,
                  width: double.infinity,
                  child: FittedBox(
                    child: Text(
                      '\$ ${product.price}/-',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: appHeight * 0.10,
                  width: double.infinity,
                  child: FittedBox(
                    child: Text(
                      product.description,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 1000,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: bottomBarWidget,
      ),
    );
  }
}

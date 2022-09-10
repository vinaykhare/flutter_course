import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

// import '../models/products.dart';
// import '../models/product.dart';
import '../models/cart.dart';
//import '../models/orders.dart';
import '../models/products.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';
import 'cart_items.dart';
import 'search_products.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverview extends StatefulWidget {
  static String routePath = '/productoverview';

  const ProductsOverview({Key? key}) : super(key: key);

  @override
  State<ProductsOverview> createState() => _ProductsOverviewState();
}

class _ProductsOverviewState extends State<ProductsOverview> {
  bool isFavoriteScreen = false;
  bool isInit = true;
  bool isLoading = true;

  Future<void> refershProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAllProducts();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      Products products = Provider.of<Products>(context, listen: false);
      Cart cart = Provider.of<Cart>(context, listen: false);

      products.fetchAllProducts().then(
            (value) => setState(
              () {
                isLoading = false;
              },
            ),
          );

      cart.fetchaAllCartItems();
      isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //Cart cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 70,
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            //enabled: false,
            keyboardType: TextInputType.none,
            showCursor: false,
            onTap: () =>
                Navigator.of(context).pushNamed(SearchProducts.routePath),
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              suffixIcon: Icon(Icons.mic),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
        ),
      ),
      //drawer: const AppDrawer(),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => refershProducts(context),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(isFavorite: isFavoriteScreen),
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.elliptical(0, 30)),
                      color: Theme.of(context).colorScheme.primary,
                      border: Border.all(
                        width: 1.0,
                        color: Colors.grey,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.donut_large),
                      onPressed: () {},
                    )),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.elliptical(30, 0)),
                    color: Theme.of(context).colorScheme.primary,
                    border: Border.all(
                      width: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  child: PopupMenuButton(
                    onSelected: (value) {
                      setState(
                        () {
                          isFavoriteScreen = value == FilterOptions.favorites;
                        },
                      );
                    },
                    icon: const Icon(Icons.more_vert_sharp),
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: FilterOptions.favorites,
                          child: ListTile(
                            leading: Icon(Icons.folder_special),
                            title: Text('Favoriots'),
                          ),
                        ),
                        const PopupMenuItem(
                          value: FilterOptions.all,
                          child: ListTile(
                            leading: Icon(Icons.folder_shared),
                            title: Text('All Products'),
                          ),
                        ),
                      ];
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).colorScheme.inversePrimary,
              border: Border.all(
                width: 1.0,
                color: Colors.grey,
              ),
            ),
            child: Consumer<Cart>(
              builder: (ctx, cart, childWidget) {
                return Badge(
                  value: cart.cartItems.length.toString(),
                  color: Colors.brown,
                  child: childWidget!,
                );
              },
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routePath);
                },
                icon: const Icon(
                  Icons.shopping_basket,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

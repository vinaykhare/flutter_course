import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/user_address.dart';

import 'helper/page_transition_builder.dart';
import 'models/auth_service.dart';
import 'models/cart.dart';
import 'models/orders.dart';
import 'models/products.dart';
import 'models/integrate_firebase.dart';
import 'screens/add_edit_address.dart';
import 'screens/auth_screen.dart';
import 'screens/cart_items.dart';
import 'screens/orders_page.dart';
import 'screens/product_details.dart';
import 'screens/products_overview.dart';
import 'screens/manage_products.dart';
import 'screens/add_edit_product.dart';
import 'screens/splash_screen.dart';
import 'screens/address_page.dart';
import 'screens/order_summary.dart';
import 'screens/search_products.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider.value(
        //   value: Products(),
        // ),
        // ChangeNotifierProvider.value(
        //   value: Cart(),
        // ),
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProxyProvider<AuthService, IntegrateFirebase>(
          create: (context) => IntegrateFirebase(
            Provider.of<AuthService>(context, listen: false),
          ),
          update: (context, authService, prevProduct) =>
              IntegrateFirebase(authService),
        ),
        ChangeNotifierProvider(
          create: (context) => UserAddress(context),
        ),
        ChangeNotifierProvider(
          create: (context) => Products(context),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(context),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(context),
        ),
      ],
      child: Consumer<AuthService>(
        builder: (context, authService, child) => MaterialApp(
          title: 'Shop App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.pink,
              accentColor: Colors.pinkAccent,
            ),
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: MyPagetTransitionBuilder(),
                TargetPlatform.iOS: MyPagetTransitionBuilder(),
              },
            ),
          ),
          home: authService.token != null
              ? const ProductsOverview()
              : FutureBuilder(
                  future: authService.autoLogin(),
                  builder: (ctx, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const SplashScreen();
                    } else {
                      return const AuthScreen();
                    }
                  },
                ),
          // initialRoute: authService.token != null
          //     ? ProductsOverview.routePath
          //     : AuthScreen.routePath,
          routes: {
            ProductDetails.routePath: (context) => const ProductDetails(),
            ProductsOverview.routePath: (context) => const ProductsOverview(),
            CartScreen.routePath: (context) => const CartScreen(),
            OrdersPage.routePath: (context) => const OrdersPage(),
            ManageProducts.routePath: (context) => const ManageProducts(),
            AddEditProduct.routePath: (context) => const AddEditProduct(),
            AddEditAddress.routePath: (context) => const AddEditAddress(),
            AuthScreen.routePath: (context) => const AuthScreen(),
            AddressPage.routePath: (context) => const AddressPage(),
            OrderSummary.routePath: (context) => const OrderSummary(),
            SearchProducts.routePath: (context) => const SearchProducts(),
          },
        ),
      ),
    );

    // return ChangeNotifierProvider(
    //   create: (context) => Products(),
    //   child: MaterialApp(
    //     title: 'MyShop',
    //     debugShowCheckedModeBanner: false,
    //     theme: ThemeData(
    //       colorScheme: ColorScheme.fromSwatch(
    //         primarySwatch: Colors.pink,
    //         accentColor: Colors.pinkAccent,
    //       ),
    //       fontFamily: 'Lato',
    //     ),
    //     //home: const ProductsOverview(),
    //     initialRoute: ProductsOverview.routePath,
    //     routes: {
    //       ProductDetails.routePath: (context) => const ProductDetails(),
    //       ProductsOverview.routePath: (context) => const ProductsOverview(),
    //       CartScreen.routePath: (context) => const CartScreen(),
    //     },
    //   ),
    // );
  }
}

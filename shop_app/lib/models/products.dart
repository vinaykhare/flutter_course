import 'package:flutter/material.dart';
import './integrate_firebase.dart';

import './product.dart';
//import 'my_exception.dart';

class Products with ChangeNotifier {
  String urlStr = '/products';

  List<Product> products = [];

  List<Product> get allProducts {
    return [...products];
  }

  List<Product> get favoriteProducts {
    return products
        .where(
          (element) => element.isFavorite == true,
        )
        .toList();
  }

  Future<String?> addUpdateProduct(Product product) async {
    int productIndex =
        products.indexWhere((element) => element.id == product.id);
    String? productId = await addUpdateProductInFirebase(product);
    if (productId != null && productId.startsWith("Error:")) {
      return productId;
    }
    if (productIndex == -1) {
      product.setId = productId;
      products.add(product);
    } else {
      products[productIndex] = product;
    }
    notifyListeners();
    return null;
  }

  Future<String?> addUpdateProductInFirebase(Product product) async {
    int productIndex =
        products.indexWhere((element) => element.id == product.id);
    String productId;
    var data = {
      "title": product.title,
      "description": product.description,
      "imageUrl": product.imageUrl,
      "price": product.price,
    };

    if (productIndex == -1) {
      productId = await postPatchFirebase(data, urlStr, 0);
    } else {
      productId = await postPatchFirebase(data, "$urlStr/${product.id}", 1);
    }
    return productId;
  }

  Future<String> postPatchFirebase(
      Map<String, dynamic> data, String url, int type) async {
    IntegrateFirebase firebase = IntegrateFirebase(url);
    Map<String, dynamic> patchPostResponse =
        type == 0 ? await firebase.post(data) : await firebase.patch(data);
    if (patchPostResponse.containsKey("errorMessage")) {
      return patchPostResponse["errorMessage"];
    }
    return patchPostResponse["name"];
  }

  Future<String?> removeProduct(Product product) async {
    int productIndex =
        products.indexWhere((element) => element.id == product.id);
    products.removeAt(productIndex);
    //print("Product Length ${products.length} after removing");
    String? message = await removeProductInFirebase(product);
    if (message != null) {
      products.insert(productIndex, product);
      notifyListeners();
      return message;
    }
    notifyListeners();
    return null;
  }

  Future<String?> removeProductInFirebase(Product product) async {
    IntegrateFirebase firebase = IntegrateFirebase("$urlStr/${product.id}");
    Map<String, dynamic> deleteResponse = await firebase.delete();
    if (deleteResponse.containsKey("errorMessage")) {
      return deleteResponse["errorMessage"];
    }
    return null;
  }

  Future<void> fetchaAllPrducts() async {
    IntegrateFirebase firebase = IntegrateFirebase(urlStr);
    var getResponse = await firebase.get();
    if (getResponse.containsKey("errorMessage")) {
      return getResponse["errorMessage"];
    }
    products.clear();
    //urlStr = "https://boip.in";
    getResponse.forEach((prodId, productData) {
      Product product = Product(
        id: prodId,
        description: productData["description"],
        imageUrl: productData["imageUrl"],
        title: productData["title"],
        price: productData["price"],
      );
      product.isFavorite = productData["isFavorite"] ?? false;
      products.add(
        product,
      );
    });
    notifyListeners();
  }
}




    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/8/8d/Trousers%2C_military_%28AM_2015.19.19-2%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
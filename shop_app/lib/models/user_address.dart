import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'integrate_firebase.dart';
import 'address.dart';

class UserAddress with ChangeNotifier {
  List<Address> userAddressList = [];
  late IntegrateFirebase firebase;
  String urlStr = "/address";

  UserAddress(BuildContext context) {
    firebase = Provider.of<IntegrateFirebase>(context, listen: false);
    firebase.setUrl = urlStr;
  }

  Future<String?> fetchaAllCartItems() async {
    firebase.setUrlWithUser(urlStr, null);
    var userAddresses = await firebase.get();
    if (userAddresses.containsKey("errorMessage")) {
      return userAddresses["errorMessage"];
    }
    userAddressList.clear();
    notifyListeners();
    return null;
  }

  Future<String?> addAddress(Address userAddress) async {
    // if (userAddress.id == null) {
    //   return "Address Id is invalid";
    // }
    String key = userAddress.id ?? DateTime.now().toIso8601String();
    userAddress.id = key;
    userAddressList.add(userAddress);
    notifyListeners();
    return null;
  }

  Future<String?> updateFirebase() async {
    firebase.setUrlWithUser(urlStr, null);
    var data = {
      "addressList": userAddressList,
    };
    Map<String, dynamic> cartAddResponse = await firebase.patch(data, false);
    if (cartAddResponse.containsKey("errorMessage")) {
      return cartAddResponse["errorMessage"];
    }
    return null;
  }
}

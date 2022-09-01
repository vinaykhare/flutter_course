// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import './my_exception.dart';

class AuthService with ChangeNotifier {
  String authServerUrl = "";
  //static String authToken = "";
  //static String userId = "";
  String email = "";
  String authToken = "";
  String userId = "";
  DateTime _expiryDate = DateTime.now().subtract(const Duration(days: 730));
  Timer? _authTimer;

  AuthService() {
    SharedPreferences.getInstance().then(
      (pref) {
        var extractedData = pref.getString("shopAppAuthData");
        if (extractedData != null) {
          Map<String, dynamic> extractedDecodeData = json.decode(extractedData);
          authToken = extractedDecodeData["authToken"] as String;
          userId = extractedDecodeData["userId"] as String;
          _expiryDate = DateTime.parse(
            extractedDecodeData["expriyDate"] as String,
          );
          email = extractedDecodeData["email"] as String;
        }
      },
    ).catchError((error) {
      print("Construtor failed in feteching the Shared Pref: $error");
    });
  }

  String? get token {
    //print(DateTime.now().isBefore(_expriyDate));
    return DateTime.now().isBefore(_expiryDate) ? authToken : null;
  }

  // String? get userId {
  //   return _userId;
  // }

  Future<String> _authenticate(
      String username, String password, String authType) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String urlStr =
          "$authServerUrl/v1/accounts:$authType?key=AIzaSyA4ewmMiArfo4NIS7G4t5wjbRduX8E8hOM";
      Uri url = Uri.parse(urlStr);

      var response = await http.post(url,
          body: json.encode({
            "email": username,
            "password": password,
            "returnSecureToken": true,
          }));

      var responesBody = json.decode(response.body);
      if (responesBody['error'] != null) {
        return responesBody['error']['message'];
      }
      authToken = responesBody['idToken'];
      userId = responesBody['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responesBody['expiresIn'],
          ),
        ),
      );
      email = responesBody['email'];
      pref.setString(
        "shopAppAuthData",
        json.encode(
          {
            "authToken": authToken,
            "userId": userId,
            "expriyDate": _expiryDate.toIso8601String(),
            "email": email,
          },
        ),
      );
      autoLogout();
      notifyListeners();
      return "Authenticated!";
    } catch (error) {
      return "Unknown: $error";
    }
  }

  Future<String> signUp(String username, String password) async {
    return _authenticate(username, password, "signUp");
  }

  Future<String> login(String username, String password) async {
    return _authenticate(username, password, "signInWithPassword");
  }

  Future<void> logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    authToken = "";
    userId = "";
    _expiryDate = _expiryDate.subtract(const Duration(days: 730));
    if (_authTimer != null) {
      _authTimer?.cancel();
      _authTimer = null;
    }
    pref.remove("shopAppAuthData");
    notifyListeners();
  }

  Future<bool> autoLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var extractedData = pref.getString("shopAppAuthData");
    if (extractedData == null) {
      print("extractedData:$extractedData");
      return false;
    }

    Map<String, dynamic> extractedDecodeData = json.decode(extractedData);
    authToken = extractedDecodeData["authToken"] as String;
    userId = extractedDecodeData["userId"] as String;
    _expiryDate = DateTime.parse(
      extractedDecodeData["expriyDate"] as String,
    );
    email = extractedDecodeData["email"] as String;
    print("After Invocation of Auto Login $_expiryDate");
    autoLogout();
    notifyListeners();

    return true;
  }

  Future<void> autoLogout() async {
    if (_authTimer != null) {
      _authTimer?.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), autoLogin);
  }
}

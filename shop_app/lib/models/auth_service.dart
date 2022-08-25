import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
//import './my_exception.dart';

class AuthService with ChangeNotifier {
  static String authToken = "";
  String? _token, _userId;
  DateTime _expriyDate = DateTime.now();

  String? get token {
    //print(DateTime.now().isBefore(_expriyDate));
    return DateTime.now().isBefore(_expriyDate) ? _token : null;
  }

  String? get userId {
    return _userId;
  }

  Future<String> _authenticate(
      String username, String password, String authType) async {
    try {
      String urlStr =
          "https://identitytoolkit.googleapis.com/v1/accounts:$authType?key=AIzaSyA4ewmMiArfo4NIS7G4t5wjbRduX8E8hOM";
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
      _token = responesBody['idToken'];
      _userId = responesBody['localId'];
      _expriyDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responesBody['expiresIn'],
          ),
        ),
      );
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
}

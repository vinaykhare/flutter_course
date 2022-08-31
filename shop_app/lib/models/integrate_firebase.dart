// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'my_exception.dart';

class IntegrateFirebase with ChangeNotifier {
  final AuthService authService;
  String firebaseShopAppAPI = "";
  String targetObject = '/products';
  String urlStr = "";

  IntegrateFirebase(this.authService);

  set setUrl(String targetObject) {
    urlStr =
        '$firebaseShopAppAPI$targetObject.json?auth=${authService.authToken}';
  }

  void setUrlWithUser(String targetObject, String? filter) {
    if (filter != null) {
      urlStr =
          '$firebaseShopAppAPI$targetObject.json?auth=${authService.authToken}&orderBy="$filter"&equalTo="${authService.userId}"';
    } else {
      urlStr =
          '$firebaseShopAppAPI$targetObject/${authService.userId}.json?auth=${authService.authToken}';
    }
  }
  // set setToken(String authToken) {
  //   urlStr = '$urlStr/auth=$authToken';
  // }

  Future<Map<String, dynamic>> post(
      Map<String, dynamic> data, bool addId) async {
    Map<String, dynamic> resp = {};
    if (addId) {
      data.putIfAbsent("createdBy", () => authService.userId);
    }
    try {
      final url = Uri.parse(urlStr);
      var response = await http.post(
        url,
        body: json.encode(data),
      );
      if (response.statusCode >= 400) {
        resp.putIfAbsent(
            "errorMessage", () => "Addition Failed: ${response.body}");
      } else {
        resp = json.decode(response.body);
      }
      print("Post for: ${urlStr.split("?")[0]}");
      return resp;
    } on MyException catch (exception) {
      resp.putIfAbsent("errorMessage", () => "My Exception: $exception");
      return resp;
    } catch (otherException) {
      resp.putIfAbsent("errorMessage", () => "My Exception: $otherException");
      return resp;
    }
  }

  Future<Map<String, dynamic>> patch(
      Map<String, dynamic> data, bool addId) async {
    Map<String, dynamic> resp = {};
    if (addId) {
      data.putIfAbsent("createdBy", () => authService.userId);
    }
    try {
      final url = Uri.parse(urlStr);
      var response = await http.patch(
        url,
        body: json.encode(data),
      );
      if (response.statusCode >= 400) {
        resp.putIfAbsent(
            "errorMessage", () => "Updated Failed: ${response.body}");
      } else {
        resp = json.decode(response.body);
      }
      print("Patch for: ${urlStr.split("?")[0]}");
      return resp;
    } on MyException catch (exception) {
      resp.putIfAbsent("errorMessage", () => "My Exception: $exception");
      return resp;
    } catch (otherException) {
      resp.putIfAbsent("errorMessage", () => "My Exception: $otherException");
      return resp;
    }
  }

  Future<Map<String, dynamic>> put(
      Map<String, dynamic> data, bool addId) async {
    Map<String, dynamic> resp = {};
    if (addId) {
      data.putIfAbsent("createdBy", () => authService.userId);
    }
    try {
      final url = Uri.parse(urlStr);
      var response = await http.put(
        url,
        body: json.encode(data),
      );
      if (response.statusCode >= 400) {
        resp.putIfAbsent(
            "errorMessage", () => "Putting Failed: ${response.body}");
      } else {
        resp = json.decode(response.body);
      }
      print("Put for: ${urlStr.split("?")[0]}");
      return resp;
    } on MyException catch (exception) {
      resp.putIfAbsent("errorMessage", () => "My Exception: $exception");
      return resp;
    } catch (otherException) {
      resp.putIfAbsent("errorMessage", () => "My Exception: $otherException");
      return resp;
    }
  }

  Future<Map<String, dynamic>> delete() async {
    Map<String, dynamic> resp = {};
    try {
      final url = Uri.parse(urlStr);
      var response = await http.delete(
        url,
      );
      if (response.statusCode >= 400) {
        resp.putIfAbsent(
            "errorMessage", () => "Deletion Failed: ${response.body}");
        // } else if (response.body == null) {
        //   resp.putIfAbsent(
        //       "successMessage", () => "Deletion Done for: ${response.body}");
      } else {
        //resp = json.decode(response.body) as Map<String, dynamic>;
        resp.putIfAbsent(
            "successMessage", () => "Deletion Done for: ${response.body}");
      }
      print("Delete for: ${urlStr.split("?")[0]}");
      return resp;
    } on MyException catch (exception) {
      resp.putIfAbsent("errorMessage", () => "My Exception: $exception");
      return resp;
    } catch (otherException) {
      resp.putIfAbsent("errorMessage", () => "My Exception: $otherException");
      return resp;
    }
  }

  Future<Map<String, dynamic>> get() async {
    Map<String, dynamic> resp = {};
    try {
      final url = Uri.parse(urlStr);
      var response = await http.get(
        url,
      );
      if (response.statusCode >= 400 || response.body == "null") {
        resp.putIfAbsent(
            "errorMessage", () => "Fetch Failed: ${response.body}");
      } else {
        resp = json.decode(response.body) as Map<String, dynamic>;
      }
      print("Get for: ${urlStr.split("?")[0]}");
      // if (urlStr.contains("orders")) {
      //   print("Get for: ${urlStr.split("?")[0]} is $resp");
      // }
      return resp;
    } on MyException catch (exception) {
      resp.putIfAbsent("errorMessage", () => "My Exception: $exception");
      return resp;
    } catch (otherException) {
      resp.putIfAbsent("errorMessage", () => "My Exception: $otherException");
      return resp;
    }
  }
}

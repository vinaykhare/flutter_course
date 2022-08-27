// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_service.dart';
import 'my_exception.dart';

class IntegrateFirebase {
  final String targetObject;
  String urlStr = "";
  Map<String, dynamic> resp = {};

  IntegrateFirebase(this.targetObject) {
    urlStr = '{server_url}/$targetObject/.json?auth=${AuthService.authToken}';
  }

  Future<Map<String, dynamic>> post(Map<String, dynamic> data) async {
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
      return resp;
    } on MyException catch (exception) {
      resp.putIfAbsent("errorMessage", () => "My Exception: $exception");
      return resp;
    } catch (otherException) {
      resp.putIfAbsent("errorMessage", () => "My Exception: $otherException");
      return resp;
    }
  }

  Future<Map<String, dynamic>> patch(Map<String, dynamic> data) async {
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
    try {
      final url = Uri.parse(urlStr);
      var response = await http.get(
        url,
      );
      print(response.statusCode);
      if (response.statusCode >= 400) {
        resp.putIfAbsent(
            "errorMessage", () => "Fetch Failed: ${response.body}");
      } else {
        resp = json.decode(response.body) as Map<String, dynamic>;
      }
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

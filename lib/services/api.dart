import 'dart:convert';
import 'package:http/http.dart' as http;

class APIServices {
  final String _baseURL = 'http://app.libraincentix.com/api/v1';
  String apiURL = '';
  final Map<String, String> _jsonHeader = {"Content-Type": "application/json"};

  APIServices() {
    apiURL = _baseURL;
  }

  Future<bool> validateAccount(
    String username,
    String password,
  ) async {
    Map<String, dynamic> body = {
      'username': username,
      'password': password,
      'app_version': '1',
    };

    var response = await http.post(
      Uri.parse("${apiURL}erp_app/mobile/validate_account"),
      body: body,
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success']) {
        return body['success'];
      } else {
        return body['already_logged_in'] ?? false;
      }
    } else {
      throw Exception('Error');
    }
  }

  Future forceLogin(
    String username,
    String password,
  ) async {
    Map<String, dynamic> body = {
      'username': username,
      'password': password,
      'app_version': '1',
    };
    var response = await http.post(
      Uri.parse("${apiURL}erp_app/mobile/force_login"),
      body: body,
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success']) {
        // return User.fromServer(body['user']);
      }
      throw Exception('Invalid Email/Password');
    } else {
      throw Exception('Error');
    }
  }
}

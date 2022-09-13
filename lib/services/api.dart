import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/market_offer_model.dart';
import 'package:lix/models/user.dart';

class APIService {
  final String _baseURL = 'http://app2.libraincentix.com/api/v1/';
  String apiURL = '';
  final Map<String, String> _jsonHeader = {
    "Content-Type": "application/json",
  };
  final Map<String, String> headers = {
    "Developer-Token": "37|UiJrhloD61M6TApAkDeHaZ46UNX1XA2qWeZ2LxPI"
  };

  APIService() {
    apiURL = _baseURL;
  }

  Future<User> login(
    String email,
    String password,
  ) async {
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };

    var response = await http.post(
      Uri.parse("${apiURL}user/login"),
      body: body,
      headers: headers,
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success']) {
        return User.fromJson(body['data']);
      } else {
        throw Exception('Error');
      }
    } else {
      throw Exception('Error');
    }
  }

  Future<User> register(
    String fullName,
    String email,
    String phoneNo,
    String password,
  ) async {
    Map<String, dynamic> body = {
      "name": fullName,
      "email": email,
      "phone": phoneNo,
      "password": password,
    };

    var response = await http.post(
      Uri.parse("${apiURL}user/register"),
      body: body,
      headers: headers,
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] && body['data'] != null) {
        return User.fromJson(body['data']);
      } else {
        throw CustomException(
          code: 'Error',
          message: 'User not registered',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['errors'] != null &&
          body['errors'].runtimeType == List<dynamic>) {
        throw CustomException.fromJson(body['errors'][0]);
      }

      throw Exception('Error');
    }
  }

  Future<bool> isEmailRegistered(String email) async {
    Map<String, dynamic> body = {
      "email": email,
    };

    var response = await http.post(
      Uri.parse("${apiURL}user/email/verify"),
      body: body,
      headers: headers,
    );

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return responseBody['success'];
    } else {
      if (responseBody['success'] != null) {
        return responseBody['success'];
      }
      throw Exception('Error');
    }
  }

  Future<User> retrieveUserProfile(User user) async {
    var response = await http.get(
      Uri.parse("${apiURL}user"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] && body['data'] != null) {
        return User.fromJson(body['data']);
      } else {
        throw CustomException(
          code: 'Error',
          message: 'User profile not found.',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['errors'] != null &&
          body['errors'].runtimeType == List<dynamic>) {
        throw CustomException.fromJson(body['errors'][0]);
      }

      throw Exception('Error');
    }
  }

  Future<List<MarketOffer>> allMarketOffers(User user) async {
    var response = await http.get(
      Uri.parse("${apiURL}markets"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] && body['data'] != null) {
        return (body['data']['data'] as List<dynamic>)
            .map((element) => MarketOffer.fromJson(element))
            .toList();
      } else {
        throw CustomException(
          code: 'Error',
          message: 'Offers not found.',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['errors'] != null &&
          body['errors'].runtimeType == List<dynamic>) {
        throw CustomException.fromJson(body['errors'][0]);
      }

      throw Exception('Error');
    }
  }
}

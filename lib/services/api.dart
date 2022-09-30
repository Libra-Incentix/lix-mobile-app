import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lix/models/country_model.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/market_offer_model.dart';
import 'package:lix/models/user.dart';

dynamic default_phone_code;

class APIService {
  final String _baseURL = 'http://app.libraincentix.com/api/v1/';
  String apiURL = '';
  final Map<String, String> _jsonHeader = {
    "Content-Type": "application/json",
  };
  final Map<String, String> headers = {
    "Developer-Token": "46|9ZDdTnphOi5MPNKcfzYwHgNvk0oZqfdRvG8wwNV3"
  };

  APIService() {
    apiURL = _baseURL;
  }

  Future<String> login(
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
      if (body['success'] == true && body['data'] == true) {
        return 'success';
      } else {
        return body['message'];
      }
    } else {
      throw Exception(jsonDecode(response.body)['message']);
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


  Future<bool> resendOTP(String email) async {
    Map<String, dynamic> body = {
      "email": email,
    };

    var response = await http.post(
      Uri.parse("${apiURL}user/resend/otp"),
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

  /**
   * Get all countries dial code, flag and currency info
   * return response
   **/
getCountryCode() async {
  dynamic result;
  try {
    final response = await http.get(Uri.parse(apiURL + 'countries/phone'),
      headers: headers,
    );

     if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

          if (body['success'] && body['data'] != null) {

            return (body['data']['data'] as List<dynamic>)
                .map((element) => Country.fromJson(element))
                .toList();
            } else {
               throw CustomException(
                  code: 'Error',
                  message: 'Country phone code not found.',
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
    } catch (e) {
    throw Exception('Error');
  }
}

}

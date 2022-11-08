import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lix/models/category_model.dart';
import 'package:lix/models/country_model.dart';
import 'package:lix/models/country_phone_model.dart';
import 'package:lix/models/coupon_model.dart';
import 'package:lix/models/custom_exception.dart';
import 'package:lix/models/market_offer_model.dart';
import 'package:lix/models/notification_model.dart';
import 'package:lix/models/task_model.dart';
import 'package:lix/models/transaction_model.dart';
import 'package:lix/models/user.dart';
import 'package:lix/models/wallet_details.dart';

class APIService {
  final String _baseURL = 'http://app2.libraincentix.com/api/v1/';
  final String imagesPath = "http://app2.libraincentix.com/images/";
  final String dealImagesPath = "http://app2.libraincentix.com/";
  final String termsPath = "https://app.libraincentix.com/terms/service";
  final String privacyPath = 'https://app2.libraincentix.com/privacy';

  String apiURL = '';
  final Map<String, String> _jsonHeader = {
    "Content-Type": "application/json",
  };
  final Map<String, String> headers = {
    "Developer-Token": "2|UEY39tNcLCJxeRwr5iOqjVsmmp4e9Ig1KDEV2qjz",
    "accept": "application/json",
  };

  APIService() {
    apiURL = _baseURL;
  }

  Future<Map<String, dynamic>> login(
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
      if (body['success'] != null && body['success']) {
        return body;
      } else {
        if (body['success'] != null && body['message'] != null) {
          throw CustomException(
            code: 'LoginFailed',
            message: body['message'],
          );
        }
        throw Exception('Error');
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'LoginFailed',
          message: body['message'],
        );
      }
      throw Exception('Error');
    }
  }

  Future socialLogin(String token) async {
    var response = await http.get(
      Uri.parse("${apiURL}social/login/$token"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['success']) {
        return body;
      } else {
        if (body['success'] != null && body['message'] != null) {
          throw CustomException(
            code: 'SocialLoginFailed',
            message: body['message'],
          );
        }
        throw Exception('Error');
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'LoginFailed',
          message: body['message'],
        );
      }
      throw Exception('Error');
    }
  }

  Future<Map<String, dynamic>> register(
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
        return body;
      } else {
        throw CustomException(
          code: 'Error',
          message: 'User not registered',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'RegistrationFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<Map<String, dynamic>> isEmailRegistered(String email) async {
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
      return responseBody;
    } else {
      if (responseBody['success'] != null && !responseBody['success']) {
        return responseBody;
      }
      throw Exception('Error');
    }
  }

  Future<bool> userResendOTP(String email) async {
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
      if (responseBody['success'] != null && responseBody['message'] != null) {
        throw CustomException(
          code: '',
          message: responseBody['message'],
        );
      }
      throw Exception('Error');
    }
  }

  Future<User> userVerifyOTP(String email, String otp) async {
    Map<String, dynamic> body = {"email": email, "otp": otp};

    var response = await http.post(
      Uri.parse("${apiURL}user/verify/otp"),
      body: body,
      headers: headers,
    );

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responseBody['success'] != null && responseBody['success']) {
        return User.fromJson(responseBody['data']);
      } else {
        throw CustomException(
          code: '',
          message: responseBody['message'] ?? '',
        );
      }
    } else {
      if (responseBody['success'] != null && responseBody['message'] != null) {
        throw CustomException(
          code: '',
          message: responseBody['message'],
        );
      }
      throw Exception('Error');
    }
  }

  Future<User> retrieveUserProfile(User user) async {
    var response = await http.get(
      Uri.parse("${apiURL}get-loggedin-user"),
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
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'ProfileRetrievalFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(
      User user, String imagePath) async {
    Uri url = Uri.parse("${apiURL}user/profile/update");
    var request = http.MultipartRequest('POST', url);
    request.fields['name'] = user.name!;
    request.fields['phone'] = user.phone!;
    request.fields['gender'] = user.gender!;
    request.fields['date_of_birth'] = user.dateOfBirth!;

    if (imagePath.isNotEmpty) {
      http.MultipartFile file = await http.MultipartFile.fromPath(
        'avatar',
        imagePath,
      );
      request.files.add(file);
    }

    Map<String, String> requestHeaders = {
      "Developer-Token": headers['Developer-Token'] ?? '',
      "Authorization": "Bearer ${user.userToken}",
    };
    request.headers.addAll(requestHeaders);

    var response = await request.send();
    var byteData = String.fromCharCodes(await response.stream.toBytes());
    var body = jsonDecode(byteData);

    if (response.statusCode == 200) {
      if (body['success'] && body['data'] != null) {
        return body;
      } else {
        throw CustomException(
          code: 'Error',
          message: 'User not registered',
        );
      }
    } else {
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'UpdateProfileFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<Map> allMarketOffers(User user, int page) async {
    var response = await http.get(
      Uri.parse("${apiURL}markets?page=$page"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] && body['data'] != null) {
        Map<String, dynamic> responseMap = {
          "current_page": body['data']['meta']['current_page'],
          "last_page": body['data']['meta']['last_page'],
          "allOffers": (body['data']['data'] as List<dynamic>)
              .map((element) => MarketOffer.fromJson(element))
              .toList()
        };

        return responseMap;
      } else {
        throw CustomException(
          code: 'Error',
          message: 'Offers not found.',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'MarketOfferRetrievalFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<List<MarketOffer>> allRecommendedDeals(User user) async {
    var response = await http.get(
      Uri.parse("${apiURL}markets/recommended"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] && body['data'] != null) {
        return (body['data'] as List<dynamic>)
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
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'DealsRetrievalFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<List<CountryPhone>> getAllPhoneCountries() async {
    var response = await http.get(
      Uri.parse("${apiURL}countries/phone"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['data'] != null) {
        return (body['data']['data'] as List<dynamic>)
            .map((element) => CountryPhone.fromJson(element))
            .toList();
      } else {
        throw CustomException(
          code: 'Error',
          message: '',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'PhoneCountryRetrievalFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<List<Country>> getAllCountries() async {
    var response = await http.get(
      Uri.parse("${apiURL}countries"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['data'] != null) {
        return (body['data']['data'] as List<dynamic>)
            .map((element) => Country.fromJson(element))
            .toList();
      } else {
        throw CustomException(
          code: 'Error',
          message: '',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'CountryRetrievalFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future verifyQRCodeLink(String link, User user) async {
    var response = await http.post(
      Uri.parse("${apiURL}qrcode/link/verify"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
      body: {
        "link": link,
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] && body['data'] != null) {
        return body;
      } else {
        throw CustomException(
          code: 'Error',
          message: 'Could not able to fetch task...',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'QRCodeLinkVerifyFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<Map<String, dynamic>> submitTaskMultipart(
      User user, String taskId, String imagePath, String codeReceived) async {
    Uri url = Uri.parse("${apiURL}tasks/activity/${taskId}/submit");
    var request = http.MultipartRequest('POST', url);
    request.fields['email'] = user.email!;
    request.fields['proof'] = codeReceived;
    if (imagePath.isNotEmpty) {
      http.MultipartFile file = await http.MultipartFile.fromPath(
        'proof_image',
        imagePath,
      );
      request.files.add(file);
    }

    Map<String, String> requestHeaders = {
      "Developer-Token": headers['Developer-Token'] ?? '',
      "Authorization": "Bearer ${user.userToken}",
    };
    request.headers.addAll(requestHeaders);

    var response = await request.send();
    var byteData = String.fromCharCodes(await response.stream.toBytes());
    var body = jsonDecode(byteData);
    if (response.statusCode == 200) {
      if (body['success'] && body['data'] != null) {
        return body;
      } else {
        throw CustomException(
          code: 'Error',
          message: body['message'],
        );
      }
    } else {
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'TaskSubmitFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<Map<String, dynamic>> submitTaskPost(
      User user, String taskId, String codeReceived) async {
    var response = await http.post(
      Uri.parse("${apiURL}tasks/activity/${taskId}/submit"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
      body: {
        "email": user.email!,
        "proof": codeReceived,
      },
    );
    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (body['success'] && body['data'] != null) {
        return body;
      } else {
        throw CustomException(
          code: 'Error',
          message: body['message'],
        );
      }
    } else {
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'TaskSubmitFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<Map<String, dynamic>> buyOffer(
    User user,
    String offerId,
  ) async {
    var response = await http.post(
      Uri.parse("${apiURL}markets/buy_offer"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
      body: {
        "offer": offerId,
        "user_id": user.phone,
        "redeemer_email": user.email,
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] && body['data'] != null) {
        return body;
      } else {
        throw CustomException(
          code: 'Error',
          message: body['message'],
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'BuyOfferFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<List<WalletDetails>> getUserBalance(User user) async {
    var response = await http.get(
      Uri.parse("${apiURL}user/profile/balance"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['data'] != null) {
        return (body['data'] as List<dynamic>)
            .map((e) => WalletDetails.fromJson(e))
            .toList();
      } else {
        throw CustomException(
          code: 'Error',
          message: '',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'BalanceRetrieveFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<List<Category>> getAllCategories(User user) async {
    var response = await http.get(
      Uri.parse("${apiURL}categories"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['data'] != null) {
        return (body['data']['data'] as List<dynamic>)
            .map((e) => Category.fromJson(e))
            .toList();
      } else {
        throw CustomException(
          code: 'Error',
          message: '',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'CategoryRetrievalFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  /// ``type`` will only be `email`, `push` or `sms`
  /// and action will either be 0 or 1. 0 for disable and 1 for enable.
  Future enableDisableNotifications(User user, String type, int action) async {
    var response = await http.post(
      Uri.parse("${apiURL}notifications/enable/disable"),
      body: {
        "notification_type": type,
        "notification_action": action.toString(),
      },
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['data'] != null) {
        return body['success'];
      } else {
        throw CustomException(
          code: 'Error',
          message: '',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'NotificationReadMarkFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future markNotificationAsRead(User user, int notificationId) async {
    var response = await http.get(
      Uri.parse("${apiURL}update/notification/status/$notificationId"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['data'] != null) {
        return body['success'];
      } else {
        throw CustomException(
          code: 'Error',
          message: '',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'NotificationReadMarkFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<List<NotificationModel>> getAllNotifications(User user) async {
    var response = await http.get(
      Uri.parse("${apiURL}get/user/notifications"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['data'] != null) {
        return (body['data'] as List<dynamic>)
            .map((e) => NotificationModel.fromJson(e))
            .toList();
      } else {
        throw CustomException(
          code: 'Error',
          message: '',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'NotificationsRetrievalFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<String> getWalletFundsLink(User user, int walletId) async {
    var response = await http.get(
      Uri.parse("${apiURL}wallets/funds/$walletId"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['data'] != null) {
        return body['data'];
      } else {
        throw CustomException(
          code: 'Error',
          message: '',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'WalletFundsRetrieveFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<String> getWalletFundsTransferLink(User user, int walletId) async {
    var response = await http.get(
      Uri.parse("${apiURL}wallets/funds/$walletId/transfer"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['data'] != null) {
        return body['data'];
      } else {
        throw CustomException(
          code: 'Error',
          message: '',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'WalletFundsRetrieveFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<String> getWalletFundsWithdrawLink(User user, int walletId) async {
    var response = await http.get(
      Uri.parse("${apiURL}wallets/funds/$walletId/withdraw"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['data'] != null) {
        return body['data'];
      } else {
        throw CustomException(
          code: 'Error',
          message: '',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'WalletFundsRetrieveFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<List<TransactionModel>> getAllTransactions(User user) async {
    var response = await http.get(
      Uri.parse("${apiURL}transactions/${user.id}"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['data'] != null) {
        return (body['data']['data'] as List)
            .map((e) => TransactionModel.fromJson(e))
            .toList();
      } else {
        throw CustomException(
          code: 'Error',
          message: body['message'] ?? '',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'TransactionListRetrievalFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<Map<String, dynamic>> getGlobalTasks(User user, int page) async {
    var response = await http.get(
      Uri.parse("${apiURL}tasks/global-tasks?page=$page"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['data'] != null) {
        Map<String, dynamic> responseMap = {
          "current_page": body['data']['meta']['current_page'],
          "last_page": body['data']['meta']['last_page'],
          "tasks": (body['data']['data'] as List)
              .map((e) => TaskModel.fromJson(e))
              .toList()
        };
        return responseMap;
      } else {
        throw CustomException(
          code: 'Error',
          message: body['message'] ?? '',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'TaskListRetrievalFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<bool> changePassword(
    User user,
    String oldPassword,
    String newPassword,
    String passwordConfirmation,
  ) async {
    var response = await http.post(
      Uri.parse("${apiURL}user/change/password"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
      body: {
        "oldpassword": oldPassword,
        "password": newPassword,
        "password_confirmation": passwordConfirmation,
      },
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] != null) {
        return body['success'];
      } else {
        throw CustomException(
          code: 'Error',
          message: body['message'] ?? '',
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'ChangePasswordRequestFailed',
          message: body['message'],
        );
      }

      if (body['errors'] != null &&
          body['errors'].runtimeType == (List<dynamic>) &&
          (body['errors'] as List<dynamic>).isNotEmpty) {
        throw CustomException(
          code: 'ChangePasswordRequestFailed',
          message: body['errors'][0]['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<Map<String, dynamic>> deleteUserAccount(
    User user,
  ) async {
    // TODO
    // Need to change 122 with ${user.id}
    var response = await http.delete(
      Uri.parse("${apiURL}user/profile/${user.id}/delete"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] && body['data'] != null) {
        return body;
      } else {
        throw CustomException(
          code: 'Error',
          message: body['message'],
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'DeleteFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<List<CouponModel>> getMyCoupons(User user) async {
    var response = await http.get(
      Uri.parse("${apiURL}get/user/coupons"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] && body['data'] != null) {
        return (body['data']['data'] as List<dynamic>)
            .map((e) => CouponModel.fromJson(e))
            .toList();
      } else {
        throw CustomException(
          code: 'Error',
          message: body['message'],
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'MyCouponsRetrievalFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }

  Future<String> creditSocialShareBonus(User user) async {
    var response = await http.get(
      Uri.parse("${apiURL}social/share/bonus"),
      headers: {
        ...headers,
        "Authorization": "Bearer ${user.userToken}",
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body['success'] && body['data'] != null) {
        return body['message'];
      } else {
        throw CustomException(
          code: 'Error',
          message: body['message'],
        );
      }
    } else {
      var body = jsonDecode(response.body);
      if (body['success'] != null && body['message'] != null) {
        throw CustomException(
          code: 'SocialShareBonusCreditFailed',
          message: body['message'],
        );
      }

      throw Exception('Error');
    }
  }
}

import 'dart:math';

import 'package:lix/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperService {
  SharedPreferences? _prefs;
  User? _user;

  HelperService();

  Future initializeSharedPreferences() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future initialize() async {
    var user = await isUserLoggedIn();
    if (user is User) {
      _user = user;
    }
  }

  Future isUserLoggedIn() async {
    await initializeSharedPreferences();
    if (_prefs!.containsKey('loggedIn')) {
      if (_prefs!.getBool('loggedIn')!) {
        return _prefs!.getBool('loggedIn');
      }
      return false;
    } else {
      _prefs!.setBool('loggedIn', false);
      return false;
    }
  }

  Future<User?> retrievingUserDetails() async {
    if (await isUserLoggedIn()) {
      if (_user == null) {
        User user = User();
        user.id = _prefs!.getInt('user-id');
        user.name = _prefs!.getString('user-name');
        user.email = _prefs!.getString('user-email');
        user.password = _prefs!.getString('user-password');
        user.phone = _prefs!.getString('user-phone');
        user.gender = _prefs!.getString('user-gender');
        user.dateOfBirth = _prefs!.getString('user-dateOfBirth');
        user.cityId = _prefs!.getInt('user-cityId');
        user.stateId = _prefs!.getInt('user-stateId');
        user.countryId = _prefs!.getInt('user-countryId');
        user.createdAt = _prefs!.getString('user-createdAt');
        user.updatedAt = _prefs!.getString('user-updatedAt');
        user.emailVerifiedAt = _prefs!.getString('user-emailVerifiedAt');
        user.userToken = _prefs!.getString('user-token');

        _user = user;
        return user;
      }

      return _user!;
    }
    return null;
  }

  Future saveUserDetails(User user) async {
    await initializeSharedPreferences();

    await _prefs!.setInt('user-id', user.id!);
    await _prefs!.setString('user-name', user.name!);
    await _prefs!.setString('user-email', user.email!);
    await _prefs!.setString('user-password', user.password!);
    await _prefs!.setString('user-phone', user.phone!);
    await _prefs!.setString('user-gender', user.gender!);
    await _prefs!.setString('user-dateOfBirth', user.dateOfBirth!);
    await _prefs!.setInt('user-cityId', user.cityId!);
    await _prefs!.setInt('user-stateId', user.stateId!);
    await _prefs!.setInt('user-countryId', user.countryId!);
    await _prefs!.setString('user-createdAt', user.createdAt!);
    await _prefs!.setString('user-updatedAt', user.updatedAt!);
    await _prefs!.setString('user-emailVerifiedAt', user.emailVerifiedAt!);
    await _prefs!.setString('user-token', user.userToken!);

    await _prefs!.setBool('loggedIn', true);
    await retrievingUserDetails();
  }

  User? getCurrentUser() {
    return _user;
  }

  Future deleteUserDetails() async {
    await initializeSharedPreferences();

    await _prefs!.remove('user-id');
    await _prefs!.remove('user-name');
    await _prefs!.remove('user-email');
    await _prefs!.remove('user-password');
    await _prefs!.remove('user-phone');
    await _prefs!.remove('user-gender');
    await _prefs!.remove('user-dateOfBirth');
    await _prefs!.remove('user-cityId');
    await _prefs!.remove('user-stateId');
    await _prefs!.remove('user-countryId');
    await _prefs!.remove('user-createdAt');
    await _prefs!.remove('user-updatedAt');
    await _prefs!.remove('user-emailVerifiedAt');
    await _prefs!.remove('user-token');

    await _prefs!.setBool('loggedIn', false);
  }

  Future<bool> logout() async {
    await initializeSharedPreferences();
    if (_prefs!.containsKey('loggedIn')) {
      await deleteUserDetails();
      _user = null;
      return await _prefs!.remove('loggedIn');
    } else {
      return true;
    }
  }

  Future changeUserKey(String key, dynamic value) async {
    await initializeSharedPreferences();

    if (_prefs!.containsKey(key)) {
      if (value.runtimeType == bool) {
        _prefs!.setBool(key, value);
      } else if (value.runtimeType == int) {
        _prefs!.setInt(key, value);
      } else if (value.runtimeType == double) {
        _prefs!.setDouble(key, value);
      } else {
        _prefs!.setString(key, value);
      }
    }
  }

  String generateRandomString(int len) {
    var r = Random();
    const chars = '1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }
}

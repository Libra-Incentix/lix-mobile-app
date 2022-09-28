// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:lix/models/custom_exception.dart';
// import 'package:lix/models/user.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// class AuthService {
//   bool isAppleAuthAvailable = false;

//   Future initialize() async {
//     if (!kIsWeb) {
//       if (!Platform.isAndroid) {
//         isAppleAuthAvailable = await SignInWithApple.isAvailable();
//       }
//     }
//   }

//   Future loginWithApple() async {
//     User? user;
//     try {
//       AuthorizationCredentialAppleID credentialAppleID =
//           await _loginWithApple();
//       user = User(
//         socialId: credentialAppleID.userIdentifier,
//         name: '${credentialAppleID.givenName} ${credentialAppleID.familyName}',
//         email: credentialAppleID.email,
//       );

//       return user;
//     } on CustomException catch (e) {
//       throw CustomException(
//         code: '11',
//         message: e.message,
//       );
//     } catch (e) {
//       throw CustomException(
//         code: '11',
//         message: 'Error',
//       );
//     }
//   }

//   // Future<AuthorizationCredentialAppleID> _loginWithApple() async {
//   //   AuthorizationCredentialAppleID credential;
//   //   try {
//   //     credential = await SignInWithApple.getAppleIDCredential(
//   //       scopes: [
//   //         AppleIDAuthorizationScopes.email,
//   //         AppleIDAuthorizationScopes.fullName,
//   //       ],
//   //     );
//   //     return credential;
//   //   } catch (err) {
//   //     log('$err');
//   //     throw CustomException(
//   //       code: '1',
//   //       message: (err as dynamic).toSting(),
//   //     );
//   //   }
//   // }
// }

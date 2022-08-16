import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nakiapp/globals.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import 'dart:math';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  String getTokenUrlSafe(int length) {
    String chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  String s256(List<int> data) {
    return base64Url.encode(sha256.convert(data).bytes).replaceAll('=', '');
  }

  @override
  Widget build(BuildContext context) {
    String code_verifier = getTokenUrlSafe(32);
    String code_challenge = s256(utf8.encode(code_verifier)).toString();
    final loginParams = {
      'code_challenge': code_challenge,
      'code_challenge_method': 'S256',
      'client': 'pixiv-android',
    };
    var newLoginUrl = Uri(
        scheme: 'https',
        host: 'app-api.pixiv.net',
        path: '/web/v1/login',
        queryParameters: loginParams);

    debugPrint(newLoginUrl.toString());

    return Scaffold(
        appBar: AppBar(
          title: const Text('Refresh Token'),
        ),
        body: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (url) => debugPrint('asd'),
            onPageFinished: (url) => debugPrint('lmao'),
            initialUrl: newLoginUrl.toString(),
            userAgent: 'PixivAndroidApp/5.0.234 (Android 11; Pixel 5)'));
  }
}

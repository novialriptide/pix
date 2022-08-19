import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nakiapp/globals.dart';
import 'package:nakiapp/states/recommended.dart';
import 'package:nakiapp/states/searchpage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import 'dart:math';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:http/http.dart' as http;
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

  Future<Map<dynamic, dynamic>> getCode(
      String errorUrl, String codeVerifier) async {
    errorUrl = errorUrl.replaceAll('pixiv://account/login?code=', '');
    errorUrl = errorUrl.replaceAll('&via=login', '');
    Map<String, String> body = {
      'client_id': clientId,
      'client_secret': clientSecret,
      'code': errorUrl,
      'code_verifier': codeVerifier,
      'grant_type': 'authorization_code',
      'include_policy': 'true',
      'redirect_uri': redirectUri
    };
    var response = await http.post(
      Uri.https(authTokenHost, authTokenPath),
      body: body,
      headers: {'User-Agent': userAgent},
    );
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;

    return decodedResponse;
  }

  @override
  Widget build(BuildContext context) {
    WebViewController webViewController;
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

    return Scaffold(
        appBar: AppBar(
          title: const Text('Refresh Token'),
        ),
        body: WebView(
            onWebViewCreated: (WebViewController c) {
              webViewController = c;
            },
            onWebResourceError: ((error) {
              getCode(error.failingUrl.toString(), code_verifier)
                  .then((result) {
                refreshToken = result['refresh_token'];
                client.connect(refreshToken);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecommendedScreen()));
              });
            }),
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: newLoginUrl.toString(),
            userAgent: userAgent));
  }
}

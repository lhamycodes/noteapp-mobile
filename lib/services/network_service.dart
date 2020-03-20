import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../const.dart';
import '../locator.dart';
import 'token_service.dart';

class NetworkService {
  final TokenService _tokenService = locator<TokenService>();

  Future<http.Response> get(
    String url, {
    Map<String, String> headers,
    bool isAuth = false,
  }) async {
    final String token = _tokenService.getToken();
    final http.Response res = await http.get(url, headers: <String, String>{
      if (isAuth) HttpHeaders.authorizationHeader: 'Bearer $token',
      ...headers
    });
    if (res.statusCode == 401) {
      final String tokenStr = await refresh(token);
      return await http.get(url, headers: <String, String>{
        if (isAuth) HttpHeaders.authorizationHeader: 'Bearer $tokenStr',
        ...headers
      });
    }
    return res;
  }

  Future<http.Response> post(
    String url, {
    Map<String, String> headers,
    dynamic body,
    bool isAuth = false,
    bool encodeBody = true,
  }) async {
    final String token = _tokenService.getToken();
    final jsonBody = encodeBody ? jsonEncode(body) : body;
    final http.Response res = await http.post(
      url,
      headers: <String, String>{
        if (isAuth) HttpHeaders.authorizationHeader: 'Bearer $token',
        ...headers
      },
      body: jsonBody,
    );
    if (res.statusCode == 401) {
      final String tokenStr = await refresh(token);
      return await http.post(
        url,
        headers: <String, String>{
          if (isAuth) HttpHeaders.authorizationHeader: 'Bearer $tokenStr',
          ...headers
        },
        body: jsonBody,
      );
    }
    return res;
  }

  Future<http.Response> put(
    String url, {
    Map<String, String> headers,
    dynamic body,
    bool isAuth = false,
    bool encodeBody = true,
  }) async {
    final String token = _tokenService.getToken();
    final jsonBody = encodeBody ? jsonEncode(body) : body;
    final http.Response res = await http.put(
      url,
      headers: <String, String>{
        if (isAuth) HttpHeaders.authorizationHeader: 'Bearer $token',
        ...headers
      },
      body: jsonBody,
    );
    if (res.statusCode == 401) {
      final String tokenStr = await refresh(token);
      return await http.put(
        url,
        headers: <String, String>{
          if (isAuth) HttpHeaders.authorizationHeader: 'Bearer $tokenStr',
          ...headers
        },
        body: jsonBody,
      );
    }
    return res;
  }

  Future<http.Response> delete(
    String url, {
    Map<String, String> headers,
    bool isAuth = false,
  }) async {
    final String token = _tokenService.getToken();
    final http.Response res = await http.delete(
      url,
      headers: <String, String>{
        if (isAuth) HttpHeaders.authorizationHeader: 'Bearer $token',
        ...headers
      },
    );
    if (res.statusCode == 401) {
      final String tokenStr = await refresh(token);
      return await http.delete(
        url,
        headers: <String, String>{
          if (isAuth) HttpHeaders.authorizationHeader: 'Bearer $tokenStr',
          ...headers
        },
      );
    }
    return res;
  }

  Future<String> refresh(String token) async {
    final http.Response res = await post(
      '$API_BASE_URL/auth/refresh',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json",
      },
      body: jsonEncode({}),
    );
    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonRes = jsonDecode(res.body);
      final String accessToken = jsonRes['access_token'];
      _tokenService.token = jsonRes;
      return accessToken;
    }
    return null;
  }
}

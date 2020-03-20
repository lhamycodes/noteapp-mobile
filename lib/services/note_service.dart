import 'package:flutter/foundation.dart';

import '../const.dart';
import '../locator.dart';

import 'network_service.dart';

class NoteService {
  final NetworkService _networkService = locator<NetworkService>();

  final String baseURL = API_BASE_URL;

  Future create({@required Map noteData, @required String endpoint}) async {
    try {
      var apiResult = await _networkService.post(
        "$API_BASE_URL/$endpoint",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: noteData,
        isAuth: true,
      );
      return apiResult;
    } catch (e) {
      return e;
    }
  }

  Future update({@required Map noteData, @required String endpoint}) async {
    try {
      var apiResult = await _networkService.put(
        "$API_BASE_URL/$endpoint",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: noteData,
        encodeBody: false,
        isAuth: true,
      );
      return apiResult;
    } catch (e) {
      return e;
    }
  }

  Future delete({@required String endpoint}) async {
    try {
      var apiResult = await _networkService.delete(
        "$API_BASE_URL/$endpoint",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        isAuth: true,
      );
      return apiResult;
    } catch (e) {
      return e;
    }
  }
}

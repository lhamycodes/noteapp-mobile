import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../viewmodels/application_view_model.dart';
import '../ui/views/auth/login_screen.dart';
import '../ui/views/auth/signup_screen.dart';

import '../ui/views/app/dashboard.dart';

import '../services/authentication_service.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';

import '../locator.dart';

import 'base_model.dart';

class AuthViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _passwordVisible = true;
  bool _passwordConfirmVisible = true;

  bool get passwordVisible => _passwordVisible;
  bool get passwordConfirmVisible => _passwordConfirmVisible;

  Map _authData = {};
  Map get authData => _authData;

  Map _verifyData = {};
  Map get verifyData => _verifyData;

  void setPasswordVisible(bool val, {int type = 1}) {
    type == 1 ? _passwordVisible = val : _passwordConfirmVisible = val;
    notifyListeners();
  }

  Future login() async {
    setBusy(true);

    var result = await _authenticationService.authenticate(
      authData: _authData,
      type: "auth/login",
    );

    setBusy(false);

    if (result.runtimeType == Response) {
      var body = jsonDecode(result.body);
      if (result.statusCode == 200) {
        setBusy(true);

        _authenticationService.loadToken(body['data']['token']);
        ApplicationViewModel().user = body['data']['user'];

        setBusy(false);

        _navigationService.navigateAndClearRoute(DashboardScreen.routeName);
      } else if (result.statusCode == 400) {
        await _dialogService.showDialog(
          title: 'Login Failed',
          description: body['message'],
        );
      } else {
        await _dialogService.showDialog(
          title: 'Login Failed',
          description: body['message'],
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Application error',
        description: result.toString(),
      );
    }
  }

  Future register() async {
    setBusy(true);

    var result = await _authenticationService.authenticate(
      authData: _authData,
      type: "auth/register",
    );

    setBusy(false);

    if (result.runtimeType == Response) {
      var body = jsonDecode(result.body);
      if (result.statusCode == 200) {
        setBusy(true);

        _authenticationService.loadToken(body['data']['token']);
        ApplicationViewModel().user = body['data']['user'];

        setBusy(false);

        _navigationService.navigateAndClearRoute(DashboardScreen.routeName);
      } else if (result.statusCode == 400) {
        await _dialogService.showDialog(
          title: 'Sign Up Failed',
          description: body['message'],
        );
      } else if (result.statusCode == 422) {
        body['data'].forEach((key, val) async {
          await _dialogService.showDialog(
            title: 'Validation Error',
            description: val[0],
          );
        });
      } else {
        await _dialogService.showDialog(
          title: 'Sign Up Failed',
          description: body['message'],
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Sign Up Failed',
        description: result.toString(),
      );
    }
  }

  void toRoute(String type) {
    String toRoute = "";
    switch (type) {
      case "register":
        toRoute = SignupScreen.routeName;
        break;
      case "login":
        toRoute = LoginScreen.routeName;
        break;
    }
    _navigationService.navigateTo(
      toRoute,
      replace: false,
    );
  }
}

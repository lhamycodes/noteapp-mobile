import 'dart:convert';

import 'package:noteapp/ui/views/auth/login_screen.dart';

import '../ui/views/app/notes/create.dart';
import '../ui/views/app/notes/edit.dart';

import '../models/user.dart';

import '../services/local_storage_service.dart';
import '../services/authentication_service.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';
import '../services/application_service.dart';
import '../locator.dart';

import 'base_model.dart';

class ApplicationViewModel extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final ApplicationService _application = locator<ApplicationService>();
  final LocalStorageService _storageService = locator<LocalStorageService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  User _user;

  User get user {
    _user = _application.getUser;
    return _user;
  }

  set user(userJson) {
    _authenticationService.loadUser(userJson);
    ApplicationService.user = User.fromJson(userJson);
  }

  Future getUserProfile() async {
    var userProfile = await _application.userProfile();
    if (userProfile.statusCode == 200) {
      var body = jsonDecode(userProfile.body);
      user = body['data'];
    }
  }

  void toRoute(String type, {dynamic argument}) {
    switch (type) {
      case "edit-note":
        _navigationService.navigateTo(
          EditNote.routeName,
          arguments: argument,
        );
        break;
      case "create-note":
        _navigationService.navigateTo(
          CreateNote.routeName,
        );
        break;
      default:
    }
  }

  Future<bool> onWillPop() async {
    bool ans = false;
    await _dialogService
        .showConfirmationDialog(
      title: "Confirm Action !",
      description: "Do you want to exit NoteApp",
      cancelTitle: "No",
      confirmationTitle: "Yes",
    )
        .then((val) {
      ans = val.confirmed;
    });
    return ans;
  }

  Future<bool> logout() async {
    bool ans = false;
    await _dialogService
        .showConfirmationDialog(
      title: "Confirm Action !",
      description: "Do you want to logout from NoteApp",
      cancelTitle: "No",
      confirmationTitle: "Yes",
    )
        .then(
      (val) {
        ans = val.confirmed;
        if (val.confirmed == true) {
          _storageService.empty();
          _dialogService.showDialog(
              title: "Logout", description: "Logout successful");
          _navigationService.navigateAndClearRoute(LoginScreen.routeName);
        }
      },
    );
    return ans;
  }
}

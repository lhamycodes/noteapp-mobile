import '../locator.dart';

import '../services/navigation_service.dart';
// import '../services/local_storage_service.dart';
import '../viewmodels/base_model.dart';

import '../ui/views/auth/login_screen.dart';
import '../ui/views/auth/signup_screen.dart';

// import '../ui/views/app/dashboard.dart';

class StartUpViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  // final LocalStorageService _storageService = locator<LocalStorageService>();

  Future handleStartUpLogic() async {
    Future.delayed(Duration(seconds: 3), () {
      toRoute("login", replace: true);
    });
  }

  void toRoute(String type, {bool replace = false}) {
    String toRoute = "";
    switch (type) {
      case "login":
        toRoute = LoginScreen.routeName;
        break;
      case "register":
        toRoute = SignupScreen.routeName;
        break;
      // default:
      //   toRoute = LoginScreen.routeName;
      //   break;
    }
    _navigationService.navigateTo(
      toRoute,
      replace: replace,
    );
  }
}

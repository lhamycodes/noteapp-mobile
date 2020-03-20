import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'locator.dart';
import 'managers/dialog_manager.dart';
import 'routes.dart';
import 'services/dialog_service.dart';
import 'services/local_storage_service.dart';
import 'services/navigation_service.dart';
import 'ui/shared/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await LocalStorageService.getInstance();
    await setupLocator();
    runApp(MyApp());
  } catch (error) {
    print(error);
    print('Locator setup has failed');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteApp',
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => DialogManager(child: child),
        ),
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: locator<NavigationService>().navigationKey,
      theme: ThemeData(
        primaryColor: primaryColor,
        textTheme: GoogleFonts.latoTextTheme(),
        indicatorColor: primaryColor,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          brightness: Brightness.light,
        ),
      ),
      routes: appRoutes,
    );
  }
}

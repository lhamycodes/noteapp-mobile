import 'package:flutter/material.dart';

import 'ui/views/intro/startup_view.dart';
import 'ui/views/auth/login_screen.dart';
import 'ui/views/auth/signup_screen.dart';
import 'ui/views/app/dashboard.dart';
import 'ui/views/app/notes/create.dart';
import 'ui/views/app/notes/edit.dart';

var appRoutes = <String, WidgetBuilder>{
  '/': (ctx) => StartUpView(),

  // Auth Routes
  LoginScreen.routeName: (ctx) => LoginScreen(),
  SignupScreen.routeName: (ctx) => SignupScreen(),

  // Dashboard Routes
  DashboardScreen.routeName: (ctx) => DashboardScreen(),
  CreateNote.routeName: (ctx) => CreateNote(),
  EditNote.routeName: (ctx) => EditNote(),
};

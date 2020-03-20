import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

import '../../widgets/custom_text_field.dart';
import '../../../ui/shared/app_colors.dart';
import '../../../ui/shared/ui_helpers.dart';
import '../../../ui/widgets/busy_button.dart';
import '../../../viewmodels/auth_view_model.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/auth/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return ViewModelProvider<AuthViewModel>.withConsumer(
      viewModel: AuthViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            FlatButton(
              padding: EdgeInsets.zero,
              child: Text(
                "Sign In",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              textColor: primaryColor,
              onPressed: () => model.toRoute('login'),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "NotesApp",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          " - Sign up",
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ],
                    ),
                    verticalSpace(15),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          CustomTextField(
                            label: "Full name",
                            hintText: "John Doe",
                            keyboardAction: TextInputAction.next,
                            validator: (val) {
                              if (val.toString().isEmpty) {
                                return "Full name is required";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              model.authData['name'] = val;
                            },
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            label: "Email address",
                            hintText: "test@email.com",
                            keyboardAction: TextInputAction.next,
                            inputType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val.toString().isEmpty) {
                                return "Email Address is required";
                              } else if (!EmailValidator.validate(val)) {
                                return "Email Address is not valid";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              model.authData['email'] = val;
                            },
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            label: "Password",
                            hintText: "xxxxxxxxx",
                            obscureText: model.passwordVisible,
                            keyboardAction: TextInputAction.done,
                            maxLines: 1,
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                              ),
                              onPressed: () => model.setPasswordVisible(
                                !model.passwordVisible,
                              ),
                            ),
                            validator: (val) {
                              if (val.toString().isEmpty) {
                                return "Password is required";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              model.authData['password'] = val;
                            },
                          ),
                          verticalSpace(20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'By clicking "Sign Up" you agree to the terms and conditions as well as our privacy policy',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: BusyButton(
                title: "Sign Up",
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  _formKey.currentState.save();
                  model.register();
                },
                busy: model.busy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

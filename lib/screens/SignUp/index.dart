import 'package:analise_test/components/Buttons/roundedButton.dart';
import 'package:analise_test/components/Buttons/textButton.dart';
import 'package:analise_test/components/TextFields/inputField.dart';
import 'package:analise_test/services/authentication.dart';
import 'package:analise_test/services/validations.dart';
import 'package:analise_test/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'style.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  SignUpScreenState createState() => new SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserData newUser = new UserData();
  UserAuth userAuth = new UserAuth();
  bool _autovalidate = false;
  Validations _validations = new Validations();

  _onPressed() {
    print("button clicked");
  }
  onPressed(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value) ));
  }

  void _handleSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      userAuth.createUser(newUser).then((onValue) {
        showInSnackBar(onValue);
      }).catchError((PlatformException onError) {
        showInSnackBar(onError.message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size screenSize = MediaQuery.of(context).size;
    //print(context.widget.toString());
    return new Scaffold(
        key: _scaffoldKey,
        body: new SingleChildScrollView(
          child: new Container(
            padding: new EdgeInsets.all(35.0),
            decoration: new BoxDecoration(image: backgroundImage),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new SizedBox(
                    height: screenSize.height / 2,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "CREATE ACCOUNT",
                          textAlign: TextAlign.center,
                          style: headingStyle,
                        )
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: new SizedBox(
                    height: screenSize.height / 1.0,
                    child: new Column(
                      children: <Widget>[
                        new Form(
                            key: _formKey,
                            autovalidate: _autovalidate,
                            //onWillPop: _warnUserAboutInvalidData,
                            child: new Column(
                              children: <Widget>[
                                new InputField(
                                  hintText: "Username",
                                  obscureText: false,
                                  textInputType: TextInputType.text,
                                  textStyle: textStyle,
                                  icon: Icons.person_outline,
                                  iconColor: Colors.white,
                                  bottomMargin: 20.0,
                                  validateFunction: _validations.validateName,
                                  onSaved: (String name) {
                                    newUser.displayName = name;
                                  },
                                ),
                                new InputField(
                                    hintText: "Email",
                                    obscureText: false,
                                    textInputType: TextInputType.emailAddress,
                                    textStyle: textStyle,
                                    icon: Icons.mail_outline,
                                    iconColor: Colors.white,
                                    bottomMargin: 20.0,
                                    validateFunction: _validations.validateEmail,
                                    onSaved: (String email) {
                                      newUser.email = email;
                                    }),
                                new InputField(
                                    hintText: "Password",
                                    obscureText: true,
                                    textInputType: TextInputType.text,
                                    textStyle: textStyle,
                                    icon: Icons.lock_open,
                                    iconColor: Colors.white,
                                    bottomMargin: 20.0,
                                    validateFunction:
                                        _validations.validatePassword,
                                    onSaved: (String password) {
                                      newUser.password = password;
                                    }),
                                new RoundedButton(
                                    buttonName: "Continue",
                                    onTap: _handleSubmitted,
                                    width: screenSize.width,
                                    height: 40.0,
                                    bottomMargin: 10.0,
                                    borderWidth: 1.0)

                              ],


                            )),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new TextButton(
                                buttonName: "Login",
                                onPressed: () => onPressed("/Login"),
                                buttonTextStyle: buttonTextStyle),
                            new TextButton(
                                buttonName: "Forgot Password?",
                                onPressed: () => onPressed("/ForgotPassword"),
                                buttonTextStyle: buttonTextStyle)
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

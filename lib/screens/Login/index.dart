import 'package:analise_test/components/Buttons/roundedButton.dart';
import 'package:analise_test/components/Buttons/textButton.dart';
import 'package:analise_test/components/TextFields/inputField.dart';
import 'package:analise_test/services/authentication.dart';
import 'package:analise_test/services/validations.dart';
import 'package:analise_test/theme/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:analise_test/screens/Home/hazardreport_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:analise_test/screens/SignUp/style.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => new LoginScreenState();
}
//final DocumentReference docRefUsers = Firestore.instance.collection("$uid").document('User Details');
//String userName = 'John Doe';
//String userEmail = 'your_email@example.com';
//int userScore = 0;


class LoginScreenState extends State<LoginScreen> {
  BuildContext context;
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController scrollController = new ScrollController();
  UserData user = new UserData();
  UserAuth userAuth = new UserAuth();
  bool autovalidate = false;
  Validations validations = new Validations();



  onPressed(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _handleSubmitted() {
    final FormState form = formKey.currentState;
    if (!form.validate()) {
      autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      userAuth.verifyUser(user).then((onValue) {
        if (onValue == "Login Successfull") {
          Navigator.pushNamed(context, "/HomePage");
          form.reset();
        }
        else
          showInSnackBar(onValue);
      }).catchError((PlatformException onError) {
        showInSnackBar(onError.message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    final Size screenSize = MediaQuery.of(context).size;
    //print(context.widget.toString());
    Validations validations = new Validations();
    return new Scaffold(
        key: _scaffoldKey,
        body: new SingleChildScrollView(
            controller: scrollController,
            child: new Container(
              padding: new EdgeInsets.all(16.0),
              decoration: new BoxDecoration(image: backgroundImage),
              child: new Column(
                children: <Widget>[
                  new Container(
                    height: screenSize.height / 2,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Center(
                            child: new Text(
                              "Analise",
                              style: headingStyle,
                              textAlign: TextAlign.center,
                        ))
                      ],
                    ),
                  ),
                  new Container(
                    height: screenSize.height / 2,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Form(
                          key: formKey,
                          autovalidate: autovalidate,
                          child: new Column(
                            children: <Widget>[
                              new InputField(
                                  hintText: "Email",
                                  obscureText: false,
                                  textInputType: TextInputType.text,
                                  textStyle: textStyle,
                                  icon: Icons.mail_outline,
                                  iconColor: Colors.white,
                                  bottomMargin: 20.0,
                                  validateFunction: validations.validateEmail,
                                  onSaved: (String email) {
                                    user.email = email;
                                  }),
                              new InputField(
                                  hintText: "Password",
                                  obscureText: true,
                                  textInputType: TextInputType.text,
                                  textStyle: textStyle,
                                  icon: Icons.lock_open,
                                  iconColor: Colors.white,

                                  bottomMargin: 30.0,
                                  validateFunction:
                                      validations.validatePassword,
                                  onSaved: (String password) {
                                    user.password = password;
                                  }),
                              new RoundedButton(
                                buttonName: "Login",
                                onTap: (){
                                  _handleSubmitted();

                                },
                                width: screenSize.width,
                                height: 50.0,
                                bottomMargin: 10.0,
                                borderWidth: 0.0,
                                buttonColor: primaryColor,
                              ),
                            ],
                          ),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new TextButton(
                                buttonName: "Create Account",
                                onPressed: () => onPressed("/SignUp"),
                                buttonTextStyle: buttonTextStyle),
                            new TextButton(
                                buttonName: "Forgot Password?",
                                onPressed: () => onPressed("/ForgotPassword"),
                                buttonTextStyle: buttonTextStyle)
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}

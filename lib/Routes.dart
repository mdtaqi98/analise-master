import 'package:analise_test/screens/FogotPassword/index.dart';
import 'package:analise_test/screens/Home/hazardreport_screen.dart';
import 'package:analise_test/screens/Login/index.dart';
import 'package:analise_test/screens/SignUp/index.dart';
import 'package:analise_test/services/Imagepicker.dart';
import 'package:analise_test/services/camerapicker.dart';
// import 'package:analise_test/services/reportlocation.dart';
import 'package:analise_test/theme/style.dart';
import 'package:flutter/material.dart';

class Routes {
  var routes = <String, WidgetBuilder>{
    "/SignUp": (BuildContext context) => new SignUpScreen(),
    "/Login": (BuildContext context) => new LoginScreen(),
    "/HomePage": (BuildContext context) => new MyHome(),
    "/ForgotPassword": (BuildContext context) => new ForgotPasswordScreen(),
    // "/ReportLocation": (BuildContext context) => new Mylocation(),
    "/ImagePicker": (BuildContext context) => new Imagepicker(),
    "/CameraPicker": (BuildContext context) => new Camerapicker(),
  };

  Routes() {
    runApp(new MaterialApp(
      title: "Analise App",
      home: new LoginScreen(),
      theme: appTheme,
      routes: routes,
    ));
  }
}

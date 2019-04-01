import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';





class UserData {
  String displayName;
  String email;
  String uid;
  String password;
  int score;

  UserData({this.displayName, this.email, this.uid, this.password,this.score});
}

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

var uid;
var error;
var loginerror = null;

final DocumentReference docRefUsers = Firestore.instance.collection("$uid").document('User Details');
String userName = '';
String userEmail = '';
int userScore = 0;

fetchuserdata()async {

  await docRefUsers.get().then((datasnapshot){
    if(datasnapshot.exists){
      print('Fetching Data');
      userName = datasnapshot.data['Name'];
      userEmail = datasnapshot.data['Email'];
      userScore = datasnapshot.data['Score'];
    }
  });

}



class UserAuth {
  String statusMsg = "We have sent an email to verify your email address.";

  //To create new User
  Future<String> createUser(UserData userData) async {
    FirebaseUser user = await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: userData.email, password: userData.password).catchError(error);
    print(error);
    await user.sendEmailVerification();
    uid = user.uid;
    await Firestore.instance.collection('$uid').document('User Details')
        .setData(
        { 'Name': userData.displayName, 'Email': user.email, 'UUID': user.uid,'Score':0});
    return statusMsg;
  }


//  //To verify new User
  Future<String> verifyUser (UserData userData) async{
    FirebaseUser user =
    await _firebaseAuth
        .signInWithEmailAndPassword(email: userData.email, password: userData.password);
    bool userverified = user.isEmailVerified;
    uid=user.uid;
    print(userverified);
    if(userverified == false){
      user.sendEmailVerification();
      return "Please Verify Your Email Address";
    }

    await fetchuserdata();
    return "Login Successfull";

  }



//  //To verify new User
//  Future<String> verifyUser(UserData userData) async {
//    FirebaseUser user =
//    await _firebaseAuth
//        .signInWithEmailAndPassword(
//        email: userData.email, password: userData.password).catchError(
//            (e) => loginerror = e);
//    print(loginerror);
//      bool userverified = user.isEmailVerified;
//      uid = user.uid;
//      if (userverified == false) {
//        print('Verifying user ');
//        user.sendEmailVerification();
//        loginerror=null;
//        return "Please Verify Your Email Address";
//      } else  if(loginerror == null){
//        print('Login success');
//        loginerror= null;
//        await fetchuserdata();
//      return "Login Successfull";
//
//      }
//    else
//      print('some error occured');
//      return "$loginerror";
//
//
//
//
//  }









  //To reset password
  Future<String> resetPassword(UserData userData) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.sendPasswordResetEmail(email: userData.email);
    return "Reset link has been sent to your email address.";
  }

  //To Sign out
  Future<String> signOut() {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.signOut();
  }

}
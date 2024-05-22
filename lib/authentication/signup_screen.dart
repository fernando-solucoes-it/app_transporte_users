import 'dart:ffi';

import 'package:app_tranporte_users/pages/home_page.dart';
import 'package:app_tranporte_users/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../methods/common_methods.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkNetwork() {
    cMethods.checkConnectivity(context);

    signUpFormValidation();
  }

  signUpFormValidation() {
    if (usernameTextEditingController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          "your name must be at least 3 or more characters.", context);
    } else if (phoneTextEditingController.text.trim().length < 7) {
      cMethods.displaySnackBar(
          "your phone must be at least 8 or more characters.", context);
    } else if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("enter with a valid e-mail.", context);
    } else if (passwordTextEditingController.text.trim().length <= 5) {
      cMethods.displaySnackBar(
          "your password, must be at least 6 characters", context);
    } else {
      registerNewUser();
    }
  }

  registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Registering your account..."),
    );

    final User? userFirebase = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text.trim(),
                password: passwordTextEditingController.text.trim())
            .catchError((errorMsg) {
      Navigator.pop(context);
      cMethods.displaySnackBar(errorMsg, context);
    }))
        .user;

    if (!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);

    Map userDataMap = {
      "name": usernameTextEditingController.text.trim(),
      "email": emailTextEditingController.text.trim(),
      "phone": phoneTextEditingController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no",
    };

    usersRef.set(userDataMap);

    Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset("assets/images/logo.png"),

              const Text(
                "Create a User\'s Account",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              //Text Fields
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    TextField(
                      controller: usernameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: "User Name",
                          labelStyle: TextStyle(
                            fontSize: 15,
                          )),
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          labelText: "User Phone",
                          labelStyle: TextStyle(
                            fontSize: 15,
                          )),
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                          labelText: "User Email",
                          labelStyle: TextStyle(
                            fontSize: 15,
                          )),
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: "User Passconst const world",
                          labelStyle: TextStyle(
                            fontSize: 15,
                          )),
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    //text fields + button
                    ElevatedButton(
                      onPressed: () {
                        checkNetwork();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(horizontal: 80)),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),

                    //textbuttom
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const LoginScreen()));
                      },
                      child: const Text(
                        "Already have an Account? Login Here",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),

                    const SizedBox(
                      height: 22,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

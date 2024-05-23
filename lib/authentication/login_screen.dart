import 'package:app_tranporte_users/authentication/signup_screen.dart';
import 'package:app_tranporte_users/global/global_var.dart';
import 'package:app_tranporte_users/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../methods/common_methods.dart';
import '../widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  var cMethods = CommonMethods();

  checkNetwork() {
    cMethods.checkConnectivity(context);

    signInFormValidation();
  }

  signInFormValidation() {
    if (emailTextEditingController.text.trim().isEmpty) {
      cMethods.displaySnackBar(
          "please enter with your e-mail.", context);
    } else if (passwordTextEditingController.text.trim().isEmpty) {
      cMethods.displaySnackBar(
          "please enter with your password", context);
    }else {
      signInUser();
    }
  }

  signInUser() async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Validating your login information..."),
    );

    final User? userFirebase = (
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
      ).catchError((errorMessage)
      {
          Navigator.pop(context);
          cMethods.displaySnackBar(errorMessage.toString(), context);
      })
    ).user;

    if(!context.mounted) return;
      Navigator.pop(context);

    if(userFirebase != null){
      DatabaseReference usersRef =
      FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);

      usersRef.once().then((snap){
        if(snap.snapshot.value != null)
        {
          if((snap.snapshot.value as Map)["blockStatus"] == "no"){
            userName = (snap.snapshot.value as Map)["name"];
            Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
          }else
          {
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar("Your account has been blocked! Contact the suport", context);
          }
        }else
        {
          FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar("your record do not exist as a User in our database", context);
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Image.asset("assets/images/logo.png"),

              const Text(
                "Login",
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
                    const SizedBox(
                      height: 22,
                    ),

                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                          labelText: "User Email",
                          labelStyle: TextStyle(
                            fontSize: 14,
                          )),
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          labelText: "User Passworld",
                          labelStyle: TextStyle(
                            fontSize: 14,
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10)),
                      child: const Text(
                        "Log in",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),

                    //textbuttom
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const SignUpScreen()));
                      },
                      child: const Text(
                        "Don\'t have an Account? Register Here",
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

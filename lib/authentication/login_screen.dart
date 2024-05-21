import 'package:app_tranporte_users/authentication/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

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
                            fontSize: 15,
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
                            fontSize: 15,
                          )),
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    //text fields + button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(horizontal: 80)),
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

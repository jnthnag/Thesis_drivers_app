import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:thesis_driver_app/authentication/login_screen.dart';
import 'package:thesis_driver_app/methods/common_methods.dart';

import '../pages/home_page.dart';
import '../widgets/loading_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // initialize objects for Name, Phone, Email, Password
  //TextEditingController userNameTextEditingController = TextEditingController();
  // TextEditingController userPhoneTextEditingController = TextEditingController();
  // TextEditingController emailTextEditingController = TextEditingController();
  // TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods common = CommonMethods();

  checkIfNetworkIsAvailable() {
    common.checkConnectivity(context);

    signUpFormValidation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 300,
              ),

              const Text(
                "Create User Account",
                style: TextStyle(
                  fontFamily: null,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // TEXT FIELDS and ACTION BUTTON
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    TextField(
                      controller: common.userNameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "User Name",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: common.userPhoneTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "User Phone",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: common.emailTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "User Email",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                      controller: common.passwordTextEditingController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "User Password",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        checkIfNetworkIsAvailable();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 10)),
                      child: const Text("Sign Up"),
                    ),
                  ],
                ),
              ),

              // Sub text button for existing users
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const LoginScreen()));
                },
                child: const Text(
                  "Already Have an Account? Login Here",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUpFormValidation() {
    if (common.userNameTextEditingController.text.trim().length < 3) {
      common.displaySnackbar(
          "Your username must be at least 4 or more characters", context);
    } else if (common.userPhoneTextEditingController.text.trim().length != 11) {
      common.displaySnackbar("Your phone number length must be 11 ", context);
    } else if (!common.emailTextEditingController.text.contains("@")) {
      common.displaySnackbar("Please write a valid email", context);
    } else if (common.passwordTextEditingController.text.length < 5) {
      common.displaySnackbar(
          "Your password must be at least 6 or more characters", context);
    } else {
      registerNewUser();
    }
  }

  registerNewUser() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            LoadingDialog(messageText: "Registering your account"));
    final User? userFirebase = (await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: common.emailTextEditingController.text.trim(),
      password: common.passwordTextEditingController.text.trim(),
    )
        .catchError((errorMessage) => common.displaySnackbar(errorMessage.toString(), context)))
        .user;
    if (!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);
    Map userDataMap = {
      "name" : common.userNameTextEditingController.text.trim(),
      "email" : common.emailTextEditingController.text.trim(),
      "phone" : common.userPhoneTextEditingController.text.trim(),
      "id" : userFirebase.uid,
      "blockStatus" : "no",
    };

    usersRef.set(userDataMap);
    Navigator.push(context, MaterialPageRoute(builder: (c) => const HomePage()));
  }
}

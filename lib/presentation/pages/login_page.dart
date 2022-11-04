// ignore_for_file: prefer_final_fields

import 'package:auth_firebase/data/models/user_model.dart';
import 'package:auth_firebase/data/remote_data_source/firestore_helper.dart';
import 'package:auth_firebase/presentation/pages/home_page.dart';
import 'package:auth_firebase/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key})
      : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool? _isSigning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: "Username"),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: "Password"),
                obscureText: true,
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                FirestoreHelper.create(UserModel(
                    username: _usernameController.text,
                    password: _passwordController.text,
                  ));
              },
              child: Container(
                width: 120,
                height: 35,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          _isSigning == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text("Please wait..."),
                    const SizedBox(
                      width: 10,
                    ),
                    const CircularProgressIndicator()
                  ],
                )
              : Container(),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("New to the application?"),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }

  // Future _signInUser() async {
  //   setState(() {
  //     _isSigning = true;
  //   });
  //   try {
  //     await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(
  //       email: _emailController.text,
  //       password: _passwordController.text,
  //     )
  //         .then((value) {
  //       setState(() {
  //         _isSigning = false;
  //       });
  //     });
  //   } catch (e) {
  //     print("some error $e");
  //   }
  // }
}

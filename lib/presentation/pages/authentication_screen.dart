
// import 'package:auth_firebase/presentation/pages/login_page.dart';
// import 'package:auth_firebase/presentation/pages/sign_up_page.dart';
// import 'package:flutter/material.dart';

// class AuthenticationScreen extends StatefulWidget {
//   const AuthenticationScreen({Key? key}) : super(key: key);

//   @override
//   State<AuthenticationScreen> createState() => _AuthenticationScreenState();
// }

// class _AuthenticationScreenState extends State<AuthenticationScreen> {

//   bool isSignIn = true;
//   @override
//   Widget build(BuildContext context) {
//     return isSignIn? LoginPage(onTapClickListener: switchPage) :
//         SignUpPage(onTapClickListener: switchPage);
//   }

//   switchPage() => setState(() => isSignIn = !isSignIn);
// }
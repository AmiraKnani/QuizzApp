import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizzapp/reusable_widgets/reusable_widget.dart';
import 'package:quizzapp/screens/home_screen.dart';
import 'package:quizzapp/screens/resetpassword_screen.dart';
import 'package:quizzapp/screens/signup_screen.dart';
import 'package:quizzapp/services/firebase_services.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, MediaQuery.of(context).size.height * 0.04, 20, 0),
                    child: Column(
                      children: <Widget>[
                        logoWidget("assets/images/logo.png"),
                        reusableTextField("Enter Email", Icons.person_outline,
                            false, _emailTextController),
                        SizedBox(
                          height: 15,
                        ),
                        reusableTextField("Enter Password", Icons.lock_outline,
                            true, _passwordTextController),
                        SizedBox(
                          height: 15,
                        ),
                        ResetOption(),
                        SizedBox(
                          height: 25,
                        ),
                        signInSignUpButton(context, true, () {
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text)
                              .then((value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          }).catchError((error, stackTrace) {
                            String errorMessage = "An unknown error occurred.";
                            if (error is FirebaseAuthException) {
                              errorMessage = getFirebaseAuthErrorMessage(error);
                            }

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: Text(errorMessage),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("Close",
                                          style: TextStyle(
                                              color: Colors.deepPurple)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            print("Error ${error.toString()}");
                          });
                        }),
                        const SizedBox(height: 130),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                height: 1.0,
                                color: Color.fromARGB(30, 0, 0, 0),
                              ),
                            ),
                            const Text(
                              "Or connect with",
                              style: TextStyle(
                                  color: Color.fromARGB(139, 0, 0, 0)),
                            ),
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                height: 1.0,
                                color: Color.fromARGB(30, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(FontAwesomeIcons.google,
                                  color: Colors.red),
                              onPressed: () async {
                                await FirebaseServices().signInWithGoogle();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              },
                            ),
                            const SizedBox(width: 5),
                            IconButton(
                              icon: const Icon(FontAwesomeIcons.facebook,
                                  color: Colors.blueAccent),
                              onPressed: () async {
                                await FirebaseServices().signInWithFacebook();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        signUpOption(),
                      ],
                    )))));
  }

  Row signUpOption() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text("Don't have an account?",
          style: TextStyle(color: Color.fromARGB(139, 0, 0, 0))),
      GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpScreen()));
        },
        child: const Text(
          " Sign Up",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    ]);
  }

  Row ResetOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 210), // Adjust the value as needed
          child: const Text(
            "",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ResetPwd()));
          },
          child: const Text(
            "Forget your password?",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  String getFirebaseAuthErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case "invalid-email":
        return "Your email address appears to be malformed.";
      case "wrong-password":
        return "Your password is wrong.";
      case "user-not-found":
        return "User with this email doesn't exist.";
      case "user-disabled":
        return "User with this email has been disabled.";
      case "too-many-requests":
        return "Too many requests. Try again later.";
      case "operation-not-allowed":
        return "Signing in with Email and Password is not enabled.";

      default:
        return "Caught Firebase Auth Exception with code: ${error.code}";
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzapp/reusable_widgets/reusable_widget.dart';
import 'package:quizzapp/screens/signin_screen.dart';

class ResetPwd extends StatefulWidget {
  const ResetPwd({super.key});

  @override
  State<ResetPwd> createState() => _ResetPwdState();
}

class _ResetPwdState extends State<ResetPwd> {
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background2.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.06, 20, 0),
                  child: Column(
                    children: <Widget>[
                      logoWidget("assets/images/logo.png"),
                      const SizedBox(
                        height: 30,
                      ),
                      reusableTextField("Enter Your Email",
                          Icons.person_outline, false, _emailTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      ResetButton(context, true, () => resetPassword(context))
                    ],
                  )))),
    );
  }

  void resetPassword(context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailTextController.text);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Password Reset"),
          content:
              const Text("A password reset link has been sent to your email."),
          actions: <Widget>[
            TextButton(
              child:
                  const Text("OK", style: TextStyle(color: Colors.deepPurple)),
              onPressed: () {
                Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignInScreen()));
              },
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Handle errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.message ?? "An unknown error occurred."),
          actions: <Widget>[
            TextButton(
              child: const Text("Close",
                  style: TextStyle(color: Colors.deepPurple)),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        ),
      );
    }
  }
}

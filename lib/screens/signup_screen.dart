import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzapp/reusable_widgets/reusable_widget.dart';
import 'package:quizzapp/screens/home_screen.dart';
import 'package:quizzapp/screens/signin_screen.dart';
import 'package:intl/intl.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _dateOfBirthTextController =
      TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedGender;

  bool isVerified = false;

  @override
  void dispose() {
    _passwordTextController.dispose();
    _emailTextController.dispose();
    _userNameTextController.dispose();
    _dateOfBirthTextController.dispose();
    super.dispose();
  }

  Future<void> signUpUser() async {
    try {
      print("Attempting to sign up user");
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailTextController.text.trim(),
              password: _passwordTextController.text);

      if (userCredential.user != null) {
        print("Firebase Auth User Created: ${userCredential.user!.uid}");
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'userName': _userNameTextController.text.trim(),
          'email': _emailTextController.text.trim(),
          'password': _passwordTextController.text.trim(),
          'dateOfBirth': _selectedDate?.toIso8601String() ?? 'Not specified',
          'gender': _selectedGender,
          'isVerified': false,
        });
        print("User data added to Firestore");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SignInScreen()));
      } else {
        print("UserCredential returned null");
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuth Error: ${e.code}, ${e.message}");
    } catch (e) {
      print("Error during sign up: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
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
                  padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                  child: Column(
                    children: <Widget>[
                      logoWidgetSmall("assets/images/logo1.png"),
                      const SizedBox(
                        height: 50,
                      ),
                      reusableTextField("Enter User Name", Icons.person_outline,
                          false, _userNameTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Enter Email", Icons.person_outline,
                          false, _emailTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Enter Password", Icons.lock_outline,
                          true, _passwordTextController),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField(
                        "Date of Birth",
                        Icons.calendar_today,
                        false,
                        _dateOfBirthTextController,
                        suffix: TextButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Text(
                            _selectedDate != null
                                ? DateFormat('yyyy-MM-dd')
                                    .format(_selectedDate!)
                                : 'Select your date of birth',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _genderRadioButton('Female', 'Female'),
                          _genderRadioButton('Male', 'Male'),
                        ],
                      ),
                      signInSignUpButton(context, false, () async {
                        try {
                          await signUpUser();
                        } catch (e) {
                          print("Error: ${e.toString()}");
                        }
                      })
                    ],
                  )))),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateOfBirthTextController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Widget _genderRadioButton(String value, String title) {
    return Expanded(
      child: ListTile(
        title: Text(title, style: TextStyle(color: Colors.white)),
        leading: Radio<String>(
          value: value,
          groupValue: _selectedGender,
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
        ),
      ),
    );
  }
}

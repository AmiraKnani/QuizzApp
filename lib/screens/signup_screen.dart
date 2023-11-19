import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:quizzapp/reusable_widgets/reusable_widget.dart';
import 'package:quizzapp/screens/home_screen.dart';
import 'package:quizzapp/utils/color_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  late TextEditingController _dateOfBirthTextController;
  DateTime? _selectedDate;
  String? _selectedGender;

  @override
void initState() {
  super.initState();
  _passwordTextController = TextEditingController();
  _emailTextController = TextEditingController();
  _userNameTextController = TextEditingController();
  _dateOfBirthTextController = TextEditingController(); // Initialize here
}
@override
void dispose() {
  _passwordTextController.dispose();
  _emailTextController.dispose();
  _userNameTextController.dispose();
  _dateOfBirthTextController.dispose(); // Dispose here
  super.dispose();
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
              gradient: LinearGradient(colors: [
            hexStringToColor("#8776d7"),
            hexStringToColor("#8274d8"),
            hexStringToColor("#3d4aec")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
                  child: Column(
                    children: <Widget>[
                      logoWidgetSmall("assets/images/logo1.png"),
                      const SizedBox(
                        height: 30,
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
                              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                              : 'Select your date of birth',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                      const SizedBox(height: 20),
                      // Gender selection
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _genderRadioButton('Female', 'Female'),
                          _genderRadioButton('Male', 'Male'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      signInSignUpButton(context, false, () {
                        FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _emailTextController.text, 
                        password: _passwordTextController.text).then((value) {
                          print("Created New Account");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                        }).onError((error, stackTrace) {
                          print("Error ${error.toString()}");
                        });
                        
                      })
                    ],
                  )))),
    );
  }

  // Method to show the date picker
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
      _dateOfBirthTextController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    });
  }
}

  // Widget for gender selection Radio button
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

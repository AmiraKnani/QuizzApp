import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzapp/reusable_widgets/reusable_widget.dart';
import 'package:quizzapp/utils/color_utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isEmailVerified = false;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      setState(() {
        _isEmailVerified = user.emailVerified;
      });

      if (!user.emailVerified) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists && userDoc.data() is Map<String, dynamic>) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          if (userData['isVerified'] == true) {
            setState(() {
              _isEmailVerified = true;
            });
          }
        }
      }
    }
  }

  Future<void> _sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Verification email sent. Please check your email.')),
      );
      FirebaseAuth.instance.userChanges().listen((User? user) async {
        if (user != null && user.emailVerified) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'isVerified': true,
          });
          setState(() {
            _isEmailVerified = true;
          });
        }
      });
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
          "Settings",
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
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              _buildSectionTitle("Email Verification"),
              _buildEmailVerificationSection(),
              SizedBox(height: 35),
              _buildSectionTitle("Change Password"),
              SizedBox(height: 20),
              _buildChangePasswordSection(),
              SizedBox(height: 35),
              _buildSectionTitle("Notification Settings"),
              SizedBox(height: 5),
              _buildNotificationSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildEmailVerificationSection() {
    return ListTile(
      title:
          Text("Email is " + (_isEmailVerified ? "verified" : "not verified")),
      trailing: ElevatedButton(
        onPressed: _isEmailVerified ? null : _sendEmailVerification,
        child: Text(_isEmailVerified ? "Verified" : "Verify"),
      ),
    );
  }

  Widget _buildChangePasswordSection() {
    return Column(
      children: [
        reusableTextField("Current Password", Icons.lock_outline, true,
            _currentPasswordController),
        SizedBox(height: 20),
        reusableTextField(
            "New Password", Icons.lock_outline, true, _newPasswordController),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _changePassword,
          child: Text("Update Password"),
        ),
      ],
    );
  }

  Widget _buildNotificationSettingsSection() {
    return SwitchListTile(
      title: Text("Enable Notifications"),
      value: _notificationsEnabled,
      onChanged: (bool value) {
        setState(() {
          _notificationsEnabled = value;
        });
      },
    );
  }

  Future<void> _changePassword() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String currentPassword = _currentPasswordController.text.trim();
      String newPassword = _newPasswordController.text.trim();

      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update password: $error')),
        );
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update password: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update password: $e')),
      );
    }
  }
}

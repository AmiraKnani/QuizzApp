import 'package:flutter/material.dart';
import 'package:quizzapp/utils/color_utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

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
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
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
              _buildChangePasswordSection(),
              SizedBox(height: 35),
              _buildSectionTitle("Notification Settings"),
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
        onPressed: () {},
        child: Text(_isEmailVerified ? "Verified" : "Verify"),
      ),
    );
  }

  Widget _buildChangePasswordSection() {
    return Column(
      children: [
        _buildPasswordInput("Current Password", _currentPasswordController),
        SizedBox(height: 20),
        _buildPasswordInput("New Password", _newPasswordController),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
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

  Widget _buildPasswordInput(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        fillColor: Colors.white.withOpacity(0.5),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

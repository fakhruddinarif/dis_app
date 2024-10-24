import 'package:flutter/material.dart';
import 'package:dis_app/utils/constants/colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController =
      TextEditingController(text: '******'); // Default value

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DisColors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: DisColors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: DisColors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false, // Allow scroll when keyboard appears
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  // Profile Picture with edit icon
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage('assets/profile_picture.jpg'),
                      ),
                      CircleAvatar(
                        backgroundColor: DisColors.primary,
                        radius: 18,
                        child: const Icon(
                          Icons.edit,
                          color: DisColors.black,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Name Field
                  _buildTextFormField(_nameController, 'Name', _nameFocusNode),
                  const SizedBox(height: 16),
                  // Email Field
                  _buildTextFormField(
                      _emailController, 'Email', _emailFocusNode),
                  const SizedBox(height: 16),
                  // Phone Number Field
                  _buildTextFormField(
                      _phoneController, 'Phone Number', _phoneFocusNode),
                  const SizedBox(height: 16),
                  // Password Field with Change Password button
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextFormField(
                          _passwordController,
                          'Password',
                          _passwordFocusNode,
                          obscureText: true,
                          readOnly: true, // Make it read-only
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/change-password');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DisColors.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Change Password',
                          style: TextStyle(color: DisColors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Log Out Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        _showLogoutConfirmationDialog(context);
                      },
                      icon: const Icon(Icons.logout, color: DisColors.error),
                      label: const Text(
                        'Log Out',
                        style: TextStyle(color: DisColors.error),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Save Profile Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showSaveConfirmationDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: DisColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Save Profile',
                      style: TextStyle(color: DisColors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method to build TextFormField with focus border color
  Widget _buildTextFormField(
      TextEditingController controller, String labelText, FocusNode focusNode,
      {bool obscureText = false, bool readOnly = false}) {
    return Focus(
      focusNode: focusNode,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly, // Add read-only property
        decoration: InputDecoration(
          labelText: labelText,
          // Use DisColors for the border colors
          border: OutlineInputBorder(
            borderSide: BorderSide(color: DisColors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: DisColors.primary, width: 2.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          // Adjust label style to use DisColors for primary text color
          labelStyle: TextStyle(
            color: focusNode.hasFocus
                ? DisColors.textPrimary
                : DisColors.darkerGrey,
          ),
          // Background color when not focused
          fillColor: DisColors.lightGrey,
          filled: true,
        ),
        onTap: () {
          setState(() {}); // Trigger rebuild
        },
      ),
    );
  }

  // Show logout confirmation dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Logout?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: const Text(
            'Are you sure want to logout?',
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          actionsPadding:
              const EdgeInsets.only(bottom: 0), // Adjust bottom padding
          actions: [
            Column(
              children: [
                // Horizontal Divider (Yellow Line)
                Container(
                  width: double.infinity,
                  height: 1,
                  color: const Color(0xFFFFCC00), // Yellow divider color
                ),
                Row(
                  children: [
                    // Cancel Button with Border
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: const Color(
                                  0xFFFFCC00), // Yellow line between buttons
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.black, // Text color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Ok Button with Border
                    Expanded(
                      child: Container(
                        child: TextButton(
                          onPressed: () {
                            // Action for logout
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Ok',
                            style: TextStyle(
                              color: Colors.black, // Text color
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Show save confirmation dialog
  void _showSaveConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Profile?'),
          content: const Text('Are you sure you want to save your profile?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Action for saving profile
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}

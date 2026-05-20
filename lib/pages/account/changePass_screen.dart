import 'package:dis_app/utils/constants/colors.dart';
import 'package:dis_app/utils/constants/sizes.dart';
import 'package:dis_app/blocs/user/user_bloc.dart';
import 'package:dis_app/blocs/user/user_event.dart';
import 'package:dis_app/blocs/user/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _currentPasswordFocusNode = FocusNode();
  final _newPasswordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _isLoading = false;
  ScaffoldMessengerState? _scaffoldMessenger;
  NavigatorState? _navigator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
    _navigator = Navigator.of(context);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (!mounted) {
          return;
        }

        if (state is UserLoading) {
          setState(() {
            _isLoading = true;
          });
          return;
        }

        if (_isLoading) {
          setState(() {
            _isLoading = false;
          });
        }

        if (state is UserSuccess) {
          _scaffoldMessenger?.showSnackBar(SnackBar(
            content: Text(state.message ?? 'Password changed successfully!'),
            backgroundColor: DisColors.success,
          ));
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _navigator?.pop();
            }
          });
        } else if (state is UserFailure) {
          _scaffoldMessenger?.showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: DisColors.error,
          ));
        }
      },
      builder: (context, state) {
        final isLoading = state is UserLoading || _isLoading;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Change Password',
              style: TextStyle(
                  color: DisColors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: DisColors.white,
            elevation: 0.5,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: DisColors.black),
              onPressed: isLoading
                  ? null
                  : () {
                      Navigator.pop(context);
                    },
            ),
            centerTitle: true,
          ),
          body: AbsorbPointer(
            absorbing: isLoading,
            child: _buildForm(context, isLoading),
          ),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context, bool isLoading) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildTextFieldSection('Current Password',
                    _currentPasswordController, _currentPasswordFocusNode),
                const SizedBox(height: 20),
                _buildTextFieldSection('New Password', _newPasswordController,
                    _newPasswordFocusNode),
                const SizedBox(height: 20),
                _buildTextFieldSection('New Password Confirmation',
                    _confirmPasswordController, _confirmPasswordFocusNode),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : () => _onSavePassword(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: DisColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : const Text(
                      'Save Password',
                      style: TextStyle(color: Colors.black),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldSection(
      String label, TextEditingController controller, FocusNode focusNode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 10),
        _buildTextFormField(controller, 'Enter your $label', focusNode,
            obscureText: true),
      ],
    );
  }

  Widget _buildTextFormField(
      TextEditingController controller, String hintText, FocusNode focusNode,
      {bool obscureText = false}) {
    return Focus(
      focusNode: focusNode,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: DisColors.grey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DisSizes.borderRadiusMd),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: DisSizes.md, vertical: DisSizes.sm),
        ),
      ),
    );
  }

  void _onSavePassword(BuildContext context) {
    final oldPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _scaffoldMessenger?.showSnackBar(const SnackBar(
        content: Text('Please fill in all fields'),
        backgroundColor: DisColors.error,
      ));
      return;
    }

    if (newPassword != confirmPassword) {
      _scaffoldMessenger?.showSnackBar(const SnackBar(
        content: Text('New password and confirmation do not match'),
        backgroundColor: DisColors.error,
      ));
      return;
    }

    BlocProvider.of<UserBloc>(context).add(UserChangePasswordEvent(
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    ));
  }
}

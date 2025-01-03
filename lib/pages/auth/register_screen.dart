import 'dart:async';
import 'package:dis_app/blocs/auth/auth_bloc.dart';
import 'package:dis_app/blocs/auth/auth_event.dart';
import 'package:dis_app/blocs/auth/auth_state.dart';
import 'package:dis_app/common/widgets/alertBanner.dart';
import 'package:dis_app/common/widgets/button.dart';
import 'package:dis_app/common/widgets/checkbox.dart';
import 'package:dis_app/controllers/auth_controller.dart';
import 'package:dis_app/utils/helpers/helper_functions.dart';
import 'package:dis_app/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:dis_app/common/widgets/textFormField.dart';
import 'package:dis_app/utils/constants/colors.dart';
import 'package:dis_app/utils/constants/sizes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _agreeToTerms = false;
  Map<String, dynamic>? _message;

  // Variables for password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
          create: (context) => AuthBloc(authController: AuthController()),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                setState(() {
                  _message = {"error": state.message};
                });
                Timer(const Duration(seconds: 2), () {
                  setState(() {
                    _message = null;
                  });
                });
              } else if (state is AuthSuccess) {
                setState(() {
                  _message = {"success": state.message};
                });
                Timer(const Duration(seconds: 2), () {
                  setState(() {
                    _message = null;
                  });
                });
                DisHelperFunctions.navigateToRoute(context, '/login');
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              return Stack(
                children: [
                  if (_message != null)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: DisAlertBanner(
                          message: _message!["error"] != null
                              ? _message!["error"]
                              : _message!["success"],
                          color: _message!["error"] != null
                              ? DisColors.error
                              : DisColors.success,
                          icon: _message!["error"] != null
                              ? Icons.error
                              : Icons.check_circle),
                    ),
                  // Bagian background dengan curve
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ClipPath(
                      clipper: BottomCurveClipper(),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        color: DisColors.primary,
                      ),
                    ),
                  ),
                  // Bagian form
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.15,
                        left: DisSizes.md,
                        right: DisSizes.md,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(DisSizes.md),
                        decoration: BoxDecoration(
                          color: DisColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: DisColors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 5,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Sign Up Now",
                                style: TextStyle(
                                  fontSize: DisSizes.fontSizeXl,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: DisSizes.xs),
                              const Text(
                                "Discover Your Facial Expressions",
                                style: TextStyle(
                                  fontSize: DisSizes.fontSizeSm,
                                  color: DisColors.darkGrey,
                                ),
                              ),
                              const SizedBox(height: DisSizes.md),
                              // Name Input
                              DisTextFormField(
                                  labelText: "Name",
                                  hintText: "Enter your name",
                                  controller: _nameController,
                                  validator: (value) {
                                    return DisValidator.validateName(value);
                                  }),
                              const SizedBox(height: DisSizes.md),
                              // Email Input
                              DisTextFormField(
                                  labelText: "Email",
                                  hintText: "Enter your email",
                                  controller: _emailController,
                                  validator: (value) {
                                    return DisValidator.validateEmail(value);
                                  }),
                              const SizedBox(height: DisSizes.md),
                              // Phone Number Input
                              const Text(
                                "Phone Number",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        hintText: "Enter your phone number",
                                        hintStyle: const TextStyle(
                                          color: Colors.orange,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade100,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 16),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide.none,
                                        ),
                                        prefixIcon: Container(
                                          width: 70,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            '+62',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        prefixIconConstraints: BoxConstraints(
                                          minWidth: 0,
                                          minHeight: 0,
                                        ),
                                      ),
                                      validator: (value) {
                                        return DisValidator.validatePhone(
                                            value);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: DisSizes.md),
                              // Password Input with Show Password Icon
                              DisTextFormField(
                                  labelText: "Password",
                                  hintText: "Enter your password",
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  showPasswordToggle: true,
                                  validator: (value) {
                                    return DisValidator.validatePassword(value);
                                  }),
                              const SizedBox(height: DisSizes.md),
                              // Confirm Password Input with Show Password Icon
                              DisTextFormField(
                                  labelText: "Confirm Password",
                                  hintText: "Re-enter your password",
                                  controller: _confirmPasswordController,
                                  obscureText: !_isConfirmPasswordVisible,
                                  showPasswordToggle: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Confirm password is required";
                                    }
                                    if (value != _passwordController.text) {
                                      return "Password does not match";
                                    }
                                    return null;
                                  }),
                              const SizedBox(height: DisSizes.md),
                              // Terms & Conditions Checkbox
                              Row(
                                children: [
                                  DisCheckbox(
                                    initialValue: _agreeToTerms,
                                    onChanged: (value) {
                                      setState(() {
                                        _agreeToTerms = value;
                                      });
                                    },
                                    activeColor: DisColors.primary,
                                    checkColor: DisColors.white,
                                  ),
                                  const Text("I agree to the "),
                                  GestureDetector(
                                    onTap: () {
                                      // Handle terms & conditions link tap
                                    },
                                    child: const Text(
                                      "terms & conditions",
                                      style: TextStyle(
                                        color: Color(0xFF3458FB),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: DisSizes.lg),
                              // Sign Up Button
                              DisButton(
                                label: "Sign Up",
                                onTap: () {
                                  print("Sign Up Button Pressed");
                                  if (_formKey.currentState!.validate() &&
                                      _agreeToTerms) {
                                    BlocProvider.of<AuthBloc>(context).add(
                                      AuthRegisterEvent(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        phone: _phoneController.text,
                                      ),
                                    );
                                  }
                                },
                                backgroundColor: DisColors.primary,
                                textColor: DisColors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: DisSizes.fontSizeMd,
                                width: double.infinity,
                              ),

                              const SizedBox(height: DisSizes.md),
                              // Sign In Redirection
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Already have an account?",
                                    style: TextStyle(
                                      fontSize: DisSizes.fontSizeSm,
                                      color: DisColors.darkGrey,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/login');
                                    },
                                    child: const Text(
                                      "Sign In",
                                      style: TextStyle(
                                        fontSize: DisSizes.fontSizeSm,
                                        color: DisColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          )),
    );
  }
}

// Custom Clipper for the top curve design
class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.35, size.height * 0.8,
        size.width * 0.5, size.height * 0.85);
    path.quadraticBezierTo(
        size.width * 0.65, size.height * 0.9, size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

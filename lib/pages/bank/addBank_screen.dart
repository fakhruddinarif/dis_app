import 'package:dis_app/blocs/user/user_bloc.dart';
import 'package:dis_app/blocs/user/user_state.dart';
import 'package:dis_app/common/widgets/alertBanner.dart';
import 'package:dis_app/controllers/user_controller.dart';
import 'package:dis_app/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:dis_app/utils/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/user/user_event.dart';

class AddBankScreen extends StatefulWidget {
  const AddBankScreen({Key? key}) : super(key: key);

  @override
  _AddBankScreenState createState() => _AddBankScreenState();
}

class _AddBankScreenState extends State<AddBankScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  String? _bank;
  bool _isLoading = false;
  NavigatorState? _navigator;
  late final UserBloc _userBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigator = Navigator.of(context);
  }

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc(userController: UserController());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _userBloc.close();
    super.dispose();
  }

  List<String> _listBank = [
    "BANK BRI",
    "BANK MANDIRI",
    "BANK BNI",
    "BANK BCA",
    "BANK BTN",
    "BANK CIMB NIAGA",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DisColors.white,
      appBar: AppBar(
        title: Text(
          "Add Bank Account",
          style: TextStyle(
              color: DisColors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.0),
        ),
        centerTitle: true,
        backgroundColor: DisColors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: DisColors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocProvider.value(
        value: _userBloc,
        child: BlocConsumer<UserBloc, UserState>(
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
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  _navigator?.pop(true);
                }
              });
            }
          },
          builder: (context, state) {
            final isLoading = state is UserLoading || _isLoading;

            return Stack(
              children: [
                if (state is UserSuccess)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: DisAlertBanner(
                      message: state.message!,
                      color: DisColors.success,
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                if (state is UserFailure)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: DisAlertBanner(
                      message: state.message,
                      color: DisColors.error,
                      icon: Icons.error_outline,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AbsorbPointer(
                    absorbing: isLoading,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Full Name",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: DisColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: "Bank account's name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            "Account Number",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: DisColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          TextFormField(
                            controller: _numberController,
                            decoration: InputDecoration(
                              hintText: "Add account number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16.0),
                          const Text(
                            "Bank Name",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: DisColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            hint: const Text("Add bank name"),
                            items: List.generate(_listBank.length, (index) {
                              return DropdownMenuItem(
                                value: _listBank[index],
                                child: Text(_listBank[index]),
                              );
                            }),
                            onChanged: (value) {
                              setState(() {
                                _bank = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return "Please select a bank";
                              }
                              return null;
                            },
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        _userBloc.add(
                                          AddBankEvent(
                                            bank: _bank!,
                                            name: _nameController.text,
                                            number: _numberController.text,
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DisColors.primary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text(
                                isLoading ? "Saving..." : "Save",
                                style: const TextStyle(
                                  color: DisColors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

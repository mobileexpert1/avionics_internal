import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'CustomFiles/CustomTextField.dart';
import 'bloc/forgotPassword/forgot_cubit.dart';
import 'bloc/forgotPassword/forgot_state.dart';

class Forgotscreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<Forgotscreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Forgot Password'),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          centerTitle: true,
          shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                SvgPicture.asset('assets/LogoMain.svg'),
                SizedBox(height: 20),
                BlocSelector<ForgotCubit, ForgotState, String?>(
                  selector: (state) => state.emailError,
                  builder: (context, emailError) {
                    return CustomTextField(
                      label: 'Email',
                      controller: emailController,
                      errorText: emailError,
                      onChanged: (val) =>
                          context.read<ForgotCubit>().emailChanged(val),
                    );
                  },
                ),
                SizedBox(height: 20),

                BlocSelector<ForgotCubit, ForgotState, bool>(
                  selector: (state) => state.isButtonEnabled,
                  builder: (context, isButtonEnabled) {
                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isButtonEnabled
                            ? () {
                                Navigator.pop(context);
                              }
                            : null,
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all(
                            Colors.white,
                          ),
                          backgroundColor: WidgetStateProperty.all(
                            isButtonEnabled
                                ? Color.fromRGBO(63, 61, 81, 1.0)
                                : Colors.grey,
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        child: Text('Send Email Code'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

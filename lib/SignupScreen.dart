import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'CustomFiles/CustomTextField.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';
import 'bloc/signup/signup_cubit.dart';
import 'bloc/signup/signup_state.dart';
import 'package:flutter_svg/svg.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Create your account'),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          centerTitle: true,
          shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: BlocBuilder<SignupCubit, SignupState>(
              builder: (context, state) {
                return Column(
                  children: [
                    SizedBox(height: 20),
                    SvgPicture.asset('assets/Logo.svg'),
                    SizedBox(height: 30),
                    CustomTextField(
                      label: 'First Name',
                      controller: firstNameController,
                      errorText: state.firstNameError,
                      onChanged: (val) =>
                          context.read<SignupCubit>().firstNameChanged(val),
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      label: 'Last Name',
                      controller: lastNameController,
                      errorText: state.lastNameError,
                      onChanged: (val) =>
                          context.read<SignupCubit>().lastNameChanged(val),
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      label: 'Email',
                      controller: emailController,
                      errorText: state.emailError,
                      onChanged: (val) =>
                          context.read<SignupCubit>().emailChanged(val),
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      label: 'Password',
                      controller: passwordController,
                      errorText: state.passwordError,
                      obscureText: true,
                      onChanged: (val) =>
                          context.read<SignupCubit>().passwordChanged(val),
                    ),
                    SizedBox(height: 15),
                    CustomTextField(
                      label: 'Confirm Password',
                      controller: confirmPasswordController,
                      errorText: state.confirmPasswordError,
                      obscureText: true,
                      onChanged: (val) =>
                          context.read<SignupCubit>().confirmPasswordChanged(val),
                    ),
                     SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: state.isButtonEnabled
                            ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        }
                            : null,
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          backgroundColor: MaterialStateProperty.all(
                            state.isButtonEnabled
                                ? Color.fromRGBO(63, 61, 81, 1.0)
                                : Colors.grey,
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        child: Text('Start Subscription'),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        "Already a user? Log in",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

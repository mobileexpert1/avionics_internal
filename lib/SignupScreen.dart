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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    label: 'Email',
                    controller: emailController,
                    errorText: state.emailError,
                    onChanged: (val) =>
                        context.read<SignupCubit>().emailChanged(val),
                  ),
                  SizedBox(height: 10),
                  CustomTextField(
                    label: 'Password',
                    controller: passwordController,
                    errorText: state.passwordError,
                    obscureText: true,
                    onChanged: (val) =>
                        context.read<SignupCubit>().passwordChanged(val),
                  ),
                  SizedBox(height: 10),
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
                      child: Text('Start Subscription'),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side: BorderSide(
                          color: state.isButtonEnabled == true
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                      onPressed: state.isButtonEnabled
                          ? () {
                              print('Signup Successful!');
                            }
                          : null,
                      child: Text('Free Trial 7 days'),
                    ),
                  ),
                  SizedBox(height: 20),
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
    );
  }
}

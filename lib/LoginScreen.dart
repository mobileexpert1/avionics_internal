import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'CustomFiles/CustomTextField.dart';
import 'HomeScreen.dart';
import 'bloc/login/login_cubit.dart';
import 'bloc/login/login_state.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login'),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: BlocBuilder<LoginCubit, LoginState>(
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
                        context.read<LoginCubit>().emailChanged(val),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(
                    label: 'Password',
                    controller: passwordController,
                    errorText: state.passwordError,
                    obscureText: true,
                    onChanged: (val) =>
                        context.read<LoginCubit>().passwordChanged(val),
                  ),
                  SizedBox(height: 20),
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
                      child: Text('Login'),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      // Navigate to login screen
                    },
                    child: Text(
                      "Forgot your password?",
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

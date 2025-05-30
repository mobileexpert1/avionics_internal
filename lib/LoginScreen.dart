import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'HomeScreen.dart';
import 'ForgotScreen.dart';
import 'bloc/login/login_cubit.dart';
import 'bloc/login/login_state.dart';
import 'CustomFiles/CustomTextField.dart';
import 'CustomFiles/CustomBottomButton.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
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
            child: Column(
              children: [
                SizedBox(height: 20),
                SvgPicture.asset('assets/LogoMain.svg'),
                SizedBox(height: 20),

                BlocSelector<LoginCubit, LoginState, String?>(
                  selector: (state) => state.emailError,
                  builder: (context, emailError) {
                    return CustomTextField(
                      label: 'Email',
                      controller: emailController,
                      errorText: emailError,
                      onChanged: (val) =>
                          context.read<LoginCubit>().emailChanged(val),
                    );
                  },
                ),
                SizedBox(height: 15),

                BlocSelector<LoginCubit, LoginState, String?>(
                  selector: (state) => state.passwordError,
                  builder: (context, passwordError) {
                    return CustomTextField(
                      label: 'Password',
                      controller: passwordController,
                      obscureText: true,
                      errorText: passwordError,
                      onChanged: (val) =>
                          context.read<LoginCubit>().passwordChanged(val),
                    );
                  },
                ),
                SizedBox(height: 30),

                BlocSelector<LoginCubit, LoginState, bool>(
                  selector: (state) => state.isButtonEnabled,
                  builder: (context, isButtonEnabled) {
                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isButtonEnabled
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
                        child: Text('Login'),
                      ),
                    );
                  },
                ),

                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Forgotscreen()),
                    );
                  },
                  child: Text(
                    "Forgot your password?",
                    style: TextStyle(color: Color.fromRGBO(63, 61, 81, 1.0)),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Or Continue with",
                  style: TextStyle(color: Color.fromRGBO(63, 61, 81, 1.0)),
                ),
                SizedBox(height: 12),

                CustomBottomButton(
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  title: "Log in with Google",
                  icon: SvgPicture.asset('assets/Google.svg'),
                  onPressed: () {
                    // Google login
                  },
                ),
                SizedBox(height: 12),

                CustomBottomButton(
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  title: "Log in with Apple",
                  icon: SvgPicture.asset('assets/Apple.svg'),
                  onPressed: () {
                    // Apple login
                  },
                ),
                SizedBox(height: 12),

                CustomBottomButton(
                  backgroundColor: Color(0xFF1877F2),
                  textColor: Colors.white,
                  title: "Log in with Facebook",
                  icon: SvgPicture.asset('assets/Facebook.svg'),
                  onPressed: () {
                    // Facebook login
                  },
                ),
                SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(color: Color.fromRGBO(63, 61, 81, 1.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:bonevision/bloc/login/login_cubit.dart';
import 'package:bonevision/bloc/register_cubit.dart';
import 'package:bonevision/bloc/user/user_cubit.dart';
import 'package:bonevision/component/custom_button.dart';
import 'package:bonevision/component/custom_form_text_field.dart';
import 'package:bonevision/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordObscured = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    var cubit = LoginCubit.get(context);
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state)async{
        if (state is LoginSuccessState){
          await UserCubit.get(context).getUserData();
          await UserCubit.get(context).receiverUserData();
          RegisterCubit.get(context).showSnackBar(context, "Logged in Successfully");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreen()));
        } else if (state is LoginErrorState) {
          RegisterCubit.get(context).showSnackBar(context, cubit.error.toString());
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xfffafafa),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(width: screenWidth, height: screenHeight * 0.3,),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Bone',
                            style: TextStyle(
                                color: Color(0xff97dfe3),
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.09),
                          ),
                          TextSpan(
                            text: 'Vision',
                            style: TextStyle(
                                color: Color(0xffa9a9a9),
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.09),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.8,
                    margin: EdgeInsets.only(bottom: screenHeight * 0.02,top: screenHeight*0.02),
                    child: CustomTextFormField(
                      hint: "Email",
                      controller: emailController,
                      label: "Email",
                      obscureText: false,
                      readOnly: false,
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.8,
                    margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: CustomTextFormField(
                      hint: "Password",
                      controller: passwordController,
                      label: "Password",
                      obscureText: _isPasswordObscured,
                      icon: IconButton(
                          onPressed: () {
                            setState(() {
                              _togglePasswordVisibility();
                            });
                          },
                          icon: Icon(_isPasswordObscured
                              ? Icons.visibility
                              : Icons.visibility_off)),
                      iconColor:
                      _isPasswordObscured ? Color(0xff38a7ab) : Colors.grey,
                      readOnly: false,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.05),
                    child: CustomButton(
                        screenWidth: screenWidth * 0.8,
                        screenHeight: screenHeight * 0.075,
                        text: "Login",
                        onpressed: () {
                          cubit.signInWithEmail(emailController.text, passwordController.text);
                        },
                        bColor: Color(0xff97dfe3),
                        tColor: Color(0xff232425),
                        fontSize: screenWidth * 0.075,
                        radius: 20),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Forgot your password?",
                  style: TextStyle(
                      color: Color(0xff87e3f2),
                      fontSize: screenWidth * 0.06),
                ),
              )
            ]),
          ),
        );
      },
    );
  }
}

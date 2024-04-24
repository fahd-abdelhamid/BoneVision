import 'package:bonevision/bloc/login/login_cubit.dart';
import 'package:bonevision/component/custom_button.dart';
import 'package:bonevision/component/custom_form_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var cubit = LoginCubit.get(context);
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xfffafafa),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_outlined)),
                ],
              ),
              Column(
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.04, horizontal: 16),
                      child: Column(
                        children: [
                          Text(
                            "Forgot your Password?",
                            style: GoogleFonts.nunito(
                                fontSize: 18.sp, color: Color(0xff232425)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Don't Worry it happens, Please enter the email linked with your account.",
                              style: GoogleFonts.nunito(
                                  fontSize: 12.sp, color: Color(0xff8c8c8c)),
                            ),
                          ),
                        ],
                      )),
                  Container(
                    width: screenWidth * 0.8,
                    margin: EdgeInsets.only(bottom: screenHeight * 0.05),
                    child: Column(
                      children: [
                        CustomTextFormField(
                          hint: "Enter your Email Address",
                          controller: emailController,
                          readOnly: false, obscureText: false, label: 'Password',
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    screenWidth: screenWidth * 0.5,
                    screenHeight: screenHeight * 0.075,
                    text: 'Reset Password',
                    onpressed: () {
                      cubit.resetUserPassword(emailController.text);
                    },
                    fontSize: 14.sp, bColor: Color(0xff97dfe3),
                    tColor: Color(0xff232425), radius: 20,
                  ),
                ],
              )
            ]),
          ),
        );
      },
    );
  }
}
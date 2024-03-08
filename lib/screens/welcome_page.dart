import 'package:bonevision/component/custom_button.dart';
import 'package:bonevision/screens/login_screen.dart';
import 'package:bonevision/screens/register_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage("assets/images/img.png"), fit: BoxFit.cover)
        // ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Have a great experience with",
                style: TextStyle(
                    color: Color(0xffa9a9a9),
                    fontWeight: FontWeight.w500,
                    fontSize: screenWidth * 0.065),
              ),
              RichText(
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
              Container(
                height: screenHeight * 0.6,
                width: screenWidth,
              ),
              CustomButton(
                  radius: 20,
                  screenWidth: screenWidth * 0.8,
                  screenHeight: screenHeight * 0.075,
                  text: "Create Account",
                  onpressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()));
                  },
                  bColor: Color(0xff97dfe3),
                  tColor: Color(0xff232425),
                  fontSize: screenWidth * 0.075),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              CustomButton(
                  radius: 20,
                  screenWidth: screenWidth * 0.8,
                  screenHeight: screenHeight * 0.075,
                  text: "Login",
                  onpressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  bColor: Color(0xff284448),
                  tColor: Color(0xffFAFAFA),
                  fontSize: screenWidth * 0.075),
            ],
          ),
        ),
      ),
    );
  }
}

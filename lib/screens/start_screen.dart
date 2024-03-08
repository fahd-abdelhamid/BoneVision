import 'package:bonevision/component/custom_button.dart';
import 'package:bonevision/screens/welcome_page.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight * 0.2,
            decoration: BoxDecoration(
              color: Color(0xff97dfe3),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(65)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("WELCOME!",
                      style: TextStyle(
                          color: Color(0xff232425),
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.08148148148)),
                  Text("Get your report immediately",
                      style: TextStyle(
                          color: Color(0xff232425),
                          fontWeight: FontWeight.w500,
                          fontSize: screenWidth * 0.05))
                ],
              ),
            ),
          ),
          Container(
            height: screenHeight * 0.6,
            width: screenWidth,
            child: Column(),
          ),
          CustomButton(radius: 10,
              screenWidth: screenWidth * 0.8,
              screenHeight: screenHeight * 0.075,
              text: "Let's Start",
              onpressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()));
              },
              bColor: Color(0xff97dfe3),
              tColor: Color(0xff232425),
              fontSize: screenWidth * 0.1),
          SizedBox(height: screenHeight * 0.03),
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
          )
        ],
      ),
    );
  }
}

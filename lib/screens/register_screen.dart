import 'package:bonevision/bloc/register_cubit.dart';
import 'package:bonevision/component/custom_button.dart';
import 'package:bonevision/component/custom_form_text_field.dart';
import 'package:bonevision/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordObscured = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var usernameController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var genderController = TextEditingController();
  var dateController = TextEditingController();
  DateTime? date;
  List<DropdownMenuEntry<String>> genders = [
    const DropdownMenuEntry(value: "Male", label: "Male"),
    const DropdownMenuEntry(value: "Female", label: "Female"),
  ];
  late MemoryImage? _selectedImage;

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
    var cubit = RegisterCubit.get(context);
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          cubit.showSnackBar(context, "Account Created Successfully");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        } else if (state is RegisterErrorState) {
          cubit.showSnackBar(context, state.error.toString());
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
                    margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: CustomTextFormField(
                      hint: "UserName",
                      controller: usernameController,
                      label: "UserName",
                      obscureText: false,
                      readOnly: false,
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.8,
                    margin: EdgeInsets.only(bottom: screenHeight * 0.02),
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
                  DropdownMenu<String>(
                      width: screenWidth * 0.8,
                      inputDecorationTheme: InputDecorationTheme(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          constraints:
                          BoxConstraints(maxHeight: screenHeight * 0.075),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                              const BorderSide(color: Colors.black)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                              const BorderSide(color: Colors.black))),
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Gender",
                          style: TextStyle(
                              fontSize: 18, color: const Color(0xff38a7ab)),
                        ),
                      ),
                      controller: genderController,
                      dropdownMenuEntries: genders,
                      onSelected: (value) {
                        genderController.text = value!;
                        print(genderController.text);
                      }),
                  Container(
                    width: screenWidth * 0.8,
                    margin: EdgeInsets.only(top: screenHeight * 0.02),
                    child: CustomTextFormField(controller: dateController,
                        icon: IconButton(
                            onPressed: () async {
                              date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2000),
                                  firstDate: DateTime(1930),
                                  lastDate: DateTime(2014));
                              if (date != null) {
                                dateController.text =
                                    DateFormat('d/M/yyyy').format(date!);
                              }
                            },
                            icon: Icon(Icons.date_range,
                                color: Color(0xff38a7ab))),
                        readOnly: true,
                        hint: "31/1/2001",
                        label: "DateOfBirth",
                        obscureText: false),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.05),
                    child: CustomButton(
                        screenWidth: screenWidth * 0.8,
                        screenHeight: screenHeight * 0.075,
                        text: "Register",
                        onpressed: () {
                          cubit.registerUser(
                              emailController.text, passwordController.text, usernameController.text, genderController.text,
                              date);
                        },
                        bColor: Color(0xff97dfe3),
                        tColor: Color(0xff232425),
                        fontSize: screenWidth * 0.075,
                        radius: 20),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                        color: Color(0xff232425), fontSize: screenWidth * 0.05),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) =>LoginScreen()));
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Color(0xff38a7ab),
                          fontSize: screenWidth * 0.06),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStatePropertyAll(EdgeInsets.zero),
                    ),
                  )
                ],
              )
            ]),
          ),
        );
      },
    );
  }
}

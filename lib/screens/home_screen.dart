import 'dart:io';

import 'package:bonevision/bloc/user/user_cubit.dart';
import 'package:bonevision/screens/images_screen.dart';
import 'package:bonevision/screens/profile_screen.dart';
import 'package:bonevision/screens/support_screen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    var cubit = UserCubit.get(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        color: Color(0xff363636),
        backgroundColor: Color(0xff87e3f2),
        style: TabStyle.fixedCircle,
        items: [
          TabItem(icon: Icons.home_outlined, activeIcon: Icon(Icons.home)),
          TabItem(icon: Icons.image_outlined, activeIcon: Icon(Icons.image)),
          TabItem(icon: Icons.add),
          TabItem(
              icon: Icons.support_agent_outlined,
              activeIcon: Icon(Icons.support_agent)),
          TabItem(icon: Icons.person_outline, activeIcon: Icon(Icons.person)),
        ],
        initialActiveIndex: _activeIndex,
        onTap: (int i)async => {
        if (i == 2) {
          await cubit.pickImage(),
        setState(() => _activeIndex = 0)
    } else {
    setState(() => _activeIndex = i)
    }
    },
      ),
      body: IndexedStack(
        index: _activeIndex,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hey! Welcome",
                          style: TextStyle(
                              fontSize: screenWidth * 0.075,
                              color: Color(0xff232425)),
                        ),
                        Text(cubit.userName!,
                            style: TextStyle(
                                fontSize: screenWidth * 0.075,
                                color: Color(0xff232425))),
                      ],
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.menu,
                          size: 32,
                        ))
                  ],
                ),
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.05,
                  color: Color(0xff87e3f2),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text("Upload Image",
                            style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Color(0xff232425))),
                      )
                    ],
                  ),
                ),
                cubit.file!=null?Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: screenWidth * 0.92,
                  height: screenHeight * 0.3,
                  child: Image.file(File(cubit.file!.path),fit: BoxFit.fitHeight,),
                ) :Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: screenWidth * 0.92,
                  height: screenHeight * 0.3,
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_search_rounded,
                        color: Colors.grey[400],
                        size: 150,
                      ),
                      Text("UPLOAD IMAGE",
                          style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.05,
                  color: Color(0xff87e3f2),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text("Last Uploaded",
                            style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Color(0xff232425))),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          // Content for Image tab (index 1)
          ImagesScreen(),
          // Content for Add tab (index 2)
          SizedBox.shrink(),
          // Content for Support tab (index 3)
          SupportScreen(),
          // Content for Profile tab (index 4)
          ProfileScreen(),
        ],
      ),
    );
  }
}

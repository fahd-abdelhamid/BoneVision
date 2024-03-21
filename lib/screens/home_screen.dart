  import 'dart:io';

  import 'package:bonevision/bloc/user/user_cubit.dart';
  import 'package:bonevision/component/custom_button.dart';
  import 'package:bonevision/screens/images_screen.dart';
  import 'package:bonevision/screens/profile_screen.dart';
  import 'package:bonevision/screens/support_screen.dart';
  import 'package:convex_bottom_bar/convex_bottom_bar.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:google_fonts/google_fonts.dart';

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
      return Scaffold(
        appBar: AppBar(
          leadingWidth: 200.w,
          toolbarHeight: 60.h,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hey! Welcome",
                    style: GoogleFonts.prompt(
                        fontSize: 20.w, color: Color(0xff232425))),
                Text(cubit.userName??"",
                    style: GoogleFonts.prompt(
                        fontSize: 20.w, color: Color(0xff232425))),
              ],
            ),
          ),
        ),
        endDrawer: Drawer(
          backgroundColor: Color(0xfffafafa),
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Color(0xff86E3EF)),
                  accountName: Text(
                    "Name: ${cubit.userName?? ""}",
                    style: GoogleFonts.prompt(
                        fontSize: 16.w, color: Color(0xff232425)),
                  ),
                  accountEmail: Text("Email: ${cubit.user?.email?? ""}",
                      style: GoogleFonts.prompt(
                          fontSize: 16.w, color: Color(0xff232425)))),
              CustomButton(
                  screenWidth: 200.w,
                  screenHeight: 40.h,
                  text: "Account",
                  onpressed: () {
                    setState(() {
                      _activeIndex=4;
                    });
                    Navigator.pop(context);
                  },
                  bColor: Color(0xffd9d9d9),
                  tColor: Color(0xff232425),
                  fontSize: 20.w,
                  radius: 30),
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 15.h),
                child: CustomButton(
                    screenWidth: 200.w,
                    screenHeight: 40.h,
                    text: "Help Center",
                    onpressed: () {},
                    bColor: Color(0xffd9d9d9),
                    tColor: Color(0xff232425),
                    fontSize: 20.w,
                    radius: 30),
              ),
              CustomButton(
                  screenWidth: 200.w,
                  screenHeight: 40.h,
                  text: "Settings",
                  onpressed: () {},
                  bColor: Color(0xffd9d9d9),
                  tColor: Color(0xff232425),
                  fontSize: 20.w,
                  radius: 30),
              Padding(
                padding: EdgeInsets.only(top: 30.h),
                child: CustomButton(
                    screenWidth: 200.w,
                    screenHeight: 40.h,
                    text: "Logout",
                    onpressed: () {
                      cubit.userSignOut(context);
                    },
                    bColor: Color(0xff86E3EF),
                    tColor: Color(0xff232425),
                    fontSize: 20.w,
                    radius: 30),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ConvexAppBar(activeColor: Color(0xff86E3EF),
          color: Color(0xffFAFAFA),
          backgroundColor: Color(0xff284448),
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
          onTap: (int i) async => {
            if (i == 2)
              {await cubit.pickImage(), setState(() => _activeIndex = 0)}
            else
              {setState(() => _activeIndex = i)}
          },
        ),
        body: IndexedStack(
          index: _activeIndex,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 1.sw,
                    height: 35.h,
                    color: Color(0xff87e3f2),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 12.0.w),
                          child: Text("Upload Image",
                              style: GoogleFonts.prompt(
                                  fontSize: 20.w, color: Color(0xff232425))),
                        )
                      ],
                    ),
                  ),
                  cubit.file != null
                      ? Container(
                          margin: EdgeInsets.symmetric(vertical: 20.h),
                          width: 320.w,
                          height: 220.h,
                          child: Image.file(
                            File(cubit.file!.path),
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.symmetric(vertical: 20.h),
                          width: 340.w,
                          height: 220.h,
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_search_rounded,
                                color: Colors.grey[400],
                                size: 150.w,
                              ),
                              Text("UPLOAD IMAGE",
                                  style: TextStyle(
                                      fontSize: 20.w,
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                  Container(
                    width: 1.sw,
                    height: 35.h,
                    color: Color(0xff87e3f2),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 12.0.w),
                          child: Text("Last Uploaded",
                              style: GoogleFonts.prompt(
                                  fontSize: 20.w, color: Color(0xff232425))),
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

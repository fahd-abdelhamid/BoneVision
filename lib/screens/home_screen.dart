import 'dart:io';

import 'package:bonevision/bloc/login/login_cubit.dart';
import 'package:bonevision/bloc/user/user_cubit.dart';
import 'package:bonevision/component/custom_button.dart';
import 'package:bonevision/model/nav_model.dart';
import 'package:bonevision/component/navbar.dart';
import 'package:bonevision/screens/images_screen.dart';
import 'package:bonevision/screens/login_screen.dart';
import 'package:bonevision/screens/profile_screen.dart';
import 'package:bonevision/screens/settings_screen.dart';
import 'package:bonevision/screens/support_screen.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  int selectedTab = 0;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeNavKey = GlobalKey<NavigatorState>();
  final historyNavKey = GlobalKey<NavigatorState>();
  final doctorNavKey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();
  int _activeIndex = 0;
  List<NavModel> items = [];

  @override
  void initState() {
    UserCubit.get(context).showNav = true;
    widget.selectedTab = 0;
    items = [
      NavModel(
          page: TabPage(
            tab: 1,
          ),
          navKey: homeNavKey),
      NavModel(
          page: TabPage(
            tab: 2,
          ),
          navKey: historyNavKey),
      NavModel(
          page: TabPage(
            tab: 3,
          ),
          navKey: doctorNavKey),
      NavModel(
          page: TabPage(
            tab: 4,
          ),
          navKey: profileNavKey),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = UserCubit.get(context);
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state)async {
        if (state is UserLogOutState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
        }
        if(state is PickImageSuccess){
         await Future.delayed(Duration(seconds: 1));
          setState(() {

          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: widget.selectedTab,
            children: items
                .map((page) => Navigator(
                      key: page.navKey,
                      onGenerateInitialRoutes: (navigator, initialRoute) {
                        return [
                          MaterialPageRoute(builder: (context) => page.page)
                        ];
                      },
                    ))
                .toList(),
          ),
          bottomNavigationBar: cubit.showNav
              ? NavBar(
                  pageIndex: widget.selectedTab,
                  onTap: (index) {
                    if (index == widget.selectedTab) {
                      items[index]
                          .navKey
                          .currentState
                          ?.popUntil((route) => route.isFirst);
                    } else {
                      setState(() {
                        widget.selectedTab = index;
                      });
                    }
                  },
                )
              : null,
          // ConvexAppBar(activeColor: Color(0xff86E3EF),
          //   color: Color(0xffFAFAFA),
          //   backgroundColor: Color(0xff284448),
          //   style: TabStyle.fixedCircle,
          //   items: [
          //     TabItem(icon: Icons.home_outlined, activeIcon: Icon(Icons.home)),
          //     TabItem(icon: Icons.image_outlined, activeIcon: Icon(Icons.image)),
          //     TabItem(icon: Icons.add),
          //     TabItem(
          //         icon: Icons.support_agent_outlined,
          //         activeIcon: Icon(Icons.support_agent)),
          //     TabItem(icon: Icons.person_outline, activeIcon: Icon(Icons.person)),
          //   ],
          //   initialActiveIndex: _activeIndex,
          //   onTap: (int i) async => {
          //     if (i == 2)
          //       {await cubit.pickImage(), setState(() => _activeIndex = 0)}
          //     else
          //       {setState(() => _activeIndex = i)}
          //   },
          // ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: cubit.showNav
              ? Container(
                  margin: EdgeInsets.only(top: 20.h),
                  height: 64,
                  width: 64,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    onPressed: ()async{
                      if (cubit.file==null) {
                        await cubit.pickImage();
                        setState(() {
                        });
                      }else{
                        print("Confirm");
                      }
                    },
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 3, color: Color(0xff284448)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      size: 32.sp,
                    cubit.file==null?Icons.add:Icons.check,
                      color: Color(0xff284448),
                    ),
                  ),
                )
              : null,

          // IndexedStack(
          //   index: _activeIndex,
          //   children: [

          //     // Content for Image tab (index 1)
          //     ImagesScreen(),
          //     // Content for Add tab (index 2)
          //     SizedBox.shrink(),
          //     // Content for Support tab (index 3)
          //     SupportScreen(),
          //     // Content for Profile tab (index 4)
          //     ProfileScreen(),
          //   ],
          // ),
        );
      },
    );
    //     ),
  }
}

class TabPage extends StatefulWidget {
  final int tab;
  const TabPage({Key? key, required this.tab}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  @override
  Widget build(BuildContext context) {
    var cubit = UserCubit.get(context);
    if (widget.tab == 1) {
      return BlocConsumer<UserCubit,UserState>(listener: (context, state) {
        if(state is PickImageSuccess){
          setState(() {
          });
        }
      },
  builder: (context, state) {
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
                  Text(LoginCubit.get(context).userName ?? "",
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
                      "Name: ${LoginCubit.get(context).userName ?? ""}",
                      style: GoogleFonts.prompt(
                          fontSize: 16.w, color: Color(0xff232425)),
                    ),
                    accountEmail: Text(
                        "Email: ${LoginCubit.get(context).user?.email ?? ""}",
                        style: GoogleFonts.prompt(
                            fontSize: 16.w, color: Color(0xff232425)))),
                CustomButton(
                    screenWidth: 200.w,
                    screenHeight: 40.h,
                    text: "Account",
                    onpressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()));
                    },
                    bColor: Color(0xffd9d9d9),
                    tColor: Color(0xff232425),
                    fontSize: 20.w,
                    radius: 30),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: CustomButton(
                      screenWidth: 200.w,
                      screenHeight: 40.h,
                      text: "Help Center",
                      onpressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      bColor: Color(0xffd9d9d9),
                      tColor: Color(0xff232425),
                      fontSize: 20.w,
                      radius: 30),
                ),
                CustomButton(
                    screenWidth: 200.w,
                    screenHeight: 40.h,
                    text: "Settings",
                    onpressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen()));
                    },
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
                        cubit.showNavFalse();
                        cubit.userSignOut(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                      },
                      bColor: Color(0xff86E3EF),
                      tColor: Color(0xff232425),
                      fontSize: 20.w,
                      radius: 30),
                ),
              ],
            ),
          ),
          body: Padding(
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
                      ? GestureDetector(onTap: ()async{
                       await cubit.pickImage();
                      },
                        child: Container(
                            margin: EdgeInsets.symmetric(vertical: 20.h),
                            width: 320.w,
                            height: 220.h,
                            child: Image.file(
                              File(cubit.file!.path),
                              fit: BoxFit.fitHeight,
                            ),
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
              )));
  },
);
    } else if (widget.tab == 2) {
      return ImagesScreen();
    } else if (widget.tab == 3) {
      return SupportScreen();
    } else {
      return ProfileScreen();
    }
  }
}

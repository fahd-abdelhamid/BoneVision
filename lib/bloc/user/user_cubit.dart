import 'package:bloc/bloc.dart';
import 'package:bonevision/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());
  static UserCubit get(context) => BlocProvider.of(context);
  String? userEmail;
  String? userName;
  String? gender;
  String? password;
  User? user;
  XFile? file;
  Timestamp? date;

  DateTime timestampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  int calculateAge(DateTime dateOfBirth) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - dateOfBirth.year;
    if (currentDate.month < dateOfBirth.month ||
        (currentDate.month == dateOfBirth.month && currentDate.day < dateOfBirth.day)) {
      age--;
    }

    return age;
  }

  getUserData() {
    user = FirebaseAuth.instance.currentUser;
    print(user?.email ?? "de7ka");
    emit(GetUserDataState());
  }

  Future receiverUserData() async {
    emit(ReceiveUserNameLoadingState());
    try {
      QuerySnapshot<
          Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: user!.email!)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        userName = querySnapshot.docs.first.get("username");
        gender=querySnapshot.docs.first.get("gender");
        password=querySnapshot.docs.first.get("password");
        date=querySnapshot.docs.first.get("date");
        emit(ReceiveUserNameSuccessState());
        print("de7k");
        print(date);
      } else {
        emit(ReceiveUserNameErrorState());
        print("error");
      }
    } catch (e) {
      emit(ReceiveUserNameErrorState());
      print(e);
    }
  }

  pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return await file!.readAsBytes();
    } else {
      print("No Image Selected");
    }
  }

  userSignOut(context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}

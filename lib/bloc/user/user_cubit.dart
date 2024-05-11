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
  XFile? file;
  bool showNav=true;
  showNavFalse(){
    showNav=false;
    emit(ShowNavFalseState());
  }
  showNavTrue(){
    showNav=true;
    emit(ShowNavFalseState());
  }
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

  pickImage() async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      file = await imagePicker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        emit(PickImageSuccess());
        return await file!.readAsBytes();
      } else {
        print("No Image Selected");
      }
    } on Exception catch (e) {
      // TODO
    }
  }

  userSignOut(context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  emit(UserLogOutState());
  }
  changeUserPassword(oldPassword, newPassword) {
    emit(ChangeUserPasswordLoadingState());
    AuthCredential credential = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!, password: oldPassword);
    FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential)
        .then((_) {
      FirebaseAuth.instance.currentUser!.updatePassword(newPassword).then((_) {
        print('Password updated successfully');
        updateUserPassword(newPassword);
        emit(ChangeUserPasswordSuccessState());
      }).catchError((error) {
        print('Error updating password: $error');
        emit(ChangeUserPasswordErrorState());
      });
    }).catchError((error) {
      print('Error re-authenticating user: $error');
      emit(ChangeUserPasswordErrorState());
    });
  }
  updateUserPassword(newPassword) {
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get().then((QuerySnapshot querySnapshot) {
      var doc = querySnapshot.docs.first;
      doc.reference.update({'password': newPassword}).then((value) => print("Password Updated Successfully"))
          .catchError((error)=>print("Failed To Update Password"));
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:meta/meta.dart';
import 'package:google_sign_in/google_sign_in.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  static LoginCubit get(context) => BlocProvider.of(context);
  String? error;
  bool? isExist;
  String? userEmail;
  String? userName;
  String? gender;
  String? password;
  User? user;
  Timestamp? date;
  signInWithEmail(email,password)async{
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      emit(LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error='No user found for that email.';
        emit(LoginErrorState(error));
      } else if (e.code == 'wrong-password') {
        error='Wrong password provided for that user.';
        emit(LoginErrorState(error));
      }else{
        error=e.message!;
        emit(LoginErrorState(error));
      }
    }
  }
  getUserData() {
    emit(LoginLoadingState());
    try {
      user = FirebaseAuth.instance.currentUser;
      print(user?.email ?? "de7ka");
      emit(GetUserDataState());
    } on Exception catch (e) {
      print(e);
    }
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
  Future<User?> googleSignin() async {
    emit(LoginLoadingState());
    try {
      final googleSignIn = GoogleSignIn(scopes: ['email']);

      // Sign out the user to ensure they can choose an account each time
      await googleSignIn.signOut();

      final googleAccount = await googleSignIn.signIn();

      if (googleAccount != null) {
        final googleAuth = await googleAccount.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

        return userCredential.user;
      } else {
        return null;
      }
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }
  doesEmailExist(String email) async {
    emit(LoginLoadingState());
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      QuerySnapshot querySnapshot = await users.where('email', isEqualTo: email).get();
      print(querySnapshot.docs.isNotEmpty);
      isExist=querySnapshot.docs.isNotEmpty;
    } on Exception catch (e) {
      print(e);
    }

  }
  Future resetUserPassword(String email)async{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) => print("success"));
  }
  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(loginResult.accessToken!.token);
      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }
}

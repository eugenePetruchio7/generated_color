import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

enum AppState {
  initial,
  authenticated,
}

class AuthService extends GetxService {
  final Rx<AppState> appState = AppState.initial.obs;

  Future<AuthService> init() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      appState.value = AppState.authenticated;
    } else {
      appState.value = AppState.initial;
    }
    return this;
  }

  Future<String> register(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      appState.value = AppState.authenticated;
      return '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return e.toString();
    }
    return '';
  }

  Future<String> login(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      appState.value = AppState.authenticated;
      return '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
    return '';
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    appState.value = AppState.initial;
  }
}

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  String username = "";

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } 
    catch (e) {
      print("Some Error ${e}");
    }
  }
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
      
    } 
    catch (e) {
      print("Some Error ${e}");
    }
  }
  Future<User?> setUserName(String username) async {
    username = username;
  }
  
  Future<String> getUserName() async {
    return username;
  }
  
}
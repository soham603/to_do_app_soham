import 'package:firebase_auth/firebase_auth.dart';
import 'package:play_store/data/firestore.dart';

abstract class AuthenticationDataSource {
  Future<void> register(String mailcontroller, String passwordcontroller,
      String passconfirmcontroller);
  Future<void> login(String mailcontroller, String passwordcontroller);
}

class AuthenticationRemote extends AuthenticationDataSource {
  @override
  Future<void> login(String mailcontroller, String passwordcontroller) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: mailcontroller.trim(), password: passwordcontroller.trim());
  }

  @override
  Future<void> register(String mailcontroller, String passwordcontroller,
      String passconfirmcontroller) async {
    if (passwordcontroller == passconfirmcontroller) {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: mailcontroller.trim(), password: passwordcontroller.trim())
          .then((value) {
        Firestore_Datasource().CreateUser(mailcontroller);
      });
    }
  }
}

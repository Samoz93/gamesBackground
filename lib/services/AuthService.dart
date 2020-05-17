import 'package:backgrounds/Tools/BaseProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends BaseProvider {
  final _auth = FirebaseAuth.instance;

  Stream<String> user;
  AuthService() {
    user = _auth.onAuthStateChanged.map((event) => event.uid);
    _loginAnonymously();
  }

  _loginAnonymously() async {
    if (await _auth.currentUser() != null) return;
    await _auth.signInAnonymously();
    notifyListeners();
  }
}

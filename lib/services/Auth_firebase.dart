import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFirebase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// ✅ Ambil user yang sedang login
  User? getUser() => _firebaseAuth.currentUser;

  /// ✅ Cek apakah ada user login
  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  /// ✅ Sign Up Email & Password
  Future<String?> signUp(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Email sudah terdaftar.';
        case 'invalid-email':
          return 'Format email tidak valid.';
        case 'weak-password':
          return 'Password terlalu lemah.';
        default:
          return 'Terjadi kesalahan: ${e.message}';
      }
    } catch (e) {
      return 'Kesalahan tidak diketahui: $e';
    }
  }

  /// ✅ Login Email & Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("❌ Error login email: ${e.message}");
      return null;
    }
  }

  /// ✅ Login menggunakan Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // User batal login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print("❌ Error Google Sign-In: $e");
      return null;
    }
  }

  /// ✅ Logout dari semua akun (Email & Google)
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      print("❌ Error Sign Out: $e");
    }
  }
}

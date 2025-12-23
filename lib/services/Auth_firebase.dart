// auth_firebase.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFirebase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // =====================================================
  // GET CURRENT USER
  // =====================================================
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  // =====================================================
  // ✅ SIGN UP EMAIL + PASSWORD (NAMA & EMAIL SAJA)
  // =====================================================
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // 1️⃣ BUAT AKUN AUTH
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) return null;

      // 2️⃣ SET DISPLAY NAME
      await user.updateDisplayName(name);
      await user.reload();

      // 3️⃣ SIMPAN DATA MINIMAL KE FIRESTORE
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,

        // DIISI SAAT EDIT PROFIL
        'phone': '',
        'jenisKelamin': '',
        'asalSekolah': '',
        'alamat': '',
        'imagePath': '',

        'createdAt': FieldValue.serverTimestamp(),
      });

      return _auth.currentUser;
    } catch (e) {
      print('❌ Error SignUp: $e');
      return null;
    }
  }

  // =====================================================
  // ✅ LOGIN EMAIL & PASSWORD
  // =====================================================
  Future<User?> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print('❌ Login error: $e');
      return null;
    }
  }

  // =====================================================
  // ✅ LOGIN GOOGLE + AUTO BUAT DATA FIRESTORE
  // =====================================================
  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) return null;

      // ✅ CEK DATA FIRESTORE
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'phone': '',
          'jenisKelamin': '',
          'asalSekolah': '',
          'alamat': '',
          'imagePath': '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      print('❌ Google Sign-In Error: $e');
      return null;
    }
  }

  // =====================================================
  // ✅ LOGOUT
  // =====================================================
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

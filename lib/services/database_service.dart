import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/catatan.dart';
import '../models/quiz_result.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();

  DatabaseService._init();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Get current userId
  String _getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');
    return user.uid;
  }

  // ============================================
  // CATATAN OPERATIONS (USER ISOLATED)
  // ============================================

  Future<void> insertCatatan(Catatan catatan) async {
    final userId = _getCurrentUserId();
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('catatan')
        .doc(catatan.id);

    await docRef.set(catatan.toMap());
  }

  Future<List<Catatan>> getAllCatatan() async {
    final userId = _getCurrentUserId();
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('catatan')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Catatan.fromMap(doc.data())).toList();
  }

  Future<void> updateCatatan(Catatan catatan) async {
    final userId = _getCurrentUserId();
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('catatan')
        .doc(catatan.id);

    await docRef.update(catatan.toMap());
  }

  Future<void> deleteCatatan(String id) async {
    final userId = _getCurrentUserId();
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('catatan')
        .doc(id);

    await docRef.delete();
  }

  // ============================================
  // QUIZ RESULTS OPERATIONS (USER ISOLATED)
  // ============================================

  Future<void> saveQuizResult(QuizResult result) async {
    final userId = _getCurrentUserId();
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('quiz_results')
        .doc(result.babId);

    await docRef.set(result.toMap());
  }

  Future<Map<String, QuizResult>> getQuizResults() async {
    final userId = _getCurrentUserId();
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('quiz_results')
        .get();

    return {
      for (var doc in snapshot.docs) doc.id: QuizResult.fromMap(doc.data()),
    };
  }

  Future<void> deleteQuizResult(String babId) async {
    final userId = _getCurrentUserId();
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('quiz_results')
        .doc(babId);

    await docRef.delete();
  }

  Future<void> deleteAllQuizResults() async {
    final userId = _getCurrentUserId();
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('quiz_results')
        .get();

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // ============================================
  // FRIENDS OPERATIONS (USER ISOLATED)
  // ============================================

  Future<void> insertFriend(Map<String, dynamic> friendData) async {
    final userId = _getCurrentUserId();
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(friendData['id']);

    await docRef.set(friendData);
  }

  Future<List<Map<String, dynamic>>> getAllFriends() async {
    final userId = _getCurrentUserId();
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> deleteFriend(String friendId) async {
    final userId = _getCurrentUserId();
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(friendId);

    await docRef.delete();
  }

  // ============================================
  // CLEAR USER DATA ON LOGOUT (NOT NEEDED FOR FIRESTORE)
  // ============================================
  // No need for clearUserData() as data is already isolated per user in Firestore
}

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/feedback_model.dart';
import 'package:firebase_core/firebase_core.dart';

class FeedbackService {
  // 🔧 FIX: Tambahkan database URL explicitly
  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://qualityeducation-7e5ff-default-rtdb.asia-southeast1.firebasedatabase.app',
  );

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save feedback to Firebase Realtime Database
  Future<bool> saveFeedback({
    required String babId,
    required int rating,
    required String comment,
    required int readingDuration,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;

      // 🔧 FIX: Tambah validation & debug print
      print('🔍 DEBUG: Starting saveFeedback');
      print('🔍 DEBUG: UserId: $userId');
      print('🔍 DEBUG: BabId: $babId');
      print('🔍 DEBUG: Rating: $rating');

      if (userId == null) {
        print('❌ ERROR: User not authenticated');
        return false;
      }

      final feedback = FeedbackModel(
        userId: userId,
        babId: babId,
        rating: rating,
        comment: comment,
        timestamp: DateTime.now(),
        readingDuration: readingDuration,
      );

      final ref = _database.ref('feedbacks/$userId/$babId');

      print('🔍 DEBUG: Saving to path: feedbacks/$userId/$babId');

      await ref.set(feedback.toMap());

      print('✅ SUCCESS: Feedback saved successfully');
      return true;
    } catch (e, stackTrace) {
      // 🔧 FIX: Print detailed error
      print('❌ ERROR saving feedback: $e');
      print('❌ STACK TRACE: $stackTrace');
      return false;
    }
  }

  // Check if user already gave feedback for this bab
  Future<bool> hasFeedback(String babId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      final ref = _database.ref('feedbacks/$userId/$babId');
      final snapshot = await ref.get();

      return snapshot.exists;
    } catch (e) {
      print('Error checking feedback: $e');
      return false;
    }
  }

  // Get feedback for specific bab
  Future<FeedbackModel?> getFeedback(String babId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return null;

      final ref = _database.ref('feedbacks/$userId/$babId');
      final snapshot = await ref.get();

      if (!snapshot.exists) return null;

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return FeedbackModel.fromMap(data);
    } catch (e) {
      print('Error getting feedback: $e');
      return null;
    }
  }

  // Get all feedbacks from user
  Future<List<FeedbackModel>> getAllUserFeedbacks() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      final ref = _database.ref('feedbacks/$userId');
      final snapshot = await ref.get();

      if (!snapshot.exists) return [];

      final feedbacks = <FeedbackModel>[];
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      data.forEach((key, value) {
        final feedbackData = Map<String, dynamic>.from(value as Map);
        feedbacks.add(FeedbackModel.fromMap(feedbackData));
      });

      return feedbacks;
    } catch (e) {
      print('Error getting all feedbacks: $e');
      return [];
    }
  }

  // Get all feedbacks for specific bab (admin purpose)
  Future<List<FeedbackModel>> getAllBabFeedbacks(String babId) async {
    try {
      final ref = _database.ref('feedbacks');
      final snapshot = await ref.get();

      if (!snapshot.exists) return [];

      final feedbacks = <FeedbackModel>[];
      final usersData = Map<String, dynamic>.from(snapshot.value as Map);

      usersData.forEach((userId, babsData) {
        final babs = Map<String, dynamic>.from(babsData as Map);
        if (babs.containsKey(babId)) {
          final feedbackData = Map<String, dynamic>.from(babs[babId] as Map);
          feedbacks.add(FeedbackModel.fromMap(feedbackData));
        }
      });

      return feedbacks;
    } catch (e) {
      print('Error getting bab feedbacks: $e');
      return [];
    }
  }

  // Delete feedback
  Future<bool> deleteFeedback(String babId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      final ref = _database.ref('feedbacks/$userId/$babId');
      await ref.remove();

      return true;
    } catch (e) {
      print('Error deleting feedback: $e');
      return false;
    }
  }
}

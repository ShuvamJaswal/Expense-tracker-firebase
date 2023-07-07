import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/src/features/about/domain/feedback_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'about_repository.g.dart';

//TODO chnage timeout error message
class AboutRepository {
  const AboutRepository(
    this._firestore,
  );
  final FirebaseFirestore _firestore;
  static String feedbackPath() => 'utilities/feedbacks/all';

  Future<void> addFeedback({
    required FeedbackModel feedbackModel,
  }) async {
    final batch = _firestore.batch();
    batch.set(
        _firestore.collection(feedbackPath()).doc(), feedbackModel.toJson());
    await batch.commit().timeout(Duration(seconds: 5));
  }
}

@riverpod
AboutRepository aboutRepository(AboutRepositoryRef ref) {
  return AboutRepository(FirebaseFirestore.instance);
}

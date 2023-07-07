import 'package:expense_tracker/src/features/about/data/about_repository.dart';
import 'package:expense_tracker/src/features/about/domain/feedback_model.dart';
import 'package:expense_tracker/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'about_controller.g.dart';

@riverpod
class AboutController extends _$AboutController {
  @override
  FutureOr<void> build() {}

  Future<bool> submit({required description}) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      throw AssertionError('User can\'t be null');
    }
    FeedbackModel feedbackModel = FeedbackModel(
        date: DateTime.now(),
        description: description,
        userId: currentUser.uid);
    final aboutRepository = ref.read(aboutRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => aboutRepository.addFeedback(feedbackModel: feedbackModel));

    return !state.hasError;
  }
}

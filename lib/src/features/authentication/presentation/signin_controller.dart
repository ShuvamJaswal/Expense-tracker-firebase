import 'package:expense_tracker/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'signin_controller.g.dart';

enum AuthType { signin, register }

@riverpod
class SigninController extends _$SigninController {
  @override
  FutureOr<void> build() {}
  Future<void> completeRegistration() async {
    final signinRepository = ref.watch(signinRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => signinRepository.register());
  }

  Future<void> completeAnonSignin() async {
    state = const AsyncLoading();
    final signinRepository = ref.watch(signinRepositoryProvider);

    final p = await AsyncValue.guard(() => signinRepository.anonSignin());
    state = AsyncData(p);
  }
}

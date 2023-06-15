import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider, GoogleAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._auth);
  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> signOut() {
    return _auth.signOut();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInAnonymously() async {
    final UserCredential userCredential = await _auth.signInAnonymously();

    return userCredential;
  }

  Future<void> createFirestoreForUser(String user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    users.doc(user).set(
      {
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'email': '',
        'name': ''
      },
    );
  }
}

class SigninRepository {
  final AuthRepository auth;
  SigninRepository(this.auth);
  bool isSignincomplete() {
    return auth.currentUser != null;
  }

  Future<void> register() async {
    if (auth.currentUser != null) {
      await auth.createFirestoreForUser(auth.currentUser!.uid);
    }
  }

  Future<void> anonSignin() async {
    UserCredential userCredential = await auth.signInAnonymously();
    return await auth.createFirestoreForUser(userCredential.user!.uid);
  }
}

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
}

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}

@Riverpod(keepAlive: true)
List<AuthProvider<AuthListener, AuthCredential>> authProviders(
    AuthProvidersRef ref) {
  return [
    EmailAuthProvider(),
  ];
}

@Riverpod(keepAlive: true)
SigninRepository signinRepository(SigninRepositoryRef ref) {
  final auth = ref.watch(authRepositoryProvider);
  return SigninRepository(auth);
}

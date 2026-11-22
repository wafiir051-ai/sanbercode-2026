import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();

  FirebaseAuth? _auth;
  StreamSubscription<User?>? _authSub;

  final isLoggedIn = false.obs;
  final currentUserEmail = ''.obs;
  final currentUserId = ''.obs;

  String? redirectRoute;

  String get displayName {
    final email = currentUserEmail.value;
    return email.contains('@') ? email.split('@').first : email;
  }

  Future<AuthService> init({FirebaseAuth? auth}) async {
    _auth = auth ?? (Firebase.apps.isNotEmpty ? FirebaseAuth.instance : null);
    _authSub = _auth?.authStateChanges().listen(_apply);
    _apply(_auth?.currentUser);
    return this;
  }

  @override
  void onClose() {
    _authSub?.cancel();
    super.onClose();
  }

  void _apply(User? user) {
    isLoggedIn.value = user != null;
    currentUserEmail.value = user?.email ?? '';
    currentUserId.value = user?.uid ?? '';
  }

  FirebaseAuth get _firebase =>
      _auth ?? (throw StateError('Firebase belum diinisialisasi'));

  Future<void> register(String email, String password) async {
    final credential = await _firebase.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    _apply(credential.user);
  }

  Future<void> login(String email, String password) async {
    final credential = await _firebase.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    _apply(credential.user);
  }

  Future<void> logout() async {
    await _auth?.signOut();
    _apply(null);
    redirectRoute = null;
  }

  static String mapFirebaseAuthError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'Email ini sudah terdaftar. Silakan login.';
        case 'weak-password':
          return 'Kata sandi terlalu lemah. Gunakan minimal 6 karakter.';
        case 'invalid-email':
          return 'Format email tidak valid.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email atau kata sandi salah.';
        case 'user-disabled':
          return 'Akun ini telah dinonaktifkan.';
        case 'too-many-requests':
          return 'Terlalu banyak percobaan. Coba lagi beberapa saat lagi.';
        case 'network-request-failed':
          return 'Koneksi internet bermasalah. Periksa jaringan Anda.';
        case 'operation-not-allowed':
          return 'Metode login Email/Password belum diaktifkan di Firebase Console.';
      }
    }
    return 'Terjadi kesalahan. Silakan coba lagi.';
  }
}

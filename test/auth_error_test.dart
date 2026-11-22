import 'package:e_commerce_smk/app/core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String map(String code) =>
      AuthService.mapFirebaseAuthError(FirebaseAuthException(code: code));

  test('kode error Firebase diterjemahkan ke pesan berbahasa Indonesia', () {
    expect(
      map('email-already-in-use'),
      'Email ini sudah terdaftar. Silakan login.',
    );
    expect(map('weak-password'), contains('minimal 6 karakter'));
    expect(map('invalid-credential'), 'Email atau kata sandi salah.');
    expect(map('wrong-password'), map('user-not-found'));
    expect(map('operation-not-allowed'), contains('Firebase Console'));
    expect(map('kode-tak-dikenal'), 'Terjadi kesalahan. Silakan coba lagi.');
  });

  test('error non-Firebase memakai pesan umum', () {
    expect(
      AuthService.mapFirebaseAuthError(StateError('x')),
      'Terjadi kesalahan. Silakan coba lagi.',
    );
  });

  test('login tanpa Firebase gagal, bukan lolos diam-diam', () async {
    final auth = await AuthService().init();
    expect(() => auth.login('a@b.co', 'secret1'), throwsStateError);
    expect(auth.isLoggedIn.value, isFalse);
  });
}

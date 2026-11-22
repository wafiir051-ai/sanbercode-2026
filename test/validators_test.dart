import 'package:e_commerce_smk/app/modules/login/controllers/login_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final c = LoginController();

  test('validasi email dengan regex', () {
    expect(c.validateEmail(''), isNotNull);
    expect(c.validateEmail('bukan-email'), isNotNull);
    expect(c.validateEmail('nama@sekolah.sch.id'), isNull);
  });

  test('sandi minimal 6 karakter dan wajib mengandung angka', () {
    expect(c.validatePassword('abc1'), isNotNull);
    expect(c.validatePassword('abcdefg'), isNotNull);
    expect(c.validatePassword('abcdef1'), isNull);
  });
}

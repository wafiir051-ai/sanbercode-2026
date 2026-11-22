import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  final RxBool _isDarkMode = false.obs;

  static const String _themeKey = 'is_dark_mode';

  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  bool get isDarkMode => _isDarkMode.value;

  Future<StorageService> init({bool initHive = true}) async {
    _prefs = await SharedPreferences.getInstance();

    _isDarkMode.value = _prefs.getBool(_themeKey) ?? false;

    if (initHive) {
      await Hive.initFlutter();
    }

    return this;
  }

  Future<void> toggleTheme() async {
    final newValue = !_isDarkMode.value;

    await _prefs.setBool(_themeKey, newValue);

    _isDarkMode.value = newValue;

    Get.changeThemeMode(themeMode);

    Get.snackbar(
      newValue ? 'Mode Gelap Diaktifkan' : 'Mode Terang Diaktifkan',
      newValue
          ? 'Tampilan hemat daya dan nyaman untuk mata telah aktif.'
          : 'Tampilan cerah bersemangat telah aktif.',
      backgroundColor: newValue
          ? const Color(0xFF1E293B)
          : const Color(0xFF4F46E5),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      borderRadius: 12,
      icon: Icon(
        newValue ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
        color: newValue ? Colors.amber : Colors.white,
      ),
    );
  }
}

import 'package:dio/dio.dart';

class NetworkFailure implements Exception {
  final int code;
  final String message;

  const NetworkFailure({required this.code, required this.message});

  @override
  String toString() => 'NetworkFailure($code): $message';
}

class ErrorHandler implements Exception {
  late final NetworkFailure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is NetworkFailure) {
      failure = error;
    } else if (error is DioException) {
      failure = _handleDioError(error);
    } else {
      failure = const NetworkFailure(
        code: -9,
        message: 'Terjadi kesalahan yang tidak diketahui.',
      );
    }
  }
}

NetworkFailure _handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const NetworkFailure(
        code: -1,
        message: 'Waktu koneksi habis (Timeout). Periksa koneksi internet Anda.',
      );
    case DioExceptionType.connectionError:
      return const NetworkFailure(
        code: -6,
        message: 'Gagal terhubung ke server. Pastikan perangkat terhubung ke internet.',
      );
    case DioExceptionType.badResponse:
      return _handleBadResponse(error);
    case DioExceptionType.cancel:
      return const NetworkFailure(
        code: -2,
        message: 'Permintaan dibatalkan.',
      );
    default:
      return NetworkFailure(
        code: -8,
        message: 'Gangguan koneksi: ${error.message ?? 'Terjadi kesalahan tidak diketahui'}',
      );
  }
}

NetworkFailure _handleBadResponse(DioException error) {
  final statusCode = error.response?.statusCode ?? -3;
  return NetworkFailure(
    code: statusCode,
    message: _getFallbackMessage(statusCode),
  );
}

String _getFallbackMessage(int statusCode) {
  switch (statusCode) {
    case 400:
      return 'Permintaan tidak valid (400).';
    case 401:
      return 'Sesi tidak berwenang (401). Silakan masuk kembali.';
    case 403:
      return 'Akses ditolak (403).';
    case 404:
      return 'Data tidak ditemukan di server (404).';
    case 500:
      return 'Server sedang bermasalah (500). Coba lagi nanti.';
    default:
      return 'Terjadi kesalahan pada server (kode $statusCode).';
  }
}

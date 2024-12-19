import 'package:cheatshield/config.dart';
import 'package:dio/dio.dart';

final httpClient = Dio(
  BaseOptions(
    baseUrl: apiBaseUrl,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    followRedirects: false,
    validateStatus: (status) => status! < 500,
  ),
);

import 'package:cheatshield/config.dart';
import 'package:dio/dio.dart';

final httpClient = Dio(
  BaseOptions(
    baseUrl: apiBaseUrl,
  ),
);

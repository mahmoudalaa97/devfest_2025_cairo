import 'package:ai_demo/utlities/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkProvider = Provider<NetworkProvider>((ref) {
  return NetworkProvider(
    Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-goog-api-key': 'AIzaSyCU0dHLIaPQLu_4JSkHSBSZnR4Z86qh5Q4',
        },
      ),
    ),
  );
});

class NetworkProvider {
  final Dio dio;

  NetworkProvider(this.dio);

  Future<Response> get(String url) async {
    return await dio.get(url);
  }

  Future<Response> post(String url, Map<String, dynamic> data) async {
    return await dio.post(url, data: data);
  }

  Future<Response> put(String url, Map<String, dynamic> data) async {
    return await dio.put(url, data: data);
  }

  Future<Response> delete(String url) async {
    return await dio.delete(url);
  }

  Future<Response> patch(String url, Map<String, dynamic> data) async {
    return await dio.patch(url, data: data);
  }
}

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../constants.dart';
import '../service_locator.dart';

///Dio Singleton client with default configurations
class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(_getUserAgentInterceptor());

    dio.interceptors.add(
      LogInterceptor(
        request: false,
        requestHeader: true,
        requestBody: false,
        responseHeader: false,
        error: true,
      ),
    );
  }

  InterceptorsWrapper _getUserAgentInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final info = getIt<PackageInfo>();

        final userAgent =
            '$kAppName/${info.version}+${info.buildNumber} (Repo: github.com/liuedg1/FlutterMinecraftLauncher)';

        options.headers['User-Agent'] = userAgent;
        return handler.next(options);
      },
    );
  }
}

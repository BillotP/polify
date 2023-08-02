import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'S3_ENDPOINT', obfuscate: true)
  static String s3Endpoint = _Env.s3Endpoint;
  @EnviedField(varName: 'ACCESS_KEY', obfuscate: true)
  static String accessKey = _Env.accessKey;
  @EnviedField(varName: 'SECRET_KEY', obfuscate: true)
  static String secretKey = _Env.secretKey;
}

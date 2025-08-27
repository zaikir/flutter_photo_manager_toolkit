import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'kirz_photo_manager_toolkit_method_channel.dart';

abstract class KirzPhotoManagerToolkitPlatform extends PlatformInterface {
  /// Constructs a KirzPhotoManagerToolkitPlatform.
  KirzPhotoManagerToolkitPlatform() : super(token: _token);

  static final Object _token = Object();

  static KirzPhotoManagerToolkitPlatform _instance = MethodChannelKirzPhotoManagerToolkit();

  /// The default instance of [KirzPhotoManagerToolkitPlatform] to use.
  ///
  /// Defaults to [MethodChannelKirzPhotoManagerToolkit].
  static KirzPhotoManagerToolkitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KirzPhotoManagerToolkitPlatform] when
  /// they register themselves.
  static set instance(KirzPhotoManagerToolkitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int?> getAssetFileSize(String id) {
    throw UnimplementedError('getAssetFileSize() has not been implemented.');
  }

  Future<Map<String, int?>> getAssetsFileSize(List<String> ids, {int concurrency = 50}) {
    throw UnimplementedError('getAssetsFileSize() has not been implemented.');
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'kirz_photo_manager_toolkit_platform_interface.dart';

/// An implementation of [KirzPhotoManagerToolkitPlatform] that uses method channels.
class MethodChannelKirzPhotoManagerToolkit extends KirzPhotoManagerToolkitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('kirz_photo_manager_toolkit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int?> getAssetFileSize(String id) async {
    final result = await methodChannel.invokeMethod<int>('getAssetFileSize', {'id': id});
    return result;
  }

  @override
  Future<Map<String, int?>> getAssetsFileSize(List<String> ids, {int concurrency = 50}) async {
    final result = await methodChannel.invokeMethod<Map>('getAssetsFileSize', {
      'ids': ids,
      'concurrency': concurrency,
    });

    if (result == null) return {};

    // Convert dynamic map to Map<String, int?>
    final Map<String, int?> convertedResult = {};
    result.forEach((key, value) {
      convertedResult[key as String] = value as int?;
    });

    return convertedResult;
  }
}

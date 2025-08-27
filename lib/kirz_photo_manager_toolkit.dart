import 'kirz_photo_manager_toolkit_platform_interface.dart';

class PhotoManagerToolkit {
  /// Get platform version (for compatibility with example and tests)
  Future<String?> getPlatformVersion() {
    return KirzPhotoManagerToolkitPlatform.instance.getPlatformVersion();
  }

  /// Get file size for a single asset by ID
  Future<int?> getAssetFileSize(String id) {
    return KirzPhotoManagerToolkitPlatform.instance.getAssetFileSize(id);
  }

  /// Get file sizes for multiple assets with concurrency control
  Future<Map<String, int?>> getAssetsFileSize(List<String> ids, {int concurrency = 50}) {
    return KirzPhotoManagerToolkitPlatform.instance.getAssetsFileSize(
      ids,
      concurrency: concurrency,
    );
  }
}

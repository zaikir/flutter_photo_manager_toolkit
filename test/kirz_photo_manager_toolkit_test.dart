import 'package:flutter_test/flutter_test.dart';
import 'package:kirz_photo_manager_toolkit/kirz_photo_manager_toolkit.dart';
import 'package:kirz_photo_manager_toolkit/kirz_photo_manager_toolkit_method_channel.dart';
import 'package:kirz_photo_manager_toolkit/kirz_photo_manager_toolkit_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockKirzPhotoManagerToolkitPlatform
    with MockPlatformInterfaceMixin
    implements KirzPhotoManagerToolkitPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<int?> getAssetFileSize(String id) => Future.value(12345);

  @override
  Future<Map<String, int?>> getAssetsFileSize(List<String> ids, {int concurrency = 5}) =>
      Future.value({'test_id': 12345});
}

void main() {
  final KirzPhotoManagerToolkitPlatform initialPlatform = KirzPhotoManagerToolkitPlatform.instance;

  test('$MethodChannelKirzPhotoManagerToolkit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelKirzPhotoManagerToolkit>());
  });

  test('getPlatformVersion', () async {
    PhotoManagerToolkit photoManagerToolkitPlugin = PhotoManagerToolkit();
    MockKirzPhotoManagerToolkitPlatform fakePlatform = MockKirzPhotoManagerToolkitPlatform();
    KirzPhotoManagerToolkitPlatform.instance = fakePlatform;

    expect(await photoManagerToolkitPlugin.getPlatformVersion(), '42');
  });
}

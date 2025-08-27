import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kirz_photo_manager_toolkit/kirz_photo_manager_toolkit_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelKirzPhotoManagerToolkit platform = MethodChannelKirzPhotoManagerToolkit();
  const MethodChannel channel = MethodChannel('kirz_photo_manager_toolkit');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}

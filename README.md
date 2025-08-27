# kirz_photo_manager_toolkit

A Flutter plugin for retrieving file sizes of photos from the iOS Photos library with support for batch processing and concurrency control.

## Features

- Get file size for a single photo asset by ID
- Batch processing of multiple photo assets with configurable concurrency
- iOS Photos framework integration
- Efficient concurrent processing using GCD

## Usage

### Import the plugin

```dart
import 'package:kirz_photo_manager_toolkit/kirz_photo_manager_toolkit.dart';
```

### Create an instance

```dart
final photoManager = PhotoManagerToolkit();
```

### Get file size for a single asset

```dart
String assetId = "your_asset_local_identifier";
int? fileSize = await photoManager.getAssetFileSize(assetId);

if (fileSize != null) {
  print("File size: $fileSize bytes");
} else {
  print("Asset not found or unable to retrieve file size");
}
```

### Get file sizes for multiple assets with concurrency control

```dart
List<String> assetIds = ["asset1", "asset2", "asset3"];
Map<String, int?> fileSizes = await photoManager.getAssetsFileSize(
  assetIds,
  concurrency: 3, // Optional: control concurrency (default: 5)
);

fileSizes.forEach((id, size) {
  if (size != null) {
    print("Asset $id: $size bytes");
  } else {
    print("Asset $id: size unavailable");
  }
});
```

## Platform Support

- **iOS**: Full support using Photos framework
- **Android**: Not implemented (platform interface available for future implementation)

## Permissions

This plugin requires the following permissions to be added to your iOS app:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to your photo library to retrieve file sizes</string>
```

## Getting Started

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


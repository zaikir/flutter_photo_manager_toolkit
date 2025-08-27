import Flutter
import UIKit
import Photos

public class KirzPhotoManagerToolkitPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "kirz_photo_manager_toolkit", binaryMessenger: registrar.messenger())
    let instance = KirzPhotoManagerToolkitPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)

    case "getAssetFileSize":
      guard let args = call.arguments as? [String: Any],
            let identifier = args["id"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing or invalid 'id' argument", details: nil))
        return
      }
      getAssetFileSize(for: identifier, result: result)

    case "getAssetsFileSize":
      guard let args = call.arguments as? [String: Any],
            let ids = args["ids"] as? [String] else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing or invalid 'ids' argument", details: nil))
        return
      }
      let concurrency = max((args["concurrency"] as? Int) ?? 4, 1)
      getAssetsFileSize(for: ids, concurrency: concurrency, result: result)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func preferredResource(for asset: PHAsset) -> PHAssetResource? {
    let resources = PHAssetResource.assetResources(for: asset)

    // Предпочитаем “полноразмерные” типы
    if asset.mediaType == .image {
      if let full = resources.first(where: { $0.type == .fullSizePhoto }) { return full }
      if let photo = resources.first(where: { $0.type == .photo }) { return photo }
    } else if asset.mediaType == .video {
      if let full = resources.first(where: { $0.type == .fullSizeVideo }) { return full }
      if let video = resources.first(where: { $0.type == .video }) { return video }
    }

    // Фоллбэк — просто самый “тяжёлый”
    return resources.max(by: { (lhs, rhs) -> Bool in
      let l = (lhs.value(forKey: "fileSize") as? CLongLong) ?? 0
      let r = (rhs.value(forKey: "fileSize") as? CLongLong) ?? 0
      return l < r
    })
  }

  private func getAssetFileSize(for identifier: String, result: @escaping FlutterResult) {
    let assets = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
    guard let asset = assets.firstObject, let resource = preferredResource(for: asset) else {
      result(nil) // вернётся null в Dart
      return
    }

    if let raw = resource.value(forKey: "fileSize") as? CLongLong {
      result(Int64(bitPattern: UInt64(raw)))
    } else {
      result(nil)
    }
  }

  private func getAssetsFileSize(for identifiers: [String], concurrency: Int, result: @escaping FlutterResult) {
    let dispatchGroup = DispatchGroup()
    let workQueue = DispatchQueue(label: "com.kirz.photoManagerToolkit.work", attributes: .concurrent)
    let semaphore = DispatchSemaphore(value: concurrency)

    // ВАЖНО: Any + NSNull(), чтобы null корректно доехал в Dart
    var results: [String: Any] = [:]
    let resultsQueue = DispatchQueue(label: "com.kirz.photoManagerToolkit.results") // serial

    for identifier in identifiers {
      dispatchGroup.enter()
      workQueue.async {
        semaphore.wait()

        defer {
          semaphore.signal()
          dispatchGroup.leave()
        }

        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
        guard let asset = assets.firstObject, let resource = self.preferredResource(for: asset) else {
          resultsQueue.sync { results[identifier] = NSNull() }
          return
        }

        if let raw = resource.value(forKey: "fileSize") as? CLongLong {
          let sizeOnDisk = Int64(bitPattern: UInt64(raw))
          resultsQueue.sync { results[identifier] = sizeOnDisk }
        } else {
          resultsQueue.sync { results[identifier] = NSNull() }
        }
      }
    }

    dispatchGroup.notify(queue: .main) {
      result(results)
    }
  }
}

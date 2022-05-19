import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';

///
/// A Dart utility which helps you manage the communication between Firebase Storage and you app.
/// It natively implements a low dependencies cache to save time and computational costs.
///
class CachedFirestorage {
  static CachedFirestorage? _instance;
  final Map<String, String> _storageKeys = {'default': 'default'};
  int cacheTimeout;

  CachedFirestorage._(this.cacheTimeout);

  /// Get the singleton instance
  static CachedFirestorage get instance =>
      _instance ??= CachedFirestorage._(360);

  /// Private method
  Future<String> _getDownloadURL(String filePath, {
    String? fallbackFilePath,
  }) async {
    try {
      return await FirebaseStorage.instance.ref(filePath).getDownloadURL();
    } catch (e) {
      if (fallbackFilePath != null) {
        return await FirebaseStorage.instance
            .ref(fallbackFilePath)
            .getDownloadURL();
      }

      return '';
    }
  }

  /// Gets Firebase Storage download URL and stores it into a cache
  Future<String> getDownloadURL({
    required String mapKey,
    required String filePath,
    String? storageKey,
    String? fallbackFilePath,
  }) async {
    assert(storageKey == null || _storageKeys.containsKey(storageKey));

    final Map<String, dynamic> mapDownloadURLs =
        GetStorage().read(_storageKeys[storageKey ?? 'default']!) ?? {};
    final DateTime now = DateTime.now();

    if (mapDownloadURLs[mapKey] != null) {
      final DateTime lastWrite =
      DateTime.parse(mapDownloadURLs[mapKey]['lastWrite']);
      final int difference = now
          .difference(lastWrite)
          .inMinutes;
      if (difference < cacheTimeout) {
        return mapDownloadURLs[mapKey]['value'];
      }
    }

    final String downloadURL = await _getDownloadURL(
      filePath,
      fallbackFilePath: fallbackFilePath,
    );

    mapDownloadURLs[mapKey] = {
      'value': downloadURL,
      'lastWrite': now.toIso8601String(),
    };

    GetStorage().write(_storageKeys[storageKey ?? 'default']!, mapDownloadURLs);

    return downloadURL;
  }

  /// Deletes a cache entry
  void removeCacheEntry({
    required String mapKey,
    String? storageKey,
  }) {
    final Map<String, dynamic> mapDownloadURLs =
        GetStorage().read(_storageKeys[storageKey ?? 'default']!) ?? {};

    if (mapDownloadURLs[mapKey] != null) {
      mapDownloadURLs.remove(mapKey);
      GetStorage()
          .write(_storageKeys[storageKey ?? 'default']!, mapDownloadURLs);
    }
  }
}

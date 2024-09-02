# Cached Firestorage

[![pub](https://img.shields.io/pub/v/cached_firestorage.svg)](https://pub.dev/packages/cached_firestorage)
[![license: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![style: flutter_lints dart](https://img.shields.io/badge/style-flutter_lints-40c4ff.svg)](https://pub.dev/packages/flutter_lints)
[![Github](https://img.shields.io/github/stars/TheFe91/cached_firestorage?style=social)](https://github.com/TheFe91/cached_firestorage)

A Flutter utility that manages Firebase Storage download URLs and caches the results

## Usage

Cached Firestorage exposes a `Singleton` which you can access through `CachedFirestorage.instance`<br /><br />
The default `cache duration` is of `360 minutes` (`6h`): you can customize this by passing the number of minutes to the instance:
```dart
CachedFirestorage.instance.cacheTimeout = 30;
```

You can, for code organization purposes, split the cache into subpaths. Those subpaths must be created at the beginning, by invoking
```dart
CachedFirestorage.instance.setStorageKeys({'cachePathName': 'cachePathValue'});
```

## APIs

### getDownloadURL

This is the main api: it's a `Future<String>`. When it completes, it returns in its `snapshot.data` the Firebase Storage's download url of the requested resource,
caching the result. Every time you will ask for it again, you'll have direct access to the resource's url.<br />
`getDownloadURL`  <strong>always</strong> returns a `String`, meaning that if no file is matched and no `fallbackFilePath` (see below) is provided, it will return `''`;

#### Parameters (all named)
 * `String mapKey`: The key at which your cached entry will be stored
 * `String filePath`: The file path on your Firebase Storage bucket
 * `String? storageKey`: You can split the cache into sub-paths: this is the subpath key
 * `String? fallbackFilePath`: If provided, this is the path at which Cached Firestorage will try to point in case of no matches on the first attempt on Firebase Storage. If the second attempt goes bad too, Cached Firestorage will return an empty string;

### removeCacheEntry

By calling this api you can remove a cache entry when you want. Very useful in case you need to update the download URL of a previously stored resource before the cache expires.

#### Parameters (all named)
 * `String mapKey`: the key to be removed from the cache
 * `String? storageKey`: the storage key in which Cached Firestorage should search the mapKey

## Widgets

### RemotePicture

Since Firebase Storage is particularly useful when it's a matter of hosting pictures, CachedFirestorage ships with a built-in widget that you can use to display an image stored in your bucket.

#### Parameters (all named)
 * `String imagePath`: The file path on your Firebase Storage bucket
 * `String mapKey`: The key at which your cached entry will be stored
 * `bool useAvatarView = false`: If true, it will render your image as an [AvatarView](https://pub.dev/packages/avatar_view)
 * `String? storageKey`: You can split the cache into sub-paths: this is the subpath key
 * `String? placeholder`: The file path of a local asset to use as placeholder
 * `double? avatarViewRadius`: The radius of the avatar (mandatory if `useAvatarView == true`)
 * `BoxFit? fit`: Optional parameter to be passed to a non-avatar image (ignored if `useAvatarView == true`)
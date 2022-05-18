import 'package:adaptive_spinner/adaptive_spinner.dart';
import 'package:avatar_view/avatar_view.dart';
import 'package:cached_firestorage/cached_firestorage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RemotePicture extends StatelessWidget {
  final String imagePath;
  final String mapKey;
  final bool useAvatarView;
  final String? getStorageKey;
  final String? placeholder;
  final double? avatarViewRadius;
  final BoxFit? fit;

  const RemotePicture({
    required this.imagePath,
    required this.mapKey,
    this.getStorageKey,
    this.useAvatarView = false,
    this.placeholder,
    this.avatarViewRadius,
    this.fit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(!useAvatarView || useAvatarView && avatarViewRadius != null);

    return FutureBuilder<String>(
      future: CachedFirestorage.instance.getDownloadURL(
        filePath: imagePath,
        storageKey: getStorageKey,
        mapKey: mapKey,
      ),
      builder: (_, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? Center(child: AdaptiveSpinner())
              : useAvatarView
                  ? AvatarView(
                      radius: avatarViewRadius!,
                      avatarType: AvatarType.CIRCLE,
                      imagePath:
                          snapshot.data != "" ? snapshot.data! : placeholder!,
                      placeHolder: Center(child: AdaptiveSpinner()),
                      errorWidget: placeholder != null
                          ? Image.asset(placeholder!)
                          : null,
                    )
                  : CachedNetworkImage(
                      imageUrl: snapshot.data!,
                      placeholder: (_, __) => Center(child: AdaptiveSpinner()),
                      errorWidget: placeholder != null
                          ? (_, __, ___) => Image.asset(placeholder!)
                          : null,
                      fit: fit,
                    ),
    );
  }
}

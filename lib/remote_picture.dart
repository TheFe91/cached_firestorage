import 'package:adaptive_spinner/adaptive_spinner.dart';
import 'package:avatar_view/avatar_view.dart';
import 'package:cached_firestorage/cached_firestorage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RemotePicture extends StatelessWidget {
  final String imagePath;
  final String mapKey;
  final bool useAvatarView;
  final String? storageKey;
  final String? placeholder;
  final double? avatarViewRadius;
  final BoxFit? fit;

  const RemotePicture({
    required this.imagePath,
    required this.mapKey,
    this.storageKey,
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
        storageKey: storageKey,
        mapKey: mapKey,
      ),
      builder: (_, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const Center(
              child: !kIsWeb ? AdaptiveSpinner() : CircularProgressIndicator(),
            )
          : useAvatarView
              ? AvatarView(
                  radius: avatarViewRadius!,
                  avatarType: AvatarType.CIRCLE,
                  imagePath:
                      snapshot.data != "" ? snapshot.data! : placeholder!,
                  placeHolder: const Center(
                    child: !kIsWeb
                        ? AdaptiveSpinner()
                        : CircularProgressIndicator(),
                  ),
                  errorWidget:
                      placeholder != null ? Image.asset(placeholder!) : null,
                )
              : CachedNetworkImage(
                  imageUrl: snapshot.data!,
                  placeholder: (_, __) => const Center(
                    child: !kIsWeb
                        ? AdaptiveSpinner()
                        : CircularProgressIndicator(),
                  ),
                  errorWidget: placeholder != null
                      ? (_, __, ___) => Image.asset(placeholder!)
                      : null,
                  fit: fit,
                ),
    );
  }
}

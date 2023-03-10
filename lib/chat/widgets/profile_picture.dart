import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture(this.url, {Key? key}) : super(key: key);
  final String? url;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: (url == null || url!.isEmpty) ? _DefaultProfilePicture():
             CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
                placeholder: (context, url) => _DefaultProfilePicture(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
             );
  }
}


class _DefaultProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/avatar.jpg",
      width: 50,
    );
  }
}
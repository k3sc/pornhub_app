import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum StatusStyle { LIGHT_CONTENT, DARK_CONTENT }

///带缓存的image
Widget cachedImage(String url, {double? width, double? height}) {
  return CachedNetworkImage(
    fit: BoxFit.cover,
    height: height,
    width: width,
    imageUrl: url,
    placeholder: (BuildContext context, String url) =>
        Container(color: Colors.grey[200]),
    errorWidget: (BuildContext context, String url, dynamic error) =>
        Icon(Icons.error),
  );
}

///黑色线性渐变
blackLinearGradient({bool fromTop = false}) {
  return LinearGradient(
      begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
      colors: [
        Colors.black54,
        Colors.black45,
        Colors.black38,
        Colors.black26,
        Colors.black12,
        Colors.transparent
      ]);
}

/// 间距
SizedBox hiSpace({double height: 1, double width: 1}) {
  return SizedBox(height: height, width: width);
}

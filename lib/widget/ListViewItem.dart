import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/utils/OpeUtil.dart';

Widget ListViewItem(item, context) {
  return Padding(
    padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 10),
    child: InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        OpeUtil.toVideoPage(context, item);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              offset: const Offset(4, 4),
              blurRadius: 16,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 2,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: "${item['img']}",
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(3),
                      color: Colors.black54,
                      child: Text(
                        item['duration'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.all(3),
                      color: Colors.black54,
                      child: Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye,
                            color: Colors.white,
                            size: 10,
                          ),
                          Container(width: 3),
                          Text(
                            item['views'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                          Container(width: 10),
                          Icon(
                            Icons.thumb_up_alt,
                            color: Colors.white,
                            size: 10,
                          ),
                          Container(width: 3),
                          Text(
                            item['value'] ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      item['title'],
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

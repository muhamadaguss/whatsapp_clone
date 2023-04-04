import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/message_enum.dart';

class DisplayText extends StatelessWidget {
  final String text;
  final MessageEnum messageEnum;
  const DisplayText({
    super.key,
    required this.text,
    required this.messageEnum,
  });

  @override
  Widget build(BuildContext context) {
    return messageEnum == MessageEnum.text
        ? Text(
            text,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : CachedNetworkImage(
            imageUrl: text,
            progressIndicatorBuilder: (context, url, progress) {
              return SizedBox(
                height: 200,
                width: 200,
                child: Center(
                  child: CircularProgressIndicator(
                    value: progress.progress,
                  ),
                ),
              );
            },
            errorWidget: (context, url, error) {
              return const Icon(Icons.error);
            },
            height: 100.h,
          );
  }
}

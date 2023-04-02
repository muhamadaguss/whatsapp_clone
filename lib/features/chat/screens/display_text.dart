import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
          );
  }
}

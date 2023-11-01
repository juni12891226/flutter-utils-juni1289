import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_utils_juni1289/widgets/misc/empty_container_helper_widget.dart';

class ImageViewFromFileHelperWidget extends StatelessWidget {
  final String imagePath;
  final BoxFit? boxFit;
  final double height;
  final double width;
  final FilterQuality? filterQuality;

  ///To get the image from the file path
  ///Load the image from the file path (local from device)
  ///[imagePath] is the path of the image
  ///[boxFit] is optional
  ///[height] is required
  ///[width] is required
  ///[filterQuality] is optional
  const ImageViewFromFileHelperWidget({Key? key, required this.height, required this.width, this.filterQuality, required this.imagePath, this.boxFit = BoxFit.fill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imagePath.isNotEmpty
        ? Image.file(File(imagePath), fit: boxFit, height: height, width: width, filterQuality: filterQuality ?? FilterQuality.high)
        : const EmptyContainerHelperWidget();
  }
}

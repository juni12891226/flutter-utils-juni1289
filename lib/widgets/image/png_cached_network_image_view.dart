import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils_juni1289/widgets/image/app_image_widget.dart';

class PNGCachedNetworkImageView extends StatefulWidget {
  final String imagePathOrURL;
  final double height;
  final double width;
  final BoxFit? boxFit;
  final FilterQuality? filterQuality;
  final Color? colorProgressLoaderIndicator;
  final String networkErrorPlaceHolderImagePath;
  final Widget? errorWidget;
  final Widget? progressIndicatorWidget;

  ///[imagePathOrURL] is required | image path from the assets or the network URL
  ///[height] is required
  ///[width] is required
  ///[boxFit] is optional
  ///[filterQuality] is optional and default is High Quality
  ///[colorProgressLoaderIndicator] is optional default is blue
  ///[networkErrorPlaceHolderImagePath] is required | in case of error the default placeholder image asset path
  ///[errorWidget] is optional | if you want to show your own error widget in case of png image
  ///[progressIndicatorWidget] is optional | if you want to show your own progress widget
  const PNGCachedNetworkImageView(
      {Key? key,
      this.progressIndicatorWidget,
      required this.networkErrorPlaceHolderImagePath,
      this.colorProgressLoaderIndicator,
      this.errorWidget,
      this.boxFit,
      required this.imagePathOrURL,
      required this.height,
      required this.width,
      this.filterQuality})
      : super(key: key);

  @override
  State<PNGCachedNetworkImageView> createState() => _PNGCachedNetworkImageViewState();
}

class _PNGCachedNetworkImageViewState extends State<PNGCachedNetworkImageView> {
  @override
  Widget build(BuildContext context) {
    return widget.boxFit != null
        ? CachedNetworkImage(
            imageUrl: widget.imagePathOrURL,
            height: widget.height,
            width: widget.width,
            filterQuality: widget.filterQuality ?? FilterQuality.high,
            fit: widget.boxFit,
            progressIndicatorBuilder: (BuildContext context, url, downloadProgress) {
              return widget.progressIndicatorWidget ??
                  SizedBox(
                      height: widget.height, width: widget.width, child: Center(child: CircularProgressIndicator(color: widget.colorProgressLoaderIndicator ?? Colors.blue)));
            },
            errorWidget: (BuildContext context, url, error) {
              return widget.errorWidget ??
                  Center(
                      child: AppImageHelperWidget(
                          networkErrorPlaceHolderImagePath: widget.networkErrorPlaceHolderImagePath,
                          imagePathOrURL: widget.networkErrorPlaceHolderImagePath,
                          height: widget.height,
                          width: widget.width,
                          filterQuality: widget.filterQuality ?? FilterQuality.high));
            })
        : CachedNetworkImage(
            imageUrl: widget.imagePathOrURL,
            height: widget.height,
            width: widget.width,
            filterQuality: widget.filterQuality ?? FilterQuality.high,
            progressIndicatorBuilder: (BuildContext context, url, downloadProgress) {
              return widget.progressIndicatorWidget ??
                  SizedBox(
                      height: widget.height, width: widget.width, child: Center(child: CircularProgressIndicator(color: widget.colorProgressLoaderIndicator ?? Colors.blue)));
            },
            errorWidget: (BuildContext context, url, error) {
              return widget.errorWidget ??
                  Center(
                      child: AppImageHelperWidget(
                          networkErrorPlaceHolderImagePath: widget.networkErrorPlaceHolderImagePath,
                          imagePathOrURL: widget.networkErrorPlaceHolderImagePath,
                          height: widget.height,
                          width: widget.width,
                          filterQuality: widget.filterQuality ?? FilterQuality.high));
            });
  }
}

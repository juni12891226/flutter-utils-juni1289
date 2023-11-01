import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_utils_juni1289/widgets/image/png_cached_network_image_view.dart';
import 'package:flutter_utils_juni1289/widgets/image/svg_cached_network_image_view.dart';
import 'package:flutter_utils_juni1289/widgets/misc/empty_container_helper_widget.dart';

class AppImageHelperWidget extends StatelessWidget {
  final String imagePathOrURL;
  final double height;
  final double width;
  final BoxFit? boxFit;
  final FilterQuality? filterQuality;
  final Color? colorSVG;
  final bool networkImage;
  final Color? colorProgressLoaderIndicator;
  final String networkErrorPlaceHolderImagePath;
  final Widget? errorWidget;
  final Widget? progressIndicatorWidget;
  final int? svgLoadRetryLimit;
  final Duration? timeOutDuration;
  final bool? useDiskCacheForSVG;
  final Duration? cacheRuleStaleDuration;
  final Function? onSVGLoadFailedCallback;

  ///A generic widget to show the images from the Assets or from the network
  ///[imagePathOrURL] is required | image path from the assets or the network URL
  ///[height] is required
  ///[width] is required
  ///[boxFit] is optional
  ///[filterQuality] is optional and default is High Quality
  ///[colorSVG] is optional
  ///[networkImage] is required | true if load from network | false if load from assets
  ///[colorProgressLoaderIndicator] is optional default is blue
  ///[networkErrorPlaceHolderImagePath] is required | in case of error the default placeholder image asset path
  ///[errorWidget] is optional | if you want to show your own error widget in case of png image
  ///[progressIndicatorWidget] is optional | if you want to show your own progress widget
  ///[timeOutDuration] is optional | for SVG you can set the load timeout | default is 30 seconds
  ///[svgLoadRetryLimit] is optional | for SVG you can set the retry load limit | default is 1 times | single
  ///[useDiskCacheForSVG] is optional | default is true
  ///[cacheRuleStaleDuration] is optional | for how much time the images needs to be caches | default is 500 days
  ///[onSVGLoadFailedCallback] is optional
  const AppImageHelperWidget(
      {Key? key,
      this.timeOutDuration,
      this.useDiskCacheForSVG,
      this.cacheRuleStaleDuration,
      this.onSVGLoadFailedCallback,
      this.svgLoadRetryLimit,
      this.progressIndicatorWidget,
      this.errorWidget,
      required this.networkErrorPlaceHolderImagePath,
      this.colorProgressLoaderIndicator,
      this.networkImage = false,
      this.colorSVG,
      this.boxFit,
      required this.imagePathOrURL,
      required this.height,
      required this.width,
      this.filterQuality})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (networkImage) {
      if (imagePathOrURL.endsWith(".svg")) {
        return SVGCachedNetworkImageView(
          imagePathOrURL: imagePathOrURL,
          timeOutDuration: timeOutDuration,
          useDiskCacheForSVG: useDiskCacheForSVG,
          cacheRuleStaleDuration: cacheRuleStaleDuration,
          onSVGLoadFailedCallback: onSVGLoadFailedCallback,
          svgLoadRetryLimit: svgLoadRetryLimit,
        );
      } else {
        return PNGCachedNetworkImageView(
            progressIndicatorWidget: progressIndicatorWidget,
            errorWidget: errorWidget,
            networkErrorPlaceHolderImagePath: networkErrorPlaceHolderImagePath,
            colorProgressLoaderIndicator: colorProgressLoaderIndicator,
            boxFit: boxFit,
            imagePathOrURL: imagePathOrURL,
            height: height,
            width: width,
            filterQuality: filterQuality);
      }
    } else {
      return getImageFromAssetView();
    }
  }

  Widget getImageFromAssetView() {
    if (imagePathOrURL.isNotEmpty) {
      if (boxFit != null) {
        if (imagePathOrURL.endsWith(".png")) {
          return Image.asset(imagePathOrURL, height: height, width: width, filterQuality: filterQuality ?? FilterQuality.high, fit: boxFit);
        } else if (imagePathOrURL.endsWith(".svg")) {
          return SvgPicture.asset(imagePathOrURL, height: height, width: width, fit: boxFit!, color: colorSVG);
        } else {
          return const EmptyContainerHelperWidget();
        }
      } else {
        //box fit is null
        if (imagePathOrURL.endsWith(".png")) {
          return Image.asset(imagePathOrURL, height: height, width: width, filterQuality: filterQuality ?? FilterQuality.high);
        } else if (imagePathOrURL.endsWith(".svg")) {
          return SvgPicture.asset(imagePathOrURL, height: height, width: width, color: colorSVG);
        } else {
          return const EmptyContainerHelperWidget();
        }
      }
    } else {
      return const EmptyContainerHelperWidget();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieNetworkLoaderHelperWidget extends StatelessWidget {
  final double height;
  final double width;
  final BoxFit? boxFit;
  final bool? repeatAnimation;
  final String animationJsonPath;

  ///[height] is required
  ///[width] is required
  ///[boxFit] is optional | default is fill
  ///[repeatAnimation] is optional | default is false
  ///[animationJsonPath] is required
  const LottieNetworkLoaderHelperWidget(
      {Key? key, this.repeatAnimation = false, required this.animationJsonPath, required this.height, required this.width, this.boxFit = BoxFit.fill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Lottie.asset(animationJsonPath, width: width, height: height, fit: boxFit, repeat: repeatAnimation))));
  }
}

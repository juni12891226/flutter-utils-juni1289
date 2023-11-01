import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';

class MarqueeHelperWidget extends StatelessWidget {
  final TextDirection? textDirection;
  final Widget childWidget;
  final Duration? animationDuration;
  final Duration? backDuration;
  final Duration? pauseDuration;
  final bool? autoRepeat;

  ///Simple Marquee Widget
  ///[childWidget] is required, can be the Text Widget
  ///[textDirection] is optional, default is LTR
  ///[animationDuration] is optional, default is 5000 milliseconds
  ///[backDuration] is optional, default is 5000 milliseconds
  ///[pauseDuration] is optional, default is 2000 milliseconds
  ///[autoRepeat] is optional, default is true
  const MarqueeHelperWidget({super.key, this.animationDuration, this.autoRepeat, this.backDuration, this.pauseDuration, required this.childWidget, this.textDirection});

  @override
  Widget build(BuildContext context) {
    return Marquee(
      textDirection: textDirection ?? TextDirection.ltr,
      animationDuration: animationDuration ?? const Duration(milliseconds: 5000),
      backDuration: backDuration ?? const Duration(milliseconds: 5000),
      pauseDuration: pauseDuration ?? const Duration(milliseconds: 2000),
      autoRepeat: autoRepeat ?? true,
      child: childWidget,
    );
  }
}

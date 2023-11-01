import 'package:flutter/material.dart';
import 'package:flutter_utils_juni1289/exceptions/consumer_with_on_ready_callback_exception.dart';
import 'package:flutter_utils_juni1289/providerutil/lifecycle/widget_life_cycle_base.dart';
import 'package:flutter_utils_juni1289/providerutil/typedefs/typedefs.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class ConsumerWithOnReadyCallBackFor1ViewModel<T> extends StatelessWidget with WidgetLifeCycleBase {
  final ConsumerBuilderCallBack1<T> builder;
  final ConsumerReadyCallBack1<T>? onModelReady;
  final GlobalKey<NavigatorState> navigatorKey;

  ConsumerWithOnReadyCallBackFor1ViewModel({Key? key, required this.navigatorKey, required this.builder, this.onModelReady}) : super(key: key) {
    $configureLifeCycle();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(builder: (context, viewModel, child) {
      return builder(context, viewModel, child);
    });
  }

  @override
  void onInit() {
    if (onModelReady != null) {
      if (navigatorKey.currentState != null) {
        onModelReady!(Provider.of<T>(navigatorKey.currentState!.context, listen: false));
      } else {
        throw ConsumerWithOnReadyCallbackException(cause: "onInit has issues:::Error Code:::1100");
      }
    }
    super.onInit();
  }
}

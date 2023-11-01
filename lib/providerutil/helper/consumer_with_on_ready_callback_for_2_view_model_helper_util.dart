import 'package:flutter/material.dart';
import 'package:flutter_utils_juni1289/exceptions/consumer_with_on_ready_callback_exception.dart';
import 'package:flutter_utils_juni1289/providerutil/lifecycle/widget_life_cycle_base.dart';
import 'package:flutter_utils_juni1289/providerutil/typedefs/typedefs.dart';
import 'package:provider/provider.dart';

//ignore: must_be_immutable
class ConsumerWithOnReadyCallBackFor2ViewModel<T, K> extends StatelessWidget with WidgetLifeCycleBase {
  final ConsumerBuilderCallBack2<T, K> builder;
  final ConsumerReadyCallBack2<T, K>? onModelsReady;
  final GlobalKey<NavigatorState> navigatorKey;

  ConsumerWithOnReadyCallBackFor2ViewModel({Key? key, required this.builder, this.onModelsReady, required this.navigatorKey}) : super(key: key) {
    $configureLifeCycle();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<T, K>(builder: (context, viewModel, viewModel2, child) {
      return builder(context, viewModel, viewModel2, child);
    });
  }

  @override
  void onInit() {
    if (onModelsReady != null) {
      if (navigatorKey.currentState != null) {
        onModelsReady!(Provider.of<T>(navigatorKey.currentState!.context, listen: false), Provider.of<K>(navigatorKey.currentState!.context, listen: false));
      } else {
        throw ConsumerWithOnReadyCallbackException(cause: "onInit has issues:::Error Code:::1200");
      }
    }
  }
}

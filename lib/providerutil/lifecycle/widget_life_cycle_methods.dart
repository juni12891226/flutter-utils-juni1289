import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_utils_juni1289/providerutil/lifecycle/widget_life_cycle.dart';

abstract class WidgetLifeCycleMethods extends WidgetLifecycle {
  @override
  @mustCallSuper
  void onInit() {
    super.onInit();
    SchedulerBinding.instance.addPostFrameCallback((_) => onReady());
  }

  @override
  @mustCallSuper
  void onReady() {
    super.onReady();
  }

  @override
  @mustCallSuper
  void onClose() {
    super.onClose();
  }
}

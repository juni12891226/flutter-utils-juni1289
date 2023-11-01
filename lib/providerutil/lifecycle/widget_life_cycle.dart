import 'package:flutter_utils_juni1289/providerutil/lifecycle/widget_life_cycle_base.dart';

abstract class WidgetLifecycle with WidgetLifeCycleBase {
  WidgetLifecycle() {
    $configureLifeCycle();
  }
}

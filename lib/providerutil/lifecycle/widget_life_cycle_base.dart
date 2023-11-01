import 'package:flutter_utils_juni1289/providerutil/typedefs/typedefs.dart';

class InternalFinalCallback<T> {
  ValueUpdater<T>? _callBack;

  InternalFinalCallback({ValueUpdater<T>? callBack}) : _callBack = callBack;

  T call() {
    return _callBack!.call();
  }
}

mixin WidgetLifeCycleBase {
  final onStart = InternalFinalCallback<void>();
  final onDelete = InternalFinalCallback<void>();

  void onInit() {}

  void onReady() {}

  void onClose() {}

  bool _initialized = false;

  bool get initialized => _initialized;

  void _onStart() {
    if (_initialized) return;
    onInit();
    _initialized = true;
  }

  bool _isClosed = false;

  bool get isClosed => _isClosed;

  void _onDelete() {
    if (_isClosed) return;
    _isClosed = true;
    onClose();
  }

  void $configureLifeCycle() {
    _checkIfLifeCycleIsAlreadyConfigured();
    (onStart._callBack = _onStart)();
    (onDelete._callBack = _onDelete)();
  }

  void _checkIfLifeCycleIsAlreadyConfigured() {
    if (_initialized) {
      throw "You can only configure lifecycle once";
    }
  }
}

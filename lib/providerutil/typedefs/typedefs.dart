import 'package:flutter/material.dart';

typedef ConsumerBuilderCallBack1<T> = Widget Function(BuildContext, T, Widget?);
typedef ConsumerReadyCallBack1<T> = Function(T);
typedef ValueUpdater<T> = T Function();

typedef ConsumerBuilderCallBack2<T, K> = Widget Function(BuildContext, T, K, Widget?);

typedef ConsumerReadyCallBack2<T, K> = Function(T, K);

import 'package:backgrounds/Tools/StateEnums.dart';
import 'package:backgrounds/Widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'BaseProvider.dart';

class BaseWidget<T extends BaseProvider> extends StatefulWidget {
  final T provider;
  final Widget Function(BuildContext context, T provider, Widget child) builder;
  final Widget staticChild;
  final Function(dynamic) fetchData;
  const BaseWidget(
      {Key key, this.builder, this.provider, this.staticChild, this.fetchData})
      : super(key: key);

  @override
  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends BaseProvider> extends State<BaseWidget<T>> {
  T model;

  @override
  void initState() {
    model = widget.provider;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => model,
      child: Consumer<T>(
        builder: (context, pr, child) {
          if (pr.state == PrState.Fetching) return LoadingWidget();
          return widget.builder(context, pr, child);
        },
        child: widget.staticChild,
      ),
    );
  }
}

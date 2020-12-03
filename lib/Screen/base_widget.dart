import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final T model;
  final Widget child;
  final Function(T) onModelReady;

  BaseWidget({
    Key key,
    this.builder,
    this.model,
    this.child,
    this.onModelReady,
  }) : super(key: key);

  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends ChangeNotifier> extends State<BaseWidget<T>> {
  T model;

  @override
  void initState() {
    model = widget.model;

    if (widget.onModelReady != null) {
      widget.onModelReady(model);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Base Widget called!');
    
    double deviceFontSize = MediaQuery.of(context).textScaleFactor;
    double maxTextFactor = deviceFontSize > 1.1 ? 1.1 : deviceFontSize;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: maxTextFactor),
      child: ChangeNotifierProvider<T>(
        create: (context) => model,
        child: Consumer<T>(
          builder: widget.builder,
          child: widget.child,
        ),
      ),
    );
  }
}

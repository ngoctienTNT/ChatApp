import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

// TODO
// rewrite by getX dialog
class FadedOverlay {
  static OverlayEntry? _overlayEntry;
  static double opacacity = 0.5;
  static void show(BuildContext context, Widget widget) {
    OverlayState overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
        builder: (context) => Scaffold(
              backgroundColor: Colors.white.withOpacity(opacacity),
              body: Center(child: widget),
            ));
    overlayState.insert(_overlayEntry!);
  }

  static void showLoading(BuildContext context) {
    FadedOverlay.show(
        context,
        const SizedBox(
            height: 100,
            width: 100,
            child: LoadingIndicator(
              indicatorType: Indicator.ballPulseSync,

              /// Required, The loading type of the widget
              // colors: const [Colors.white],

              /// Optional, The color collections
              // strokeWidth: 2,

              /// Optional, The stroke of the line, only applicable to widget which contains line
              //backgroundColor: Colors.black,      /// Optional, Background of the widget
              //pathBackgroundColor: Colors.black

              /// Optional, the stroke backgroundColor
            )));
  }

  static void remove() {
    if (_overlayEntry != null) _overlayEntry!.remove();
  }
}

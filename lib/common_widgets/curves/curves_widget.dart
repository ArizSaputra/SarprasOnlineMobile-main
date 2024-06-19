import 'package:flutter/cupertino.dart';
import 'package:sarprasonlinemobile/common_widgets/curves/curves.dart';

class CurvedWidget extends StatelessWidget {
  const CurvedWidget({
    super.key,
    required this.child,
    });

    final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomCurves(),
      child: child,
    );
  }
}
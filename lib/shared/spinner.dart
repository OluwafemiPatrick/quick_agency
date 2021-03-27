import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'colors.dart';

class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorBackground,
      child: Center(
        child: SpinKitCircle(
          color: colorPrimaryRed,
          size: 60.0,
        ),
      ),
    );
  }
}

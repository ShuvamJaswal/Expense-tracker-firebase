import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpinKitThreeBounce(
      color: Colors.blueAccent,
      size: 50.0,
    );
  }
}

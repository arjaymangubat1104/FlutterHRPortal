import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: LoadingIndicator(
          indicatorType: Indicator.ballBeat,
          colors: [Colors.deepOrange, Colors.red, Colors.yellow],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_attendance_system/viewmodel/theme_view_model.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.5),
      child: SizedBox(
        width: 100,
        height: 50,
        child: Center(
          child: SizedBox(
            width: 100,
            height: 50,
            child: LoadingIndicator(
              indicatorType: Indicator.ballBeat,
              colors: [themeViewModel.currentTheme.themeColor, Colors.red, Colors.yellow],
            ),
          ),
        ),
      ),
    );
  }
}

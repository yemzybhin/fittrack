import 'package:fittrack/core/components/buttons/CustomButton.dart';
import 'package:fittrack/core/utils/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WorkoutBottomSheet extends StatelessWidget {
  final MethodChannel _channel = MethodChannel('fittrack/timer');

  void _handleAction(String action) async {
    try {
      await _channel.invokeMethod(action);
    } catch (e) {
      print("Error invoking $action: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 120,
        padding: EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.zero,
            border: Border(top: BorderSide(color: Colors.white54, width: 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton(
                Icons.pause, "Pause", () => _handleAction("pauseWorkout")),
            _buildButton(Icons.play_arrow, "Continue",
                () => _handleAction("resumeWorkout")
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, VoidCallback onPressed) {
    return CustomButton(
      onpressed: onPressed,
      horizontalPadding: 20,
      verticalPadding: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon( icon,size: 28, color: Colors.deepPurple),
          SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontFamily: CustomFonts.Montserrat_Bold)
          ),
        ],
      ),
    );
  }
}

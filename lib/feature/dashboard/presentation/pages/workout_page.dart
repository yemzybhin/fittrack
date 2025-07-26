import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/utils/fonts.dart';
import '../widgets/custom_progress_ring.dart';
import '../widgets/heart_rate_display.dart';
import '../widgets/workout_bottom_sheet.dart';

class WorkoutPage extends StatefulWidget {
  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  static const _channel = MethodChannel('fittrack/sensors');
  int _steps = 0;
  int _heartRate = 80;

  void requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler((call) async {
      if (call.method == "sensorUpdate") {
        final data = Map<String, dynamic>.from(call.arguments);
        setState(() {
          _steps = data["steps"] ?? 0;
          _heartRate = data["heartRate"] ?? 80;
        });
      }
    });


    requestNotificationPermission();
  }

  void _onSwipe(BuildContext context, String direction) {
    final message = switch (direction) {
      'left' => "Skipped",
      'right' => "Paused",
      'down' => "Stopped",
      _ => null
    };

    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: Duration(milliseconds: 800)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.deepPurple[700],
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null) {
              if (details.primaryVelocity! > 0) {
                _onSwipe(context, 'right');
              } else {
                _onSwipe(context, 'left');
              }
            }
          },
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null &&
                details.primaryVelocity! > 1000) {
              _onSwipe(context, 'down');
            }
          },
          child: Stack(
            children: [
              Positioned.fill(
                  child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.redAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
              )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      HeartRateDisplay(heartRate: _heartRate),
                      CustomProgressRing(progress: (_steps % 1000) / 1000),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "$_steps",
                          style: TextStyle(
                            fontFamily: CustomFonts.Montserrat_ExtraBlack,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: ' Steps',
                          style: TextStyle(
                            fontFamily: CustomFonts.Montserrat_ExtraBlack,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  WorkoutBottomSheet()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sevenapplication/utils/colors_app.dart';
import 'package:sevenapplication/widgets/textWidgets/large_text.dart';

class _HeartbeatCurve extends Curve {
  const _HeartbeatCurve._();

  @override
  double transformInternal(double t) {
    double Breath(double t) {
      double breathValue = 1.5 + 0.5 * sin(2 * pi * t);
      return breathValue;
    }

    double normalizedT = (t * 0.5) % 1.0;
    double bounceValue = Breath(normalizedT * 2.0) * 1.5;

    return (2.0 - bounceValue) * 2 + 0.5;
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _zoomInController;
  late Animation<double> _zoomInAnimation;
  late AnimationController _shrinkController;
  late Animation<double> _shrinkAnimation;

  @override
  void initState() {
    super.initState();

    _zoomInController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7), // Zoom in duration
    )
      ..forward(from: 0.5)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _shrinkController.forward();
        }
      });

    _zoomInAnimation = CurvedAnimation(
      parent: _zoomInController,
      curve: const _HeartbeatCurve._(),
    );

    _shrinkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Shrink duration
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          GoRouter.of(context).pushReplacement('/home');
        }
      });

    _shrinkAnimation = CurvedAnimation(
      parent: _shrinkController,
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  @override
  void dispose() {
    _zoomInController.dispose();
    _shrinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      //// Twitter blue color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _zoomInAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: (1 * _zoomInAnimation.value) > 0.8
                      ? 1 * _zoomInAnimation.value
                      : 1,
                  child: AnimatedBuilder(
                    animation: _shrinkAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        // Apply the translation based on _shrinkAnimation
                        offset: Offset(
                          0.0,
                          100.0 * (1 - _shrinkAnimation.value * 2 - 0.2) - 100,
                        ),
                        child: child,
                      );
                    },
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorsConst.col_app,
                        width: 10,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 102, 102, 102),
                          blurRadius: 2,
                          offset: Offset(4, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 80.w,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 70.w,
                        backgroundColor: Colors.white,
                        child: Padding(
                            padding: const EdgeInsets.all(17),
                            child: Image.asset("assets/images/jobs3.png")),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  LargeText(
                    text: "SEVEN JOBS",
                    textColor: ColorsConst.col_app,
                    textSize: screenSize.width / 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

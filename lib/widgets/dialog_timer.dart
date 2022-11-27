import 'dart:async';
import 'package:flutter/material.dart';

///Widget that displays a countdown from the given duration to 0 when initialized
///Required key time sets the duration in seconds
class DialogTimer extends StatefulWidget {
  final int time;
  const DialogTimer({Key? key, required this.time}) : super(key: key);

  @override
  State<DialogTimer> createState() => _DialogTimerState();
}

class _DialogTimerState extends State<DialogTimer> {
  Timer? timer;
  late Duration alertDuration;//start time for the countdown

  @override
  void initState() {
    super.initState();
    alertDuration = Duration(seconds: widget.time);

    /// Periodic timer is created when widget DialogTimer is initialized
    timer = Timer.periodic(
        const Duration(seconds: 1), //call setCountDown every second
            (_) => setCountDown()
    );
  }

  /// cancel the timer when widget is disposed,
  /// to avoid any active timer that is not executed yet
  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = alertDuration.inSeconds;
    return Text('$seconds',
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  /// Reduces the alerDuration, i.e time displayed, each time it's called.
  /// Until it reached zero, then timer is cancelled.
  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = alertDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        timer!.cancel();
      } else {
        alertDuration = Duration(seconds: seconds);
      }
    });
  }
}
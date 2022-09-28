import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  final int maxSeconds;
  final String resendText;
  final Function? action;
  const CountdownTimer({
    Key? key,
    required this.resendText,
    required this.maxSeconds,
    required this.action,
  }) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Duration? duration;

  String toSeconds() {
    Duration d = _controller!.duration! * _controller!.value;
    int minutes = (d.inSeconds / 60).floor();
    int seconds = (d.inSeconds - minutes * 60).floor();

    return minutes.toString().padLeft(2, '0') +
        ':' +
        seconds.toString().padLeft(2, '0');
  }

  @override
  void initState() {
    super.initState();
    duration = Duration(seconds: widget.maxSeconds);
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    _controller!.reverse(from: widget.maxSeconds.toDouble());
    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        // if action is supplied than perform that action.
        if (widget.action != null) {
          widget.action!();
        }
      }
    });
  }

  @override
  void didUpdateWidget(CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.maxSeconds != oldWidget.maxSeconds) {
      setState(() {
        duration = Duration(seconds: widget.maxSeconds);
        _controller!.dispose();
        _controller = AnimationController(
          vsync: this,
          duration: duration,
        );
        _controller!.reverse(from: widget.maxSeconds.toDouble());
        _controller!.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            // if action is supplied than perform that action.
            if (widget.action != null) {
              widget.action!();
            }
          } else if (status == AnimationStatus.dismissed) {
            debugPrint("Animation Complete");
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: AnimatedBuilder(
        animation: _controller!,
        builder: (_, child) {
          return Text(
            "${widget.resendText}: ${toSeconds()}",
            style: const TextStyle(
              fontFamily: "Inter",
              fontSize: 14,
            ),
          );
        },
      ),
    );
  }
}

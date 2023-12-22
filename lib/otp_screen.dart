import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  OtpScreen({required this.phoneNumber});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  late Timer _timer;
  int _secondsRemaining = 120;
  bool _timerActive = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (timer) {
        if (_secondsRemaining <= 0) {
          setState(() {
            _timerActive = false;
          });
          _timer.cancel();
        } else {
          setState(() {
            _secondsRemaining--;
          });
        }
      },
    );
  }

  void resetTimer() {
    setState(() {
      _secondsRemaining = 120;
      _timerActive = true;
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 120),
            Text(
              'Verify OTP sent to ${widget.phoneNumber}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 50),
            PinInputTextField(
              pinLength: 6,
              controller: _pinPutController,
              decoration: UnderlineDecoration(
                textStyle: TextStyle(color: Colors.white),
                colorBuilder: FixedColorBuilder(Colors.white),
              ),
              autoFocus: true,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              onChanged: (pin) {
                if (pin.length == 6) {
                  _timer.cancel();
                }
              },
            ),
            SizedBox(height: 50),
            if (_timerActive)
              Text(
                'Resend code in $_secondsRemaining seconds',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              )
            else
              TextButton(
                onPressed: () {
                  resetTimer();
                  // Trigger resend OTP functionality
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                ),
                child: Text('Resend OTP',),
              ),
            Spacer(),
            SingleChildScrollView(
              child: ElevatedButton(
                onPressed: () {
                  // Logic to verify OTP
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  primary: Colors.redAccent,
                  onPrimary: Colors.white,
                  elevation: 3,
                  shadowColor: Colors.redAccent,
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('Verify'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

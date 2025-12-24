import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  _FocusScreenState createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  static const int _pomodoroDuration = 25 * 60; // 25 minutos
  Timer? _timer;
  int _remainingTime = _pomodoroDuration;
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          // TODO: Implementar una notificación o sonido para indicar el final del Pomodoro
        }
      });
    });
  }

  void _pauseTimer() {
    if (!_isRunning) return;
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingTime = _pomodoroDuration;
      _isRunning = false;
    });
  }

  String get _formattedTime {
    final minutes = (_remainingTime / 60).floor().toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.focus,
              style: GoogleFonts.oswald(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            _buildTimerDisplay(),
            const SizedBox(height: 48),
            _buildTimerControls(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerDisplay() {
    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: _remainingTime / _pomodoroDuration,
            strokeWidth: 12,
            backgroundColor: Colors.grey.shade800,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade300),
          ),
          Center(
            child: Text(
              _formattedTime,
              style: GoogleFonts.oswald(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerControls(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!_isRunning)
          ElevatedButton(
            onPressed: _startTimer,
            child: Text(l10n.start),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          )
        else
          ElevatedButton(
            onPressed: _pauseTimer,
            child: Text(l10n.pause),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        const SizedBox(width: 24),
        ElevatedButton(
          onPressed: _resetTimer,
          child: Text(l10n.reset),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            backgroundColor: Colors.red.shade400,
          ),
        ),
      ],
    );
  }
}

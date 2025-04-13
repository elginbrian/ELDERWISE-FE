import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class FallDetectionService {
  static final FallDetectionService _instance =
      FallDetectionService._internal();
  factory FallDetectionService() => _instance;
  FallDetectionService._internal();

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  double fallThreshold = 15.0;
  bool isActive = false;
  bool isRunningInBackground = false;
  DateTime? lastFallDetectionTime;

  Function? startSosCountdown;

  VoidCallback? onFallDetected;
  UserMode _currentUserMode = UserMode.caregiver;

  Future<void> initialize() async {
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await FlutterForegroundTask.requestNotificationPermission();
  }

  void startMonitoring({
    required VoidCallback onFallDetected,
    required UserMode userMode,
    Function? startSosCountdown,
  }) {
    this.onFallDetected = onFallDetected;
    this.startSosCountdown = startSosCountdown;
    _currentUserMode = userMode;

    if (_currentUserMode != UserMode.elder) {
      stopMonitoring();
      return;
    }

    if (isActive) return;

    isActive = true;
    _startAccelerometerListening();

    if (!isRunningInBackground) {
      _startForegroundService();
    }
  }

  void stopMonitoring() {
    isActive = false;
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;

    if (isRunningInBackground) {
      _stopForegroundService();
    }
  }

  void updateUserMode(UserMode userMode) {
    bool wasElder = _currentUserMode == UserMode.elder;
    _currentUserMode = userMode;

    if (!wasElder &&
        _currentUserMode == UserMode.elder &&
        onFallDetected != null) {
      startMonitoring(
        onFallDetected: onFallDetected!,
        userMode: _currentUserMode,
        startSosCountdown: startSosCountdown,
      );
    }
    else if (wasElder && _currentUserMode != UserMode.elder) {
      stopMonitoring();
    }
  }

  Future<void> _startForegroundService() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'fall_detection_channel',
        channelName: 'Fall Detection Service',
        channelDescription: 'Running fall detection in background',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 1000,
        autoRunOnBoot: false,
        allowWifiLock: true,
      ),
    );

    await FlutterForegroundTask.startService(
      notificationTitle: 'Fall Detection Active',
      notificationText: 'Monitoring for falls',
      callback: _fallDetectionCallback,
    );

    isRunningInBackground = true;
  }

  Future<void> _stopForegroundService() async {
    await FlutterForegroundTask.stopService();
    isRunningInBackground = false;
  }

  static void _fallDetectionCallback() {
    FlutterForegroundTask.setTaskHandler(FallDetectionTaskHandler());
  }

  void _startAccelerometerListening() {
    _accelerometerSubscription = accelerometerEvents.listen(_detectFall);
  }

  void _detectFall(AccelerometerEvent event) {
    if (!isActive) return;

    double accelerationMagnitude = _calculateAccelerationMagnitude(event);

    if (accelerationMagnitude > fallThreshold) {
      if (lastFallDetectionTime == null ||
          DateTime.now().difference(lastFallDetectionTime!).inSeconds > 5) {
        lastFallDetectionTime = DateTime.now();

        _confirmFallWithDelay();
      }
    }
  }

  double _calculateAccelerationMagnitude(AccelerometerEvent event) {
    return sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
  }

  void _confirmFallWithDelay() {
    Timer(const Duration(milliseconds: 500), () {
      HapticFeedback.heavyImpact();

      if (startSosCountdown != null) {
        startSosCountdown!();
      } else if (onFallDetected != null) {
        onFallDetected!();
      }
    });
  }
}

class FallDetectionTaskHandler extends TaskHandler {
  void _sendPort(String message) {
    final receivePort = FlutterForegroundTask.receivePort;
    if (receivePort != null) {
      receivePort.sendPort.send(message);
    }
  }

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort('Fall detection service started');
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    _sendPort('Fall detection service stopped');
  }

  @override
  void onButtonPressed(String id) {
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
  }
}

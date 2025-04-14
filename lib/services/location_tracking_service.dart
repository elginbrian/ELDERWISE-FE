import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:elderwise/domain/enums/user_mode.dart';
import 'package:elderwise/data/repositories/user_mode_repository.dart';
import 'package:elderwise/presentation/bloc/location_history/location_history_bloc.dart';
import 'package:elderwise/presentation/bloc/location_history/location_history_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';

class LocationTrackingService {
  static final LocationTrackingService _instance =
      LocationTrackingService._internal();
  factory LocationTrackingService() => _instance;

  LocationTrackingService._internal();

  static const String _isolateName = 'locationTrackingIsolate';
  static const String _receiverPort = 'locationReceiver';
  static SendPort? _sendPort;

  Timer? _locationTimer;
  final UserModeRepository _userModeRepository = UserModeRepository();
  bool _isActive = false;
  String? _elderId;
  String? _caregiverId;

  bool get isActive => _isActive;

  void startTracking(String elderId, {String? caregiverId}) {
    if (_isActive) return;

    _elderId = elderId;
    _caregiverId = caregiverId;
    _isActive = true;
    debugPrint('Starting location tracking for elder ID: $_elderId');

    _setupIsolateChannel();

    if (!kIsWeb) {
      _startForegroundService();
    } else {
      _startLocationUpdates();
    }
  }

  void _setupIsolateChannel() {
    final ReceivePort receivePort = ReceivePort();
    if (IsolateNameServer.lookupPortByName(_receiverPort) != null) {
      IsolateNameServer.removePortNameMapping(_receiverPort);
    }
    IsolateNameServer.registerPortWithName(
      receivePort.sendPort,
      _receiverPort,
    );

    receivePort.listen((dynamic message) {
      if (message is Map<String, dynamic>) {
        _processLocationUpdate(message);
      }
    });
  }

  void _processLocationUpdate(Map<String, dynamic> data) {
    try {
      if (data.containsKey('latitude') &&
          data.containsKey('longitude') &&
          data.containsKey('timestamp')) {
        final double latitude = data['latitude'];
        final double longitude = data['longitude'];
        final DateTime timestamp = data['timestamp'] is String
            ? DateTime.parse(data['timestamp'])
            : DateTime.now().toUtc();

        if (_elderId != null) {
          _sendLocationUpdate(_elderId!, latitude, longitude, timestamp);
        }
      }
    } catch (e) {
      debugPrint(
          'Error processing location update from foreground service: $e');
    }
  }

  void stopTracking() {
    if (!_isActive) return;

    _isActive = false;
    _locationTimer?.cancel();
    _locationTimer = null;

    if (!kIsWeb) {
      _stopForegroundService();
    }

    if (IsolateNameServer.lookupPortByName(_receiverPort) != null) {
      IsolateNameServer.removePortNameMapping(_receiverPort);
    }

    debugPrint('Location tracking stopped');
  }

  Future<void> _startForegroundService() async {
    final status = await _checkLocationPermission();
    if (!status) {
      debugPrint('Location permissions not granted, cannot start tracking');
      _isActive = false;
      return;
    }

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'location_tracking_channel',
        channelName: 'Location Tracking Service',
        channelDescription: 'Tracking elder location in background',
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
        interval: 300000,
        isOnceEvent: false,
        autoRunOnBoot: false,
        allowWifiLock: true,
      ),
    );

    FlutterForegroundTask.setTaskHandler(LocationTrackingTaskHandler(
      elderId: _elderId,
      caregiverId: _caregiverId,
    ));

    await FlutterForegroundTask.startService(
      notificationTitle: 'ElderWise Location Tracking',
      notificationText: 'Monitoring location for elder safety',
      callback: startLocationTrackingCallback,
    );
  }

  Future<bool> _checkLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever;
    } catch (e) {
      debugPrint('Error checking location permission: $e');
      return false;
    }
  }

  Future<void> _stopForegroundService() async {
    await FlutterForegroundTask.stopService();
  }

  void _startLocationUpdates() {
    _locationTimer?.cancel();

    _checkLocationPermission().then((hasPermission) {
      if (!hasPermission) {
        debugPrint('Location permissions not granted, cannot start tracking');
        _isActive = false;
        return;
      }

      _locationTimer = Timer.periodic(const Duration(minutes: 5), (_) {
        _updateLocation();
      });

      _updateLocation();
    });
  }

  Future<void> _updateLocation() async {
    if (!_isActive || _elderId == null) return;

    final userMode = await _userModeRepository.getUserMode();
    if (userMode != UserMode.elder) {
      stopTracking();
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      );

      _sendLocationUpdate(
        _elderId!,
        position.latitude,
        position.longitude,
        DateTime.now().toUtc(),
      );
    } catch (e) {
      debugPrint('Error getting current location: $e');
    }
  }

  void _sendLocationUpdate(
      String elderId, double latitude, double longitude, DateTime timestamp) {
    debugPrint('Sending location update: $latitude, $longitude');

    try {
      final bloc = GetIt.I<LocationHistoryBloc>();
      bloc.add(AddLocationHistoryPointEvent(
        elderId: elderId,
        latitude: latitude,
        longitude: longitude,
        timestamp: timestamp,
      ));
    } catch (e) {
      debugPrint('Error accessing location history bloc: $e');
    }
  }
}

@pragma('vm:entry-point')
void startLocationTrackingCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTrackingTaskHandler());
}

class LocationTrackingTaskHandler extends TaskHandler {
  String? elderId;
  String? caregiverId;
  Timer? _timer;
  final UserModeRepository _userModeRepository = UserModeRepository();

  LocationTrackingTaskHandler({this.elderId, this.caregiverId});

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    debugPrint('Location tracking service started with elderId: $elderId');

    _setupCommunication();

    _timer = Timer.periodic(const Duration(minutes: 5), (_) async {
      _checkModeAndUpdateLocation(sendPort);
    });

    _checkModeAndUpdateLocation(sendPort);
  }

  void _setupCommunication() {
    final SendPort? mainSendPort =
        IsolateNameServer.lookupPortByName('locationReceiver');

    if (mainSendPort != null) {
      debugPrint('Found main app receiver port');
    } else {
      debugPrint('Main app receiver port not found, will retry later');
    }
  }

  Future<void> _checkModeAndUpdateLocation(SendPort? sendPort) async {
    if (elderId == null) {
      debugPrint('Elder ID is null, cannot update location');
      return;
    }

    try {
      final userMode = await _userModeRepository.getUserMode();
      if (userMode != UserMode.elder) {
        debugPrint('Not in elder mode, skipping location update');
        return;
      }
    } catch (e) {
      debugPrint('Error checking user mode: $e');
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      );

      final locationData = {
        'elderId': elderId,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
      };

      if (sendPort != null) {
        sendPort.send(locationData);
      }

      final mainSendPort =
          IsolateNameServer.lookupPortByName('locationReceiver');
      if (mainSendPort != null) {
        mainSendPort.send(locationData);
      }

      debugPrint(
          'Location updated in background: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      debugPrint('Error getting location in background: $e');
    }
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    await _checkModeAndUpdateLocation(sendPort);
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    _timer?.cancel();
    debugPrint('Location tracking service destroyed');
  }

  @override
  void onButtonPressed(String id) {
    debugPrint('Button pressed: $id');
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    await _checkModeAndUpdateLocation(sendPort);
  }
}

import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

class RequestPermissionControlller {
  late final Permission _locationPermission;
  RequestPermissionControlller(this._locationPermission);
  final _streamController = StreamController<PermissionStatus>.broadcast();

  Stream<PermissionStatus> get onStatusChanged => _streamController.stream;

  request() async {
    final status = await _locationPermission.request();
    _notify(status);
  }

  void _notify(PermissionStatus status) {
    if (!_streamController.isClosed && _streamController.hasListener) {
      _streamController.sink.add(status);
    }
  }

  void dispose() {
    _streamController.close();
  }
}

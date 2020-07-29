import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  final PermissionHandler _permissionHandler = PermissionHandler();

  Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  /// Requests the users permission to read their camera when the app is in use
  Future<bool> requestCameraPermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.camera);
    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }

  /// Requests the users permission to read their storage.
  Future<bool> requestStoragePermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.storage);
    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }

  Future<bool> hasCameraPermission() async {
    return hasPermission(PermissionGroup.camera);
  }

  Future<bool> hasStoragePermission() async {
    return hasPermission(PermissionGroup.storage);
  }

  Future<bool> hasPermission(PermissionGroup permission) async {
    var permissionStatus =
        await _permissionHandler.checkPermissionStatus(permission);
    return permissionStatus == PermissionStatus.granted;
  }
}

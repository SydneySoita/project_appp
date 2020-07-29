import 'package:http/http.dart' as http;
import 'package:wetreats/models/shipping_address.dart';
import 'dart:convert';

import 'package:wetreats/scoped-model/connected_scoped_model.dart';

class ShippingAddressModel extends UserModel with ItemsModel {
  List<ShippingAddress> _shippingAddresses = [];
  bool _isShippingAddressLoading = false;

  List<ShippingAddress> get shippingAddresses {
    return List.from(_shippingAddresses);
  }

  bool get isShippingAddressLoading => _isShippingAddressLoading;

  Future<bool> fetchShippingAddresses() async {
    _isShippingAddressLoading = true;
    notifyListeners();

    try {
      final http.Response response = await http.get(
          "https://projectapp-bb1cf.firebaseio.com/shippingaddresses.json?auth=${user.token}");

      final List<ShippingAddress> fetchedShippingAddress = [];
      final Map<String, dynamic> shippingAddressListsData =
          json.decode(response.body);

      if (shippingAddressListsData != null) {
        shippingAddressListsData
            .forEach((String id, dynamic shippingAddressData) {
          ShippingAddress shippingAddress = ShippingAddress(
            id: id,
            firstName: shippingAddressData['firstName'],
            lastName: shippingAddressData['lastName'],
            address: shippingAddressData['address'],
            phoneNumber: shippingAddressData['phoneNumber'],
            additionalInfo: shippingAddressData['additionalInfo'],
            additionalPhoneNumber: shippingAddressData['additionalPhoneNumber'],
            region: shippingAddressData['region'],
            city: shippingAddressData['city'],
          );
          fetchedShippingAddress.add(shippingAddress);
        });
      }

      _shippingAddresses = fetchedShippingAddress;
      _isShippingAddressLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      _isShippingAddressLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<bool> addShippingAddressWithUserId(
      Map<String, dynamic> shippingAddressData) async {
    _isShippingAddressLoading = true;
    notifyListeners();

    shippingAddressData['userId'] = user.id;

    try {
      final http.Response response = await http.post(
          "https://projectapp-bb1cf.firebaseio.com/shippingaddresses.json?auth=${user.token}",
          body: json.encode(shippingAddressData));
      final Map<String, dynamic> responseData = json.decode(response.body);

      ShippingAddress shippingAddress = ShippingAddress(
        id: responseData['name'],
        firstName: shippingAddressData['firstName'],
        lastName: shippingAddressData['lastName'],
        address: shippingAddressData['address'],
        phoneNumber: shippingAddressData['phoneNumber'],
        additionalInfo: shippingAddressData['additionalInfo'],
        additionalPhoneNumber: shippingAddressData['additionalPhoneNumber'],
        region: shippingAddressData['region'],
        city: shippingAddressData['city'],
      );

      _shippingAddresses.add(shippingAddress);
      _isShippingAddressLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      _isShippingAddressLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<bool> updateShippingAddress(
      Map<String, dynamic> shippingAddressData, String shippingAddressId) async {
    _isShippingAddressLoading = true;
    notifyListeners();

    shippingAddressData['userId'] = user.id;

    int index = _shippingAddresses.indexOf(getShippingAddressById(shippingAddressId));

    try {
      final http.Response response = await http.put(
          "https://projectapp-bb1cf.firebaseio.com/shippingaddresses/${shippingAddressId}.json?auth=${user.token}",
          body: json.encode(shippingAddressData));
      final Map<String, dynamic> responseData = json.decode(response.body);

      ShippingAddress updatedShippingAddress = ShippingAddress(
        id: shippingAddressId,
        firstName: shippingAddressData['firstName'],
        lastName: shippingAddressData['lastName'],
        address: shippingAddressData['address'],
        phoneNumber: shippingAddressData['phoneNumber'],
        additionalInfo: shippingAddressData['additionalInfo'],
        additionalPhoneNumber: shippingAddressData['additionalPhoneNumber'],
        region: shippingAddressData['region'],
        city: shippingAddressData['city'],
      );

      _shippingAddresses[index] = updatedShippingAddress;
      _isShippingAddressLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {

      _isShippingAddressLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<bool> deleteShippingAddress(String shippingAddressId) async {
    _isShippingAddressLoading = true;
    notifyListeners();

    try {
      await http.delete(
          "https://projectapp-bb1cf.firebaseio.com/shippingaddresses/${shippingAddressId}.json?auth=${user.token}");
      _shippingAddresses.removeWhere((ShippingAddress shippingAddress) => shippingAddress.id == shippingAddressId);
      _isShippingAddressLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      _isShippingAddressLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  ShippingAddress getShippingAddressById(String shippingAddressId) {
    ShippingAddress shippingAddress;
    for (int i = 0; i < _shippingAddresses.length; i++) {
      if (_shippingAddresses[i].id == shippingAddressId) {
        shippingAddress = _shippingAddresses[i];
        break;
      }
    }
    return shippingAddress;
  }
}

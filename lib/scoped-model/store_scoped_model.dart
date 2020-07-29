import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:wetreats/models/store.dart';
import 'dart:convert';

import 'package:wetreats/scoped-model/connected_scoped_model.dart';

class StoreModel extends UserModel with ItemsModel {
  List<Store> _stores = [];
  bool _isStoreLoading = false;

  List<Store> get stores {
    return List.from(_stores);
  }

  bool get isStoreLoading => _isStoreLoading;

  Future<bool> fetchStores() async {
    _isStoreLoading = true;
    notifyListeners();

    try {
      final http.Response response = await http.get(
          "https://projectapp-bb1cf.firebaseio.com/stores.json?auth=${user.token}");

      final List<Store> fetchedStores = [];
      final Map<String, dynamic> storeListsData = json.decode(response.body);

      if (storeListsData != null) {
        storeListsData.forEach((String storeId, dynamic storeData) {
          Store newStore = Store(
              id: storeId,
              name: storeData['name'],
              email: storeData['email'],
              address: storeData['address'],
              phone: storeData['phone'],
              storeType: storeData['storeType'],
              description: storeData['description'],
              imagePath: storeData['imagePath'],
              imageUrl: storeData['imageUrl'],
              userId: storeData['userId']);
          fetchedStores.add(newStore);
        });
      }

      _stores = fetchedStores;
      _isStoreLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      print("There is a problem fetching the user stores: $error");
      _isStoreLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<bool> addStoreWithUserId(
      Map<String, dynamic> storeData, File storeImage) async {
    _isStoreLoading = true;
    notifyListeners();

    storeData['userId'] = user.id;
    String imagePath, imageUrl = "";

    if (storeImage != null) {
      final uploadData = await uploadItemImage(storeImage);
      if (uploadData == null) {
        return false;
      }
      imagePath = uploadData['imagePath'];
      imageUrl = uploadData['imageUrl'];
      storeData['imagePath'] = imagePath;
      storeData['imageUrl'] = imageUrl;
    }

    try {
      final http.Response response = await http.post(
          "https://projectapp-bb1cf.firebaseio.com/stores.json?auth=${user.token}",
          body: json.encode(storeData));
      final Map<String, dynamic> responseData = json.decode(response.body);

      Store storeWithID = Store(
        id: responseData['name'],
        name: storeData['name'],
        email: storeData['email'],
        phone: storeData['phone'],
        imagePath: imagePath,
        imageUrl: imageUrl,
        storeType: storeData['storeType'],
        description: storeData['description'],
        address: storeData['address'],
        userId: user.id,
      );

      _stores.add(storeWithID);
      _isStoreLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      print("An error occurred: $error");
      _isStoreLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<bool> updateStore(
      Map<String, dynamic> storeData, String storeId, File storeImage) async {
    _isStoreLoading = true;
    notifyListeners();

    storeData['userId'] = user.id;

    print("Checking the store id: $storeId");

    // get the store index
    int index = _stores.indexOf(getStoreById(storeId));

    String imageUrl = storeData['imageUrl'];
    String imagePath = storeData['imagePath'];

    if (storeImage != null) {
      final uploadData = await uploadItemImage(storeImage);

      if (uploadData == null) {
        return false;
      }

      imageUrl = uploadData["imageUrl"];
      imagePath = uploadData["imagePath"];
    }

    try {
      storeData['imageUrl'] = imageUrl;
      storeData['imagePath'] = imagePath;
      final http.Response response = await http.put(
          "https://projectapp-bb1cf.firebaseio.com/stores/${storeId}.json?auth=${user.token}",
          body: json.encode(storeData));
      final Map<String, dynamic> responseData = json.decode(response.body);

      Store updatedStoreWithID = Store(
        id: responseData['name'],
        name: storeData['name'],
        email: storeData['email'],
        phone: storeData['phone'],
        imagePath: imagePath,
        imageUrl: imageUrl,
        storeType: storeData['storeType'],
        description: storeData['description'],
        address: storeData['address'],
        userId: user.id,
      );

      _stores[index] = updatedStoreWithID;
      _isStoreLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      _isStoreLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<bool> deleteStore(String storeId) async {
    _isStoreLoading = true;
    notifyListeners();

    try {
      await http.delete(
          "https://projectapp-bb1cf.firebaseio.com/stores/${storeId}.json?auth=${user.token}");
      _stores.removeWhere((Store store) => store.id == storeId);
      _isStoreLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      print("An error occured whiles deleting store: $error");
      _isStoreLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Store getStoreById(String storeId) {
    Store store;
    for (int i = 0; i < _stores.length; i++) {
      if (_stores[i].id == storeId) {
        store = _stores[i];
        break;
      }
    }
    return store;
  }

  Store getUserStore(String userId) {
    Store userStore;
    for (int i = 0; i < _stores.length; i++) {
      if (_stores[i].userId == userId) {
        userStore = _stores[i];
        break;
      }
    }
    return userStore;
  }
}

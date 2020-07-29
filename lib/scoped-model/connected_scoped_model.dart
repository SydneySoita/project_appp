import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rxdart/rxdart.dart';
import 'package:wetreats/enums/auth_mode.dart';
import 'package:wetreats/models/item.dart';
import 'package:wetreats/models/user.dart';
import 'package:wetreats/models/user_info.dart';

class ConnectedModel extends Model {
  List<Item> _items = [];
  int _selectedItemIndex;
  bool _isLoading = false;
  User _authenticatedUser;
  UserInfo _authenticatedUserInfo;
}

class ItemsModel extends ConnectedModel {
  List<Item> get items => List.from(_items);

  int get itemSize => _items.length;

  int get selectedItemIndex => _selectedItemIndex ?? null;

  int categoryItemCount(String categoryId) =>
      List.from(_items.where((Item item) => item.categoryId == categoryId))
          .length;

  Item get selectedItem {
    if (_selectedItemIndex == null) {
      return null;
    }
    return _items[_selectedItemIndex];
  }

  bool get isLoading {
    return _isLoading;
  }

  List<Item> get lowStockItems =>
      _items.where((Item item) => item.quantity <= item.lowStock).toList();

  Future<Map<String, dynamic>> uploadItemImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://us-central1-projectapp-bb1cf.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(
        mimeTypeData[0],
        mimeTypeData[1],
      ),
    );
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    imageUploadRequest.headers['Authorization'] =
        'Bearer ${_authenticatedUser.token}';

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      return null;
    }
  }

  List<Item> getDiscountItems() {
    return _items
        .where((Item item) => item.discount > 0 || item.discount > 0.0)
        .toList();
  }

  Item getItemById(String id) {
    Item foundItem;
    _items.forEach((Item item) {
      if (item.id == id) {
        foundItem = item;
      }
    });
    return foundItem;
  }

  void toggleItemFavorite(String itemId) async {
    Item item = getItemById(itemId);
    int itemIndex = _items.indexOf(item);
    bool currentFavoriteStatus = item.isFavorite;
    bool newFavoriteStatus = !currentFavoriteStatus;

    Item updatedItem = Item(
      id: item.id,
      userId: item.userId,
      quantity: item.quantity,
      lowStock: item.lowStock,
      price: item.price,
      discount: item.discount,
      vat: item.vat,
      name: item.name,
      imageUrl: item.imageUrl,
      imagePath: item.imagePath,
      description: item.description,
      categoryId: item.categoryId,
      storeId: item.storeId,
      sku: item.sku,
      createdTime: item.createdTime,
      createdDate: item.createdDate,
      updatedTime: item.updatedTime,
      updatedDate: item.updatedDate,
      isFavorite: newFavoriteStatus,
    );

    _items[itemIndex] = updatedItem;
    notifyListeners();
    http.Response response;

    if (newFavoriteStatus) {
      response = await http.put(
          "https://projectapp-bb1cf.firebaseio.com/items/${itemId}/favoriteUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}",
          body: json.encode(true));
    } else {
      response = await http.delete(
          "https://projectapp-bb1cf.firebaseio.com/items/${itemId}/favoriteUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}");
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      Item updatedItem = Item(
        id: item.id,
        userId: item.userId,
        quantity: item.quantity,
        lowStock: item.lowStock,
        price: item.price,
        discount: item.discount,
        vat: item.vat,
        name: item.name,
        imageUrl: item.imageUrl,
        imagePath: item.imagePath,
        description: item.description,
        categoryId: item.categoryId,
        storeId: item.storeId,
        sku: item.sku,
        createdTime: item.createdTime,
        createdDate: item.createdDate,
        updatedTime: item.updatedTime,
        updatedDate: item.updatedDate,
        isFavorite: !newFavoriteStatus,
      );
      _items[itemIndex] = updatedItem;
      notifyListeners();
    }
  }

  List<Item> getItemsByStoreIdAndCategoryId(
          String storeId, String categoryId) =>
      _items
          .where((Item item) =>
              item.storeId == storeId && item.categoryId == categoryId)
          .toList();

  List<String> getStoreCategoryIds(String storeId) {
    List<String> categoryIds = [];
    List<Item> items =
        _items.where((Item item) => item.storeId == storeId).toList();
    for (int i = 0; i < items.length; i++) {
      if (!categoryIds.contains(items[i].categoryId)) {
        categoryIds.add(items[i].categoryId);
      }
    }
    return categoryIds;
  }

  List<Item> getItemsByStoreId(String storeId) =>
      _items.where((Item item) => item.storeId == storeId).toList();

  List<Item> getItemsByCategory(String categoryId) =>
      items.where((Item item) => item.categoryId == categoryId).toList();

  Future<bool> addItem(Map<String, dynamic> itemData, File itemImage) async {
    _isLoading = true;
    notifyListeners();

    String imagePath, imageUrl = "";
    if (itemImage != null) {
      final uploadData = await uploadItemImage(itemImage);
      if (uploadData == null) {
        return false;
      }
      imagePath = uploadData['imagePath'];
      imageUrl = uploadData['imageUrl'];

      itemData['imagePath'] = imagePath;
      itemData['imageUrl'] = imageUrl;
    }
    try {
      itemData['userId'] = _authenticatedUser.id;

      final http.Response response = await http.post(
          "https://projectapp-bb1cf.firebaseio.com/items.json?auth=${_authenticatedUser.token}",
          body: json.encode(itemData));

      final Map<String, dynamic> responseData = json.decode(response.body);

      final Item itemWithID = Item(
        id: responseData['name'],
        userId: _authenticatedUser.id,
        name: itemData['name'],
        categoryId: itemData['categoryId'],
        storeId: itemData['storeId'],
        description: itemData['description'],
        imageUrl: imageUrl,
        imagePath: imagePath,
        lowStock: itemData['lowStock'],
        quantity: itemData['quantity'],
        discount: itemData['discount'],
        vat: itemData['vat'],
        price: itemData['price'],
        sku: itemData['sku'],
        createdTime: itemData['createdTime'],
        createdDate: itemData['createdData'],
      );
      _items.add(itemWithID);
      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<bool> fetchItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      final http.Response response = await http.get(
          "https://projectapp-bb1cf.firebaseio.com/items.json?auth=${_authenticatedUser.token}");

      final List<Item> fetchedItems = [];
      final Map<String, dynamic> itemListsData = json.decode(response.body);

      if (itemListsData != null) {
        itemListsData.forEach((String itemId, dynamic itemData) {
          Item item = Item(
            id: itemId,
            userId: itemData['userId'],
            name: itemData['name'],
            description: itemData['description'],
            quantity: itemData['quantity'],
            categoryId: itemData['categoryId'],
            imageUrl: itemData['imageUrl'],
            imagePath: itemData['imageUrl'],
            storeId: itemData['storeId'],
            lowStock: itemData['lowStock'],
            price: itemData['price'],
            discount: itemData['discount'],
            sku: itemData['sku'],
            vat: itemData['vat'],
            isFavorite: itemData['favoriteUsers'] == null
                ? false
                : (itemData['favoriteUsers'] as Map<String, dynamic>)
                    .containsKey(_authenticatedUser.id),
            createdDate: itemData['createdDate'],
            createdTime: itemData['createdTime'],
            updatedDate: itemData['updatedDate'],
            updatedTime: itemData['updatedTime'],
          );
          fetchedItems.add(item);
        });
        _items = fetchedItems;
      } else {
        _items = fetchedItems;
      }
      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  List<Item> get userFavoriteItems =>
      _items.where((Item item) => item.isFavorite == true).toList();

  Future<bool> updateItem(
      Map<String, dynamic> itemData, String itemId, File itemImage) async {
    _isLoading = true;
    notifyListeners();

    // get the item index
    int index = _items.indexOf(getItemById(itemId));

    String imageUrl = itemData['imageUrl'];
    String imagePath = itemData['imagePath'];

    if (itemImage != null) {
      final uploadData = await uploadItemImage(itemImage);

      if (uploadData == null) {
        return false;
      }

      imageUrl = uploadData["imageUrl"];
      imagePath = uploadData["imagePath"];
    }

    try {
      itemData['userId'] = _authenticatedUser.id;
      itemData['imageUrl'] = imageUrl;
      itemData['imagePath'] = imagePath;

      await http.put(
          "https://projectapp-bb1cf.firebaseio.com/items/${itemId}.json?auth=${_authenticatedUser.token}",
          body: json.encode(itemData));
      final Item updatedItem = Item(
        id: itemId,
        name: itemData['name'],
        categoryId: itemData['categoryId'],
        description: itemData['description'],
        imageUrl: imageUrl,
        imagePath: imagePath,
        lowStock: itemData['lowStock'],
        quantity: itemData['quantity'],
        price: itemData['price'],
        userId: _authenticatedUser.id,
        storeId: itemData['storeId'],
        discount: itemData['discount'],
        vat: itemData['vat'],
        sku: itemData['sku'],
        createdDate: itemData['createdDate'],
        updatedDate: itemData['updatedDate'],
        createdTime: itemData['createdTime'],
        updatedTime: itemData['updatedTime'],
      );

      _items[index] = updatedItem;
      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<bool> deleteItem(String itemId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await http.delete(
          "https://projectapp-bb1cf.firebaseio.com/items/${itemId}.json?auth=${_authenticatedUser.token}");
      _items.removeWhere((Item item) => item.id == itemId);
      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  void setSelectedItemIndex(int index) {
    _selectedItemIndex = index;
  }
}

class UserModel extends ConnectedModel {
  Timer _authtimer;
  PublishSubject<bool> _userSubject = PublishSubject();
  List<UserInfo> _usersInfo = [];

  User get user {
    return _authenticatedUser;
  }

  UserInfo get userInfo {
    return _authenticatedUserInfo;
  }

  List<UserInfo> get usersInfo => List.from(_usersInfo);

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode authMode = AuthMode.Login,
      Map<String, dynamic> userInfo]) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> authData = {
      "email": email,
      "password": password,
      "returnSecureToken": true,
    };
    bool hasError = true;
    String message = 'Please check internet connection.';
    String userType = "customer";
    try {
      http.Response response;

      if (authMode == AuthMode.Login) {
        response = await http.post(
          "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyANwOjBpnxM1sACGdcPSWeWcqraaVY8VPA",
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'},
        );
      } else {
        response = await http.post(
          "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyANwOjBpnxM1sACGdcPSWeWcqraaVY8VPA",
          body: json.encode(authData),
        );
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      if (responseData.containsKey('idToken')) {
        _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken'],
        );

        hasError = false;
        message = "Authentication successful!";

        if (authMode == AuthMode.Login) {
          _authenticatedUserInfo = await getUserInfo(responseData['localId']);
          userType = _authenticatedUserInfo.userType;
          prefs.setString("mobileNumber", _authenticatedUserInfo.mobileNumber);
          prefs.setString("firstName", _authenticatedUserInfo.firstName);
          prefs.setString("lastName", _authenticatedUserInfo.lastName);
          prefs.setString("userType", _authenticatedUserInfo.userType);
        } else if (authMode == AuthMode.SignUp) {
          userInfo['userId'] = responseData['localId'];
          final bool userResponse = await addUserInfo(userInfo);
          if (userResponse) {
            hasError = false;
            prefs.setString("mobileNumber", userInfo['mobileNumber']);
            prefs.setString("firstName", userInfo["firstName"]);
            prefs.setString("lastName", userInfo['lastName']);
            prefs.setString("userType", userInfo['userType']);
          } else {
            hasError = true;
            message = "Fialed to sign up ";
          }
        }

        setAuthTimeout(int.parse(responseData["expiresIn"]));
        _userSubject.add(true);
        final DateTime now = DateTime.now();
        final DateTime expiryTime =
            now.add(Duration(seconds: int.parse(responseData["expiresIn"])));
        prefs.setString('token', responseData['idToken']);
        prefs.setString('userEmail', email);
        prefs.setString('userId', responseData['localId']);
        prefs.setString('expiryTime', expiryTime.toIso8601String());
      } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
        message = "Email or password is incorrect";
      } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
        message = "Email or password is incorrect";
      } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
        message = "Email already exists";
      }

      _isLoading = false;
      notifyListeners();
      return {"hasError": hasError, "message": message, "userType": userType};
    } catch (error) {
      hasError = true;
      message = authMode == AuthMode.SignUp
          ? "Failed to sign up successfully"
          : "Failed to log in successfully";
      _isLoading = false;
      notifyListeners();
      return {"hasError": hasError, "message": message};
    }
  }

  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https:projectapp-bb1cf.firebaseio.com/storeImage'));
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(
        mimeTypeData[0],
        mimeTypeData[1],
      ),
    );
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    imageUploadRequest.headers['Authorization'] =
        'Bearer ${_authenticatedUser.token}';

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      return null;
    }
  }

  Future<bool> uploadProfileImage(File profileImage) async {
    UserInfo theUserInfo = getUserDetails(_authenticatedUser.id);
    Map<String, dynamic> personalData = {};
    personalData['userType'] = theUserInfo.userType;
    personalData['userId'] = _authenticatedUser.id;
    personalData['mobileNumber'] = theUserInfo.mobileNumber;
    personalData['firstName'] = theUserInfo.firstName;
    personalData['lastName'] = theUserInfo.lastName;
    personalData['email'] = theUserInfo.email;
    personalData['address'] = theUserInfo.address;
    personalData['createdDate'] = theUserInfo.createdDate;
    personalData['updatedDate'] = theUserInfo.updatedDate;

    String imagePath, imageUrl = "";
    if (profileImage != null) {
      final uploadData = await uploadImage(profileImage);
      if (uploadData == null) {
        return false;
      }
      imagePath = uploadData['imagePath'];
      imageUrl = uploadData['imageUrl'];

      personalData['imageUrl'] = imageUrl;
      personalData['imagePath'] = imagePath;
    }

    try {
      updatePersonalDetails(personalData, theUserInfo.id, uploadImage: true);
      return Future.value(true);
    } catch (error) {
      return Future.value(false);
    }
  }

  Future<bool> addUserInfo(Map<String, dynamic> userInfo) async {
    try {
      final http.Response response = await http.post(
          "https://projectapp-bb1cf.firebaseio.com/userInfo.json?auth=${_authenticatedUser.token}",
          body: json.encode(userInfo));

      final Map<String, dynamic> responseData = json.decode(response.body);

      UserInfo _newUserInfo = UserInfo(
        id: responseData['name'],
        userId: userInfo['userId'],
        mobileNumber: userInfo['mobileNumber'],
        firstName: userInfo['firstName'],
        email: userInfo['email'],
        lastName: userInfo['lastName'],
        userType: userInfo['userType'],
      );

      _usersInfo.add(_newUserInfo);
      return Future.value(true);
    } catch (error) {
      return Future.value(false);
    }
  }

  Future<bool> fetchUsersInfo() async {
    try {
      final http.Response response = await http.get(
          "https://projectapp-bb1cf.firebaseio.com/userInfo.json?auth=${_authenticatedUser.token}");
      final Map<String, dynamic> responseData = json.decode(response.body);
      List<UserInfo> _fetchedUsersInfo = [];
      responseData.forEach((String id, dynamic data) {
        final UserInfo userInfo = UserInfo(
          id: id,
          firstName: data['firstName'],
          lastName: data['lastName'],
          mobileNumber: data['mobileNumber'],
          email: data['email'],
          imageUrl: data['imageUrl'],
          imagePath: data['imagePath'],
          userId: data['userId'],
          userType: data['userType'],
        );
        _fetchedUsersInfo.add(userInfo);
      });
      _usersInfo = _fetchedUsersInfo;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      return Future.value(false);
    }
  }

  Future<UserInfo> getUserInfo(String userId) async {
    final bool response = await fetchUsersInfo();
    UserInfo foundUserInfo;
    if (response) {
      for (int i = 0; i < _usersInfo.length; i++) {
        if (_usersInfo[i].userId == userId) {
          foundUserInfo = _usersInfo[i];
          break;
        }
      }
    }
    return Future.value(foundUserInfo);
  }

  UserInfo getUserDetails(String userId) {
    fetchUsersInfo();
    UserInfo foundUserInfo;

    for (int i = 0; i < _usersInfo.length; i++) {
      if (_usersInfo[i].userId == userId) {
        foundUserInfo = _usersInfo[i];
        break;
      }
    }
    return foundUserInfo;
  }

  List<UserInfo> getCustomersUserInfo() {
    return _usersInfo
        .where((UserInfo userInfo) => userInfo.userType == "customer")
        .toList();
  }

  List<UserInfo> getStaffUserInfo() {
    return _usersInfo
        .where((UserInfo userInfo) => userInfo.userType != "customer")
        .toList();
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString("expiryTime");
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      final String firstName = prefs.getString('firstName');
      final String lastName = prefs.getString('lastName');
      final String mobileNumber = prefs.getString('mobileNumber');
      final String userType = prefs.getString('userType');
      final int tokenLifeSpan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser = User(
        id: userId,
        email: userEmail,
        token: token,
      );
      _authenticatedUserInfo = UserInfo(
        firstName: firstName,
        lastName: lastName,
        mobileNumber: mobileNumber,
        userType: userType,
        userId: userId,
      );
      _userSubject.add(true);
      setAuthTimeout(tokenLifeSpan);
      notifyListeners();
    }
  }

  Future<bool> updatePersonalDetails(
      Map<String, dynamic> personalData, String userInfoId,
      {bool uploadImage = false}) async {
    _isLoading = true;
    notifyListeners();
    UserInfo theUserInfo = getUserDetails(_authenticatedUser.id);
    // get the userinfo index
    int index = _usersInfo.indexOf(theUserInfo);

    if (!uploadImage) {
      personalData['userType'] = theUserInfo.userType;
      personalData['userId'] = _authenticatedUser.id;
      personalData['address'] = theUserInfo.address;
      personalData['imageUrl'] = theUserInfo.imageUrl;
      personalData['imagePath'] = theUserInfo.imagePath;
      personalData['createdDate'] = theUserInfo.createdDate;
      personalData['updatedDate'] = theUserInfo.updatedDate;
    }

    try {
      await http.put(
          "https://projectapp-bb1cf.firebaseio.com/userInfo/${userInfoId}.json?auth=${_authenticatedUser.token}",
          body: json.encode(personalData));
      UserInfo updatedUserInfo;
      if (uploadImage) {
        updatedUserInfo = UserInfo(
          id: userInfoId,
          firstName: personalData['firstName'],
          lastName: personalData['lastName'],
          email: personalData['email'],
          mobileNumber: personalData['mobileNumber'],
          userId: _authenticatedUser.id,
          userType: theUserInfo.userType,
          address: theUserInfo.address,
          createdDate: theUserInfo.createdDate,
          updatedDate: theUserInfo.updatedDate,
          imagePath: theUserInfo.imagePath,
          imageUrl: theUserInfo.imageUrl,
        );
      } else if (uploadImage) {
        updatedUserInfo = UserInfo(
          id: userInfoId,
          firstName: personalData['firstName'],
          lastName: personalData['lastName'],
          email: personalData['email'],
          mobileNumber: personalData['mobileNumber'],
          userId: _authenticatedUser.id,
          userType: personalData['userType'],
          address: personalData['address'],
          createdDate: personalData['createdData'],
          updatedDate: personalData['updatedData'],
          imagePath: personalData['imagePath'],
          imageUrl: personalData['imageUrl'],
        );
      }

      _usersInfo[index] = updatedUserInfo;
      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<bool> changePassword(String theNewPassword) async {
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> changePasswordData = {
      "idToken": _authenticatedUser.token,
      "password": theNewPassword,
      "returnSecureToken": true,
    };

    try {
      final http.Response response = await http.post(
          "https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyANwOjBpnxM1sACGdcPSWeWcqraaVY8VPA",
          body: json.encode(changePasswordData));

      Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey("idToken")) {
        _authenticatedUser = User(
          email: responseData['email'],
          id: responseData['localId'],
          token: responseData['idToken'],
        );

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        setAuthTimeout(int.parse(responseData["expiresIn"]));
        _userSubject.add(true);
        final DateTime now = DateTime.now();
        final DateTime expiryTime =
            now.add(Duration(seconds: int.parse(responseData["expiresIn"])));
        prefs.setString('token', responseData['idToken']);
        prefs.setString('userEmail', responseData['email']);
        prefs.setString('userId', responseData['localId']);
        prefs.setString('expiryTime', expiryTime.toIso8601String());
      }

      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  void logout() async {
    _authenticatedUser = null;
    _authtimer.cancel();
    _userSubject.add(false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userEmail");
    prefs.remove("userId");
    prefs.remove("token");
    prefs.remove("mobileNumber");
    prefs.remove("firstName");
    prefs.remove("lastName");
    prefs.remove("userType");
    _userSubject.add(false);
  }

  void setAuthTimeout(int time) {
    _authtimer = Timer(Duration(seconds: time), logout);
  }
}

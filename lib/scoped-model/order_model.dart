import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;
import 'package:wetreats/models/item.dart';
import 'package:wetreats/models/order.dart';
import 'package:wetreats/models/order_items.dart';
import 'package:wetreats/scoped-model/connected_scoped_model.dart';

class OrderModel extends UserModel with ItemsModel {
  bool _isOrderLoading = false;

  var dateFormat = DateFormat('y-MM-dd');
  var timeFormat = DateFormat.Hm();

  String _result = "0";
  int _orderItemQuantity = 1;
  double _totalItemPrice = 0.0;
  double _subTotal = 0.0;
  double _discount = 0.0;
  double _tax = 0.0;
  double _totalPrice = 0.0;

  List<OrderItem> _orderItems = [];
  List<OrderItem> _allOrderItems = [];
  List<Order> _orders = [];

  bool get isOrderLoading {
    return _isOrderLoading;
  }

  String get result {
    return _result;
  }

  int get orderItemQuantity {
    return _orderItemQuantity;
  }

  double get totalItemPrice {
    return _totalItemPrice;
  }

  List<OrderItem> get orderItems {
    return _orderItems;
  }

  List<OrderItem> get allOrderItems {
    return _allOrderItems;
  }

  List<Order> get orders {
    return _orders;
  }

  double get subTotal {
    return _subTotal;
  }

  double get discount {
    return _discount;
  }

  double get tax {
    return _tax;
  }

  double get totalPrice {
    return _totalPrice;
  }

  Order getOrderById(String orderId) {
    Order theOrder;
    for (int i = 0; i < _orders.length; i++) {
      if (_orders[i].id == orderId) {
        theOrder = _orders[i];
        break;
      }
    }
    return theOrder;
  }

  void set setResult(String theResult) {
    _result = theResult;
    notifyListeners();
  }

  void resetItemValues(String itemId) {
    Item item = getItemById(itemId);
    _orderItemQuantity = 1;
    _totalItemPrice = item.price;
    notifyListeners();
  }

  void resetValues() {
    _totalPrice = 0.0;
    _subTotal = 0.0;
    _discount = 0.0;
    _tax = 0.0;
    notifyListeners();
  }

  void changeChargeResult() {
    double finalResult = double.parse(_result) + _totalItemPrice;
    _result = finalResult.toStringAsFixed(2);
    notifyListeners();
  }

  void increaseQuantityByOne(String itemId) {
    Item item = getItemById(itemId);
    if (_orderItemQuantity < item.quantity) {
      _orderItemQuantity += 1;
      _totalItemPrice = item.price * _orderItemQuantity;
    }
    notifyListeners();
  }

  void decreaseQuantityByOne(String itemId) {
    Item item = getItemById(itemId);
    if (_orderItemQuantity > 1) {
      _orderItemQuantity -= 1;
      _totalItemPrice = item.price * _orderItemQuantity;
    }
    notifyListeners();
  }

  void increaseOrderItemQuantityByOne(String itemId) {
    Item item = getItemById(itemId);
    OrderItem orderItem = getOrderItem(itemId);
    int index = _orderItems.indexOf(orderItem);
    if (orderItem.quantity < item.quantity) {
      OrderItem changedOrderItem = OrderItem(
        itemId: itemId,
        quantity: orderItem.quantity + 1,
        price: orderItem.price + item.price,
      );
      _orderItems[index] = changedOrderItem;
      _subTotal += item.price;
      _totalPrice += item.price;
    }
    notifyListeners();
  }

  void decreaseOrderItemQuantityByOne(String itemId) {
    Item item = getItemById(itemId);
    OrderItem orderItem = getOrderItem(itemId);
    int index = _orderItems.indexOf(orderItem);
    if (orderItem.quantity > 1) {
      OrderItem changedOrderItem = OrderItem(
        itemId: itemId,
        quantity: orderItem.quantity - 1,
        price: orderItem.price - item.price,
      );
      _orderItems[index] = changedOrderItem;
      _subTotal -= item.price;
      _totalPrice -= item.price;
    }
    notifyListeners();
  }

  void addOrderItem(String itemId) {
    if (itemHasOrder(itemId)) {
      OrderItem foundOrderItem = getOrderItem(itemId);
      int orderItemIndex = _orderItems.indexOf(foundOrderItem);
      OrderItem modifiedItem = OrderItem(
        itemId: foundOrderItem.itemId,
        price: foundOrderItem.price + totalItemPrice,
        quantity: foundOrderItem.quantity + _orderItemQuantity,
      );
      _orderItems[orderItemIndex] = modifiedItem;
      _subTotal += _totalItemPrice;
    } else if (!itemHasOrder(itemId)) {
      OrderItem newOrderItem = OrderItem(
        itemId: itemId,
        quantity: _orderItemQuantity,
        price: _totalItemPrice,
      );
      _orderItems.add(newOrderItem);
      _subTotal += _totalItemPrice;
      _discount += getItemById(itemId).discount;
      _tax += getItemById(itemId).vat;
    }

    _totalPrice = (_subTotal + _tax) - _discount;
  }

  bool itemHasOrder(String itemId) {
    bool _isItemFound = false;
    for (int i = 0; i < _orderItems.length; i++) {
      if (_orderItems[i].itemId == itemId) {
        _isItemFound = true;
        break;
      }
    }
    return _isItemFound;
  }

  OrderItem getOrderItem(String itemId) {
    OrderItem foundOrderitem;
    for (int i = 0; i < _orderItems.length; i++) {
      if (_orderItems[i].itemId == itemId) {
        foundOrderitem = _orderItems[i];
        break;
      }
    }
    return foundOrderitem;
  }

  void removeOrderItem(String itemId) {
    _subTotal -= getOrderItem(itemId).price;
    _discount -= getItemById(itemId).discount;
    _tax -= getItemById(itemId).vat;
    _totalPrice -= getOrderItem(itemId).price;
    _totalPrice += getItemById(itemId).discount;
    _totalPrice -= getItemById(itemId).vat;
    _orderItems
        .removeWhere((OrderItem orderItem) => orderItem.itemId == itemId);
    notifyListeners();
  }

  Future<bool> addOrderToDatabase() async {
    // first create the order objec

    // generating a random string for the order code
    final String orderCode = randomNumeric(4);

    Map<String, dynamic> orderData = {
      "orderCode": orderCode,
      "orderDate": dateFormat.format(DateTime.now()),
      "orderTime": timeFormat.format(DateTime.now()),
      "status": 0,
      "customerId": "tyhwon23o1n09u",
      "staffId": "YwnPwonszjiwools",
      "userId": user.id,
    };

    try {
      final http.Response response = await http.post(
          "https://projectapp-bb1cf.firebaseio.com/orders.json?auth=${user.token}",
          body: json.encode(orderData));

      final Map<String, dynamic> responseData = json.decode(response.body);

      Order order = Order(
        id: responseData['name'],
        orderCode: orderCode,
        orderDate: dateFormat.format(DateTime.now()),
        orderTime: timeFormat.format(DateTime.now()),
        status: 0,
        customerId: "tyhwon23o1n09u",
        staffId: "YwnPwonszjiwools",
        userId: user.id,
      );

      _orderItems.forEach(
        (OrderItem orderItem) async {
          // push each order item into the fireabase dtabase
          Map<String, dynamic> orderItemData = {
            "orderId": responseData['name'],
            "orderCode": orderCode,
            "itemId": orderItem.itemId,
            "quantity": orderItem.quantity,
            "price": orderItem.price,
            "userId": user.id,
          };

          final http.Response orderItemResponse = await http.post(
            "https://projectapp-bb1cf.firebaseio.com/orderItems.json?auth=${user.token}",
            body: json.encode(orderItemData),
          );

          final Map<String, dynamic> orderItemResponseData =
              json.decode(orderItemResponse.body);

          OrderItem orderItemWithID = OrderItem(
            id: orderItemResponseData['name'],
            orderId: responseData['name'],
            orderCode: orderCode,
            itemId: orderItem.itemId,
            price: orderItem.price,
            quantity: orderItem.quantity,
            userId: user.id,
          );

          // push all the orderItems into the allOrderItems list
          _allOrderItems.add(orderItemWithID);
        },
      );

      _orders.add(order);
      _isOrderLoading = false;
      _orderItems = [];
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      print("The error: $error");
      _isOrderLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<bool> fetchOrders() async {
    _isOrderLoading = true;
    notifyListeners();

    try {
      final http.Response response = await http.get(
          "https://projectapp-bb1cf.firebaseio.com/orders.json?auth=${user.token}");

      final Map<String, dynamic> responseData = json.decode(response.body);

      final List<Order> fetchedOrders = [];

      responseData.forEach(
        (String id, dynamic data) {
          Order fetchedOrder = Order(
            id: id,
            customerId: data['customerId'],
            staffId: data['staffId'],
            orderCode: data['orderCode'],
            orderDate: data['orderDate'],
            orderTime: data['orderTime'],
            status: data['status'],
            userId: data['userId'],
          );

          fetchedOrders.add(fetchedOrder);
        },
      );

      _orders = fetchedOrders
          .where((Order order) => order.userId == user.id)
          .toList();
      _isOrderLoading = false;
      return Future.value(true);
    } catch (error) {
      _isOrderLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<bool> fetchOrderDetails() async {
    _isOrderLoading = true;
    notifyListeners();

    try {
      final http.Response response = await http.get(
          "https://projectapp-bb1cf.firebaseio.com/orderItems.json?auth=${user.token}");

      final Map<String, dynamic> responseData = json.decode(response.body);

      final List<OrderItem> fetchedOrderItems = [];

      responseData.forEach(
        (String id, dynamic data) {
          OrderItem fetchedOrderItem = OrderItem(
            id: id,
            itemId: data['itemId'],
            orderCode: data['orderCode'],
            orderId: data['orderId'],
            price: data['price'],
            quantity: data['quantity'],
            userId: data['userId'],
          );

          fetchedOrderItems.add(fetchedOrderItem);
        },
      );

      _allOrderItems = fetchedOrderItems
          .where((OrderItem orderItem) => orderItem.userId == user.id)
          .toList();
      _isOrderLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      _isOrderLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  List<OrderItem> getOrderItemsByOrderId(String orderId) => _allOrderItems
      .where((OrderItem orderItem) => orderItem.orderId == orderId)
      .toList();

  Future<bool> changeOrderStatus(String orderId, int statusCode) async {
    _isOrderLoading = true;
    notifyListeners();

    try {
      await http.put(
          "https://projectapp-bb1cf.firebaseio.com/orders/${orderId}/status.json?auth=${user.token}",
          body: json.encode(statusCode));

      Order theOrder = getOrderById(orderId);
      Order updatedOrder = Order(
        id: theOrder.id,
        customerId: theOrder.customerId,
        orderCode: theOrder.orderCode,
        orderDate: theOrder.orderDate,
        orderTime: theOrder.orderTime,
        staffId: theOrder.staffId,
        status: statusCode,
        userId: theOrder.userId,
      );

      _orders[_orders.indexOf(theOrder)] = updatedOrder;
      // notifyListeners();
      _isOrderLoading = false;
      notifyListeners();
      print("The updated order status: ${updatedOrder.status}");
      return Future.value(true);
    } catch (error) {
      print("The error occuring: $error");
      _isOrderLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }
}

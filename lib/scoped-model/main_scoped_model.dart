
import 'package:scoped_model/scoped_model.dart';
import 'category_scoped_model.dart';
import 'connected_scoped_model.dart';
import 'order_model.dart';
import 'shipping_address_scoped_model.dart';
import 'store_scoped_model.dart';

class MainModel extends Model
    with
        ConnectedModel,
        ItemsModel,
        UserModel,
        CategoryModel,
        StoreModel,
        OrderModel, ShippingAddressModel {
  bool _isFetchingAllInfos = false;

  bool get isFetchingAllInfos {
    return _isFetchingAllInfos;
  }

  Future<bool> fetchAllInfos() {
    _isFetchingAllInfos = true;
    notifyListeners();

    try {
      fetchUsersInfo();
      fetchItems();
      fetchCategories();
      fetchStores();
      fetchShippingAddresses();

      _isFetchingAllInfos = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      _isFetchingAllInfos = false;
      notifyListeners();
      return Future.value(false);
    }
  }
}

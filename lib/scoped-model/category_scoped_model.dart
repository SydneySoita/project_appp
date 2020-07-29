import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:wetreats/models/category.dart';
import 'package:wetreats/models/item.dart';
import 'package:wetreats/scoped-model/connected_scoped_model.dart';

class CategoryModel extends UserModel with ItemsModel {
  List<Category> _categories = [];
  int _selectedCategoryIndex;
  bool _isCatLoading = false;

  List<Category> get categories {
    return List.from(_categories);
  }

  int get categorySize{
    return _categories.length;
  }

  List<Category> get firstFiveCategories {
    if (_categories.length > 3) {
      return _categories.getRange(0, 3).toList();
    }
    return _categories;
  }

  int get selectedCategoryIndex {
    return selectedCategoryIndex;
  }

  Future<bool> fetchCategories() async {
    _isCatLoading = true;
    notifyListeners();

    try {
      final http.Response response = await http.get(
          "https://projectapp-bb1cf.firebaseio.com/categories.json?auth=${user.token}");

      final List<Category> fetchedCategories = [];
      final Map<String, dynamic> responseData = json.decode(response.body);

      responseData.forEach((String categoryId, dynamic categoryData) {
        Category newCategory = Category(
          id: categoryId,
          userId: categoryData['userId'],
          name: categoryData["name"],
        );
        fetchedCategories.add(newCategory);
      });
      _categories = fetchedCategories;
      _isCatLoading = false;
      notifyListeners();
    } catch (error) {
      _isCatLoading = false;
      notifyListeners();
      return false;
    }
    return true;
  }

  Future<bool> addCategory(Map<String, dynamic> categoryData) async {
    _isCatLoading = true;
    notifyListeners();
    try {
      categoryData['userId'] = user.id;

      // you can use your api here or firebase api here in the code
      final http.Response response = await http.post(
          "https://projectapp-bb1cf.firebaseio.com/categories.json?auth=${user.token}",
          body: json.encode(categoryData));

      final Map<String, dynamic> responseData = json.decode(response.body);

      Category newCategory = Category(
        id: responseData["name"],
        name: categoryData['name'],
        userId: user.id,
      );

      _categories.add(newCategory);
      _isCatLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      _isCatLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  bool get isCatLoading {
    return _isCatLoading;
  }

  Future<bool> deleteCategory(String categoryId) async {
    _isCatLoading = true;
    notifyListeners();

    try {
      await http.delete(
          "https://projectapp-bb1cf.firebaseio.com/categories/${categoryId}.json?auth=${user.token}");

      _categories
          .removeWhere((Category category) => category.id == categoryId);

      _isCatLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      print("The error: $error");
      _isCatLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  bool categoryAlreadyExist(Category category) {
    bool _alreadyExist = false;
    _categories.forEach((Category cat) {
      if (cat.name.toLowerCase() == category.name.toLowerCase()) {
        _alreadyExist = true;
      }
    });
    return _alreadyExist;
  }

  Category get selectedCategory {
    if (_selectedCategoryIndex == null) {
      return null;
    }
    return _categories[_selectedCategoryIndex];
  }

  String getCategoryNameById(String id){
    String name;
    for(int i = 0; i < _categories.length; i++){
      if(_categories[i].id == id){
        name = _categories[i].name;
        break;
      }
    }
    return name;
  }

  void setSelectedCategoryIndex(int index) {
    _selectedCategoryIndex = index;
  }
}

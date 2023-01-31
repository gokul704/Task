import 'dart:convert';

import 'package:example/models/products/products.model.dart';
import 'package:example/utils/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/sharedprefhelper.dart';

class CartProvider with ChangeNotifier {
  List<ProductsModel> lst = <ProductsModel>[];
  SharedPreferences? sharedPreferences;

  add(ProductsModel data) {
    lst.add(data);
    saveDataToLocalStorage();

    notifyListeners();
  }

  del(int index) {
    lst.removeAt(index);
    updateDataToLocalStorage();

    notifyListeners();
  }

  void initSharedPreferences() async {
    await SharedPreferencesHelper.init();
    sharedPreferences = SharedPreferencesHelper.instance;
    loadDataFromLocalStorage();
    notifyListeners();
  }

  void saveDataToLocalStorage() {
    List<String>? spList =
        lst.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences!.setStringList('list', spList);
  }

  void loadDataFromLocalStorage() {
    List<String>? spList = sharedPreferences!.getStringList('list');
    if (spList != null) {
      lst = spList
          .map((item) => ProductsModel.fromMap(json.decode(item)))
          .toList();
    }
  }

  void updateDataToLocalStorage() {
    sharedPreferences!.remove('list');
    saveDataToLocalStorage();
  }
}

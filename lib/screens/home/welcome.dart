import 'dart:async';
import 'dart:convert';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:example/models/products/products.model.dart';
import 'package:example/providers/cartprovider.dart';
import 'package:example/screens/cart/cartscreen.dart';
import 'package:example/screens/navbar/navbar.dart';
import 'package:example/utils/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/cartcounter.dart';
import '../../widgets/productstile.dart';
import '../products/productdetails.dart';
import 'dart:math' as math;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class ItemModel {
  String label;
  Color color;
  bool isSelected;

  ItemModel(this.label, this.color, this.isSelected);
}

class _DashboardState extends State<Dashboard> {
  List<String> items = [];
  List<ProductsModel> globalData = [];
  List<ProductsModel> filterData = [];

  Future<List<ProductsModel>> getData() async {
    http.Response response =
        await http.get(Uri.parse('https://fakestoreapi.com/products/'));
    if (response.statusCode == 200) {
      final List parsedList = json.decode(response.body);
      List<ProductsModel> myList =
          parsedList.map((val) => ProductsModel.fromJson(val)).toList();
      globalData = myList;
      filterData = myList;
      setState(() {});
      return myList;
    } else {
      return [];
    }
  }

  List<String> Categories = [];
  final List<ItemModel> _chipsList = [];
  final List<ItemModel> selectedChips = [];
  SharedPreferences? pref;
  bool? isLoggedIn = false;

  Future<List<dynamic>> getCategories() async {
    http.Response response = await http
        .get(Uri.parse('https://fakestoreapi.com/products/categories'));
    if (response.statusCode == 200) {
      List<dynamic> myList = jsonDecode(response.body);
      print(myList);
      for (var data in myList) {
        Categories.add(data);
      }
      for (var catData in Categories) {
        _chipsList.add(ItemModel(
            catData,
            Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0),
            false));
      }
      print(_chipsList);
      setState(() {});
      return myList;
    } else {
      return [];
    }
  }

  void initPreferences() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      // isLoggedIn = pref.getBool("isLogin");
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    getCategories();
    initPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => {
                    showSearch(
                        context: context, delegate: CustomsearchDelegate())
                  },
              icon: const Icon(Icons.search)),
          InkWell(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              )
            },
            child: Align(
                alignment: Alignment.center,
                child: Icon(Icons.shopping_cart_rounded,
                    color: Colors.white, size: 25)),
          ),
          Consumer<CartProvider>(
            builder: (context, value, child) => CartCounter(
              count: value.lst.length.toString(),
            ),
          ),
        ],
        // title: Row(mainAxisSize: MainAxisSize.max, children: [
        //   Expanded(
        //     child: Container(
        //       height: 45,
        //       color: Colors.white,
        //       child: TextFormField(
        //         controller: textController,
        //         obscureText: false,
        //         onChanged: (model) => {},
        //         decoration: const InputDecoration(
        //           hintTextDirection: TextDirection.ltr,
        //           hintText: "Search",
        //           enabledBorder: OutlineInputBorder(
        //             borderSide: BorderSide(width: 3, color: Colors.white),
        //           ),
        //           focusedBorder: OutlineInputBorder(
        //             borderSide: BorderSide(width: 3, color: Colors.white),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Icon(Icons.shopping_cart),
        //   )
        // ])
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 9,
                runSpacing: 12,
                direction: Axis.horizontal,
                children: filterChipsList(),
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height - 20,
                child: GridView.builder(
                  itemCount: filterData.length,
                  itemBuilder: (context, index) => ProductTile(
                    itemNo: index,
                    product: filterData[index],
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                  ),
                ))
          ]),
        ),
      ),
    );
  }

  List<Widget> filterChipsList() {
    List<Widget> chips = [];
    for (int i = 0; i < _chipsList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: FilterChip(
          label: Text(_chipsList[i].label),
          labelStyle: const TextStyle(color: Colors.white, fontSize: 16),
          backgroundColor: _chipsList[i].color,
          selected: _chipsList[i].isSelected,
          onSelected: (bool value) {
            setState(() {
              _chipsList[i].isSelected = value;
              if (_chipsList[i].isSelected == true) {
                selectedChips.add(_chipsList[i]);
              }
              if (_chipsList[i].isSelected == false) {
                selectedChips.removeWhere(
                    (element) => element.label == _chipsList[i].label);
              }
              print(_chipsList[i]);
            });

            filterData = [];
            if (selectedChips.length < 1) {
              filterData = globalData;
            } else {
              for (var data in selectedChips) {
                for (var gdata in globalData) {
                  if (gdata.category == data.label) {
                    filterData.add(gdata);
                  }
                }
              }
            }
            print(selectedChips);
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }
}

class CustomsearchDelegate extends SearchDelegate {
  List<ProductsModel> items = [];

  Future<List<ProductsModel>> getData() async {
    http.Response response =
        await http.get(Uri.parse('https://fakestoreapi.com/products/'));
    if (response.statusCode == 200) {
      // Future<List<ProductsModel>> myList = jsonDecode(response.body);
      final List parsedList = json.decode(response.body);
      List<ProductsModel> list =
          parsedList.map((val) => ProductsModel.fromJson(val)).toList();
      items = list;
      return list;
    } else {
      return [];
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    getData();
    return [
      IconButton(onPressed: () => {query = ''}, icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => {close(context, null)},
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<ProductsModel> matchQuery = [];
    for (var data in items) {
      if (data.title!.contains(query)) {
        matchQuery.add(data);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(matchQuery[index].title.toString()),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    List<ProductsModel> matchQuery = [];
    for (var data in items) {
      if (data.title!.contains(query)) {
        matchQuery.add(data);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailWidget(product: matchQuery[index]),
                ),
              )
            },
            child: ListTile(
              title: Text(
                matchQuery[index].title.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle:
                  Text("in" + " " + matchQuery[index].category.toString()),
            ),
          );
        });
  }
}

import 'package:example/providers/cartprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../items/cartitem.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<CartProvider>(context, listen: false).initSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Consumer<CartProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text("Cart Screen"),
        ),
        body: SafeArea(
          child: Container(
            height: screenSize.height,
            width: double.infinity,
            child: Consumer<CartProvider>(builder: (context, state, child) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: value.lst.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.horizontal,
                          background: Container(
                            color: Colors.red,
                          ),
                          onDismissed: (direction) {
                            value.del(index);
                          },
                          child: CartItem(
                            screenSize: screenSize,
                            image: state.lst[index].image!,
                            itemName: state.lst[index].title.toString(),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {},
                      child: Container(
                        color: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: const Text(
                          'Proceed To Checkout',
                          style: TextStyle(color: Colors.white, fontSize: 13.0),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

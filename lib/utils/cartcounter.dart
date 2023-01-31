import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cartprovider.dart';

class CartCounter extends StatelessWidget {
  const CartCounter({
    Key? key,
    required this.count,
  }) : super(key: key);

  final String count;
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<CartProvider>(context, listen: false)
        .initSharedPreferences();

    return Container(
        height: 12,
        width: 12,
        decoration:
            BoxDecoration(color: Colors.red[800], shape: BoxShape.circle),
        child: Center(
            child: Text(
          Provider.of<CartProvider>(context, listen: false)
                  .lst
                  .length
                  .toString() ??
              "0",
          style: TextStyle(color: Colors.white, fontSize: 7),
        )));
  }
}

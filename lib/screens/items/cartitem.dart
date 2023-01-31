import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cartprovider.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    required this.screenSize,
    required this.image,
    required this.itemName,
  }) : super(key: key);

  final Size screenSize;
  final String image, itemName;

  @override
  Widget build(BuildContext context) {
    Provider.of<CartProvider>(context, listen: false).initSharedPreferences();

    return Container(
      margin: EdgeInsets.all(10),
      height: screenSize.height * 0.15,
      width: screenSize.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.blue[200]!.withOpacity(0.3),
                offset: Offset(0, 0),
                blurRadius: 3,
                spreadRadius: 3)
          ]),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(image)),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: 200,
            child: AutoSizeText(
              itemName ?? "Item",
              maxLines: 3,
              style: TextStyle(fontSize: 22),
            ),
          ),
        ),
      ]),
    );
  }
}

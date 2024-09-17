import 'package:ebasket_customer/utils/dimensions.dart';
import 'package:flutter/material.dart';


class CustomShimmerTextHolder extends StatelessWidget {
  final double? horizontalPadding;
  final double? height;
  final double? width;
  const CustomShimmerTextHolder({super.key,  this.horizontalPadding, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 200,
      margin:  EdgeInsets.symmetric(horizontal: horizontalPadding ??  Dimensions.paddingSize65),
      height:height?? 8,
      decoration:  BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Dimensions.radius5),
      ),
    );
  }
}

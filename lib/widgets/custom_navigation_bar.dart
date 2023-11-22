import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'Texts/big_text.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.bottomheight,
      padding: EdgeInsets.all(
        Dimensions.height30,
      ),
      decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimensions.height20 * 2),
              topRight: Radius.circular(Dimensions.height20 * 2))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          padding: EdgeInsets.all(Dimensions.height15),
          decoration: BoxDecoration(
            color: ColorRes.whiteSmoke,
            borderRadius: BorderRadius.circular(Dimensions.height20),
          ),
          child: Row(children: [
            Icon(
              Icons.remove,
              color: ColorRes.black,
            ),
            SizedBox(
              width: Dimensions.height10 / 2,
            ),
            BigText(
              text: "0",
            ),
            SizedBox(
              width: Dimensions.height10 / 2,
            ),
            Icon(
              Icons.add,
              color: ColorRes.black,
            )
          ]),
        ),
        Container(
          padding: EdgeInsets.all(Dimensions.height15),
          decoration: BoxDecoration(
            color: ColorRes.app,
            borderRadius: BorderRadius.circular(Dimensions.height20),
          ),
          child: BigText(
            text: '\$10 | Add to cart ',
            color: Colors.white,
          ),
        )
      ]),
    );
  }
}

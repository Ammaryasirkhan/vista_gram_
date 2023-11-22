import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'Texts/big_text.dart';
import 'Texts/small_text.dart';
import 'icon_and_text.dart';

class FoodColumnWidget extends StatelessWidget {
  final String text;

  const FoodColumnWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      BigText(
        text: text,
        size: Dimensions.text20,
      ),
      SizedBox(
        height: Dimensions.height10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Wrap(
            children: List.generate(
                5,
                (index) => Icon(
                      Icons.star,
                      color: ColorRes.app,
                      size: Dimensions.height15,
                    )),
          ),
          SizedBox(
            width: Dimensions.width20,
          ),
          SmallText(
            text: "4.85",
            size: Dimensions.text20,
          ),
          SizedBox(
            width: Dimensions.width20,
          ),
          SmallText(
            text: "1287",
            size: Dimensions.text20,
          ),
          SizedBox(
            width: Dimensions.width20,
          ),
          SmallText(
            text: "comments",
            size: Dimensions.text20,
          )
        ],
      ),
      SizedBox(
        height: Dimensions.height20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconAndTextWidget(
            icon: Icons.circle,
            text: 'Normal',
            iconColor: ColorRes.bittersweet,
          ),
          SizedBox(width: Dimensions.width5),
          IconAndTextWidget(
            icon: Icons.location_on,
            text: '17km',
            iconColor: ColorRes.ferrariRed,
          ),
          SizedBox(width: Dimensions.width5),
          IconAndTextWidget(
            icon: Icons.access_time,
            text: '23 min',
            iconColor: ColorRes.black,
          )
        ],
      )
    ]);
  }
}

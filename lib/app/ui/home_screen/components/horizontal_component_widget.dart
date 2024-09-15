// import 'package:ebasket_customer/app/ui/home_screen/components/horizontal_product_list_component.dart';
// import 'package:ebasket_customer/utils/sizeboxes.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:ebasket_customer/app/ui/search_screen/search_screen.dart';
// import 'package:ebasket_customer/services/localDatabase.dart';
// import 'package:ebasket_customer/widgets/all_product_list.dart';
// import 'package:get/get.dart';
// import 'package:ebasket_customer/app/controller/view_all_product_controller.dart';
// import 'package:ebasket_customer/app/ui/cart_screen/cart_screen.dart';
// import 'package:ebasket_customer/constant/constant.dart';
// import 'package:ebasket_customer/theme/app_theme_data.dart';
// import 'package:ebasket_customer/theme/responsive.dart';
// import 'package:ebasket_customer/widgets/common_ui.dart';
// import 'package:ebasket_customer/widgets/network_image_widget.dart';
// import 'package:ebasket_customer/widgets/round_button_fill.dart';
// import 'package:ebasket_customer/widgets/text_field_widget.dart';
//
// import '../../../model/product_model.dart';
//
// class horizontalProductWidget extends StatelessWidget {
//   final String title;
//   final ProductModel listData;
//   const horizontalProductWidget({super.key, required this.title, required this.listData});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Column(crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         sizedBox10(),
//         Text(
//           'Fresh Vegetables',
//           style: TextStyle(color: AppThemeData.black, fontSize: 18, fontFamily: AppThemeData.regular),
//         ),
//         sizedBox10(),
//         SizedBox(
//           height: Responsive.height(27, context),
//           child: GetX(
//               init: ProductListController(),
//               builder: (controller) {
//                 return ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount:
//                   controller.freshVegetablesList.length,
//                   shrinkWrap: true,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () {},
//                       child: SizedBox(
//                         width: Responsive.width(40, context), // Adjust width as per your design
//                         child: HorizontalProductListComponent(
//                           trustedBrandItem: controller.freshVegetablesList[index],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//                 // return controller.isLoading.value
//                 //     ? Constant.loader()
//                 //     : Padding(
//                 //   padding: const EdgeInsets.symmetric(horizontal: 16),
//                 //   child: Column(
//                 //     children: [
//                 //       controller.freshVegetablesList.isEmpty
//                 //           ? Expanded(
//                 //           child: Constant.emptyView(
//                 //               image: "assets/icons/no_record.png",
//                 //               text: "Empty".tr,
//                 //               description:
//                 //               "You don’t have any products at this time"))
//                 //           :
//                 //
//                 //
//                 //       Expanded(
//                 //         child: SizedBox(
//                 //           height: Responsive.height(65, context),
//                 //           child: ListView.builder(
//                 //             scrollDirection: Axis.horizontal,
//                 //             itemCount:
//                 //             controller.freshVegetablesList.length,
//                 //             shrinkWrap: true,
//                 //             itemBuilder: (context, index) {
//                 //               return InkWell(
//                 //                 onTap: () {},
//                 //                 child: SizedBox(
//                 //                   width: Responsive.width(40, context), // Adjust width as per your design
//                 //                   child: AllProductListWidget(
//                 //                     trustedBrandItem: controller
//                 //                         .freshVegetablesList[index],
//                 //                   ),
//                 //                 ),
//                 //               );
//                 //             },
//                 //           ),
//                 //         ),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // );
//               }),
//         ),
//       ],
//     );
//   }
// }

import 'package:ebasket_customer/app/ui/home_screen/components/horizontal_product_list_component.dart';
import 'package:ebasket_customer/utils/dimensions.dart';
import 'package:ebasket_customer/utils/sizeboxes.dart';
import 'package:ebasket_customer/utils/styles.dart';
import 'package:ebasket_customer/utils/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/widgets/all_product_list.dart';
import 'package:ebasket_customer/widgets/network_image_widget.dart';

class HorizontalProductWidget extends StatelessWidget {
  final String title;
  final Function() onSeeAllTap;


  final List<dynamic> items; // Replace `dynamic` with the actual type of your items
  final Function(dynamic) onItemTap; // Callback for item tap

  const HorizontalProductWidget({
    super.key,
    required this.title,
    required this.items,
    required this.onItemTap, required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedBox10(),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppThemeData.black,
                fontSize: 18,
                fontFamily: AppThemeData.regular,
              ),
            ),
            InkWell(
              onTap: onSeeAllTap,
              child: Text(
                'View All',
                style: montserratRegular.copyWith(fontSize: Dimensions.fontSize15,
                color: appColor),
              ),
            ),
          ],
        ),
        sizedBox10(),
        SizedBox(
          height: Responsive.height(30, context),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length ,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = items[index];
              return InkWell(
                onTap: () => onItemTap(item),
                child: SizedBox(
                  width: Responsive.width(40, context), // Adjust width as per your design
                  child: HorizontalProductListComponent(
                    trustedBrandItem: item,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


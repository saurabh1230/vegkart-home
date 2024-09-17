
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ebasket_customer/app/ui/home_screen/home_screen.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/utils/dimensions.dart';
import 'package:ebasket_customer/utils/sizeboxes.dart';
import 'package:ebasket_customer/widgets/custom_shimmer_holder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/custom_image_widget.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeDefault),
      child: Column(
          children: [
            sizedBox10(),
            CustomShimmerTextHolder(width: Get.size.width,height: Dimensions.fontSize15,horizontalPadding: 0,),
            sizedBox10(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today Special Offers',
                  style: TextStyle(
                    color: AppThemeData.black,
                    fontSize: 18,
                    fontFamily: AppThemeData.bold,
                  ),
                ),
                // InkWell(
                //   onTap: onSeeAllTap,
                //   child: Text(
                //     'View All',
                //     style: montserratRegular.copyWith(fontSize: Dimensions.fontSize15,
                //         color: appColor),
                //   ),
                // ),
              ],
            ),
            sizedBox10(),
            SizedBox(
              height: Responsive.height(20, context),
              child: ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 3 ,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: Responsive.width(70, context), // Adjust width as per your design
                    child:  Container(
                  padding: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.1),

                  ),
                  ),);
                }, separatorBuilder: (BuildContext context, int index) => sizedBoxW10(),
              ),
            ),
      sizedBox10(),
      Container(
                              height: Responsive.height(18, context),
                              width: Get.size.width,
                              alignment: Alignment.centerLeft,
                              child: CarouselSlider.builder(
                                itemCount: 3,
                                options: CarouselOptions(
                                  height: Responsive.height(18, context),
                                  enlargeCenterPage: true,
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 3),
                                  enableInfiniteScroll: true,
                                  viewportFraction: 0.8, // Fraction of the screen that each item takes
                                ),
                                itemBuilder: (context, index, realIndex) {
                                  return Container(
                                    padding: EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black.withOpacity(0.1),

                                    ),
                                  );
                                },
                              ),
                            ),


                            const SizedBox(
                              height: 25,
                            ),
      Padding(
                              padding:  EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Categories".tr,
                                          style: TextStyle(
                                              color:
                                                  AppThemeData.black,
                                              fontSize: 18,
                                              fontFamily: AppThemeData
                                                  .semiBold),
                                        ),
                                      ),
                                      Text(
                                        "View All".tr,
                                        style: TextStyle(
                                            color: AppThemeData
                                                .groceryAppDarkBlue,
                                            fontSize: 12,
                                            fontFamily: AppThemeData
                                                .semiBold),
                                      )
                                    ],
                                  ),



        ]
      ),
    ),
      const SizedBox(
                                    height: 15,
                                  ),
                                  // GridView.builder(
                                  //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 1),
                                  //   itemCount: controller.categoryList.length,
                                  //   physics: const NeverScrollableScrollPhysics(),
                                  //   shrinkWrap: true,
                                  //   itemBuilder: (context, index) {
                                  //     CategoryModel categoryItem = controller.categoryList[index];
                                  //     return CategoryItemWidget(
                                  //       categoryItem: categoryItem,
                                  //     );
                                  //   },
                                  // ),
                                  SizedBox(
                                    height: 120,
                                    child: ListView.separated(
                                      scrollDirection:
                                          Axis.horizontal,
                                      itemCount: 4,
                                      itemBuilder: (_, i) {
                                        return Container(
                                          width: 120,
                                          padding: EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Colors.black.withOpacity(0.1),

                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context,
                                                  int index) =>
                                              sizedBoxW10(),
                                    ),
                                  ),
                                  sizedBoxDefault(),
    ],
                                  ),);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_customer/app/controller/view_all_product_controller.dart';
import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:ebasket_customer/app/model/todays_special_model.dart';
import 'package:ebasket_customer/app/ui/delivery_address_screen/delivery_address_screen.dart';
import 'package:ebasket_customer/app/ui/home_screen/components/horizontal_component_widget.dart';
import 'package:ebasket_customer/app/ui/home_screen/components/todays_sepcial_offer_widget.dart';
import 'package:ebasket_customer/app/ui/login_screen/login_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ebasket_customer/app/ui/search_screen/search_screen.dart';
import 'package:ebasket_customer/services/helper.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:ebasket_customer/utils/dimensions.dart';
import 'package:ebasket_customer/utils/sizeboxes.dart';
import 'package:ebasket_customer/utils/styles.dart';
import 'package:ebasket_customer/utils/theme/light_theme.dart';
import 'package:ebasket_customer/widgets/custom_button_widget.dart';
import 'package:ebasket_customer/widgets/custom_drawer.dart';
import 'package:ebasket_customer/widgets/empty_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ebasket_customer/app/controller/product_details_controller.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/app/ui/product_details_screen/product_details_screen.dart';
import 'package:ebasket_customer/app/ui/view_all_brand_screen/view_all_brand_screen.dart';
import 'package:ebasket_customer/app/ui/view_all_category_product_screen/view_all_category_product_screen.dart';
import 'package:ebasket_customer/constant/collection_name.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/controller/home_controller.dart';
import 'package:ebasket_customer/app/model/category_model.dart';
import 'package:ebasket_customer/app/ui/cart_screen/cart_screen.dart';
import 'package:ebasket_customer/app/ui/notification_screen/notification_screen.dart';
import 'package:ebasket_customer/app/ui/view_all_category_screen/view_all_category_screen.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/widgets/network_image_widget.dart';
import 'package:ebasket_customer/widgets/text_field_widget.dart';
import 'package:ebasket_customer/widgets/trusted_brand_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../widgets/custom_image_widget.dart';
class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(
          Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: InkWell(
              onTap: () {
                Get.to(const ViewAllCategoryProductScreen(), arguments:
                {"categoryId": Get.find<ProductListController>().freshVegetablesList[0].categoryID.toString(),
                  "categoryName": 'Fresh Vegetables'});
              },
              child: SizedBox(
                height: 400,
                width: Get.size.width,
                child: Stack(
                  children: [
                    // Background Image
                    Image.asset(
                      'assets/images/coupon_bg.png',
                      height: 400,
                      width: Get.size.width,
                      fit: BoxFit.cover, // Ensure the image covers the entire dialog area
                    ),
                    // Text and other content on top of the image
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0), // Adjust padding for text inside the image
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // sizedBox30(),
                          Align(alignment: Alignment.centerRight,
                              child: IconButton(onPressed: () {
                                Get.back();
                              }, icon: Icon(Icons.cancel,color: Theme.of(context).cardColor,))),
                          Image.asset('assets/images/Hurry Up.png',height: 40,
                          width: 180,),
                          SizedBox(height: 10), // Use SizedBox for spacing
                          // Sub-headline Text
                          Text(
                            'Savings Are Waiting!',
                            style: montserratMedium.copyWith(
                              fontSize: Dimensions.fontSize15,
                              color: Colors.white, // Ensure text is readable on the background
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10), // Use SizedBox for spacing
                          // Offer Text
                          Text(
                            'Get 25% OFF on all fresh produce vegetables today only!',
                            style: montserratBold.copyWith(
                              fontSize: Dimensions.fontSize20,
                              color: Theme.of(context).highlightColor, // Customize color as needed
                            ),
                            textAlign: TextAlign.center,
                          ),
                      SizedBox(height: 10),
                          CustomButtonWidget(buttonText: 'Order Now',
                          onPressed: () {
                            Get.to(const ViewAllCategoryProductScreen(), arguments:
                            {"categoryId": Get.find<ProductListController>().freshVegetablesList[0].categoryID.toString(),
                              "categoryName": 'Fresh Vegetables'});
                          },
                            width: 180,
                            height: 40,
                            radius: Dimensions.radius20,
                          fontSize: Dimensions.fontSizeDefault,
                          textColor: Theme.of(context).primaryColor,
                          color: Theme.of(context).highlightColor,),

                        ],
                      ),
                    ),
                    Positioned(bottom: 0,right: 0,left: 0,
                        child: Image.asset('assets/images/coupon_product_image.png',height:140,)),
                  ],
                ),
              ),
            ),
          ),

      );
    });
  }



  @override
  Widget build(BuildContext context) {
    print('check id : --------${Constant.selectedPosition.id.toString()}');
    return GetBuilder(
        init: HomeController(),
        builder: (controller) {
          return GetBuilder(
              init: ProductListController(),
              builder: (productControl) {
                return Scaffold(
                  key: _scaffoldKey,
                  drawer: CustomDrawer(),
                  body: CustomScrollView(slivers: <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      pinned: true,
                      expandedHeight: 180.0,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: const BoxDecoration(
                            color: appColor,
                            image: DecorationImage(
                              image: AssetImage('assets/images/home_bg.png'),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault),
                            child: Column(
                              children: [
                               sizedBox40(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        _scaffoldKey.currentState?.openDrawer();
                                      },
                                      child: Image.asset(
                                        'assets/icons/ic_drawer_menu.png',
                                        height: Dimensions.paddingSize30,
                                        width: Dimensions.paddingSize30,
                                      ),
                                    ),
                                    sizedBoxW5(),
                                    Text(
                                      appName,
                                      style: montserratSemiBold.copyWith(
                                          color: Theme.of(context).cardColor,
                                          fontSize: Dimensions.fontSize24),
                                    ),
                                    if (double.parse(Constant.vendorRadius) >=
                                        double.parse(Constant.distance))
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Stack(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      if (controller.userModel
                                                              .value.id !=
                                                          null) {
                                                        Get.to(const CartScreen(),
                                                                transition: Transition
                                                                    .rightToLeftWithFade)!
                                                            .then((value) {
                                                          controller
                                                              .getUserData();
                                                          controller.update();
                                                        });
                                                      } else {
                                                        Get.to(
                                                            const LoginScreen(),
                                                            transition: Transition
                                                                .rightToLeftWithFade);
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons.shopping_cart,
                                                      color: Colors.white,
                                                    )),
                                                StreamBuilder<List<CartProduct>>(
                                                  stream: controller.cartDatabase
                                                      .value.watchProducts,
                                                  builder: (context, snapshot) {
                                                    controller.cartCount.value =
                                                        0;
                                                    if (snapshot.hasData) {
                                                      for (var element
                                                          in snapshot.data!) {
                                                        controller.cartCount
                                                                .value +=
                                                            element.quantity;
                                                      }
                                                    }
                                                    return Visibility(
                                                      visible: controller
                                                              .cartCount.value >=
                                                          1,
                                                      child: Positioned(
                                                        right: 2,
                                                        top: -1,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: AppThemeData
                                                                .groceryAppDarkBlue,
                                                          ),
                                                          constraints:
                                                              const BoxConstraints(
                                                            minWidth: 12,
                                                            minHeight: 12,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              controller.cartCount
                                                                          .value <=
                                                                      99
                                                                  ? '${controller.cartCount.value}'
                                                                  : '+99',
                                                              style:
                                                                  const TextStyle(
                                                                color:
                                                                    Colors.white,
                                                                fontSize: 12,
                                                              ),
                                                              textAlign: TextAlign
                                                                  .center,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  if (controller
                                                          .userModel.value.id !=
                                                      null) {
                                                    Get.to(
                                                        const NotificationScreen(),
                                                        transition: Transition
                                                            .rightToLeftWithFade);
                                                  } else {
                                                    Get.to(const LoginScreen(),
                                                        transition: Transition
                                                            .rightToLeftWithFade);
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.notifications_outlined,
                                                  color: Colors.white,
                                                )),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (Constant.currentUser.id != null) {
                                      await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  DeliveryAddressScreen()))
                                          .then((value) async {
                                        controller.isLoading.value = true;
                                        await controller.getUserData();

                                        controller.update();
                                      });
                                    } else {
                                      checkPermission(
                                        () async {
                                          await ShowToastDialog.showLoader(
                                              "Please Wait".tr);
                                          AddressModel addressModel =
                                              AddressModel();
                                          try {
                                            await Geolocator.requestPermission();
                                            await Geolocator.getCurrentPosition();
                                            await ShowToastDialog.closeLoader();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => PlacePicker(
                                                  apiKey: Constant.mapKey,
                                                  onPlacePicked: (result) async {
                                                    print("-========>");
                                                    print(result);
                                                    await ShowToastDialog
                                                        .closeLoader();
                                                    AddressModel addressModel =
                                                        AddressModel();
                                                    addressModel.id = Uuid().v4();
                                                    addressModel.locality = result
                                                        .formattedAddress!
                                                        .toString();
                                                    addressModel.location =
                                                        UserLocation(
                                                            latitude: result
                                                                .geometry!
                                                                .location
                                                                .lat,
                                                            longitude: result
                                                                .geometry!
                                                                .location
                                                                .lng);
                                                    controller.isLoading.value =
                                                        true;
                                                    Constant.selectedPosition =
                                                        addressModel;
                                                    controller.getUserData();
                                                    controller.update();
                                                    Get.back();
                                                  },
                                                  initialPosition: LatLng(
                                                      -33.8567844, 151.213108),
                                                  useCurrentLocation: true,
                                                  selectInitialPosition: true,
                                                  usePinPointingSearch: true,
                                                  usePlaceDetailSearch: true,
                                                  zoomGesturesEnabled: true,
                                                  zoomControlsEnabled: true,
                                                  resizeToAvoidBottomInset:
                                                      false, // only works in page mode, less flickery, remove if wrong offsets
                                                ),
                                              ),
                                            );
                                          } catch (e) {
                                            await placemarkFromCoordinates(
                                                    19.228825, 72.854118)
                                                .then((valuePlaceMaker) {
                                              Placemark placeMark =
                                                  valuePlaceMaker[0];

                                              addressModel.location =
                                                  UserLocation(
                                                      latitude: 19.228825,
                                                      longitude: 72.854118);
                                              String currentLocation =
                                                  "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";
                                              addressModel.locality =
                                                  currentLocation;
                                            });

                                            Constant.selectedPosition =
                                                addressModel;

                                            controller.getUserData();
                                            controller.update();
                                          }
                                        },
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_sharp,
                                        color: Colors.yellow,
                                      ),
                                      Expanded(
                                        child: Constant.selectedPosition.locality !=
                                                null
                                            ? Text(
                                                Constant.selectedPosition
                                                    .getFullAddress()
                                                    .toString(),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: AppThemeData.white,
                                                  fontSize: 12,
                                                  fontFamily:
                                                      AppThemeData.bold,
                                                ),
                                              )
                                            : Text(
                                                "Select Address",
                                                textAlign: TextAlign.start,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: AppThemeData.white,
                                                  fontSize: 12,
                                                  fontFamily:
                                                      AppThemeData.regular,
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize:  Size.fromHeight(
                           30.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          child: Column(children: [
                            InkWell(onTap: () {
                              // Get.toNamed(RouteHelper.getSearchRoute());
                            },
                              child:   Stack(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFieldWidget(
                                          readonly: true,
                                          onTap: () {
                                            Get.to(SearchScreen());
                                          },
                                          controller: controller
                                              .searchTextFiledController.value,
                                          hintText: "Search".tr,
                                          enable: true,
                                          onFieldSubmitted: (v) {
                                            return null;
                                          },
                                          onChanged: (value) {
                                            controller.getFilterData(value!);
                                            return null;
                                          },
                                          suffix: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: SvgPicture.asset(
                                                "assets/icons/ic_search.svg",
                                                height: 22,
                                                width: 22),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // if (controller.filterProductList.isNotEmpty && controller.searchTextFiledController.value.text.isNotEmpty)
                                  //   Padding(
                                  //     padding: const EdgeInsets.only(top: 40),
                                  //     child: Card(
                                  //       color: Colors.white,
                                  //       child: ListView.builder(
                                  //           itemCount: controller.filterProductList.length,
                                  //           padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
                                  //           shrinkWrap: true,
                                  //           itemBuilder: (context, index) {
                                  //             print("========${controller.filterProductList[index].brandID.toString()}");
                                  //             return InkWell(
                                  //               onTap: () {
                                  //                 Get.to(const ProductDetailsScreen(), arguments: {
                                  //                   "productModel": controller.filterProductList[index],
                                  //                 });
                                  //               },
                                  //               child: Padding(
                                  //                 padding: const EdgeInsets.symmetric(vertical: 5),
                                  //                 child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  //                   Text(
                                  //                     controller.filterProductList[index].name.toString(),
                                  //                     textAlign: TextAlign.start,
                                  //                     maxLines: 2,
                                  //                     style: const TextStyle(
                                  //                       color: AppThemeData.black,
                                  //                       fontWeight: FontWeight.w400,
                                  //                       fontFamily: AppThemeData.regular,
                                  //                     ),
                                  //                   ),
                                  //                   StreamBuilder(
                                  //                     stream: FirebaseFirestore.instance
                                  //                         .collection(CollectionName.brands)
                                  //                         .where("id", isEqualTo: controller.filterProductList[index].brandID.toString())
                                  //                         .snapshots(),
                                  //                     builder: (context, snapshot) {
                                  //                       dynamic data = snapshot.data != null ? snapshot.data!.docs[0].data() : null;
                                  //
                                  //                       return snapshot.data != null && snapshot.data!.docs.isNotEmpty
                                  //                           ? Text(
                                  //                         "by ${data['title']}",
                                  //                         textAlign: TextAlign.start,
                                  //                         maxLines: 2,
                                  //                         style: const TextStyle(
                                  //                           color: AppThemeData.black,
                                  //                           fontSize: 12,
                                  //                           fontWeight: FontWeight.w400,
                                  //                           fontFamily: AppThemeData.regular,
                                  //                         ),
                                  //                       )
                                  //                           : Container();
                                  //                     },
                                  //                   )
                                  //                 ]),
                                  //               ),
                                  //             );
                                  //           }),
                                  //     ),
                                  //   )
                                ],
                              ),
                            ),
                          ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          controller.isLoading.value
                              ? Constant.selectedPosition.id != null
                                  ? Constant.loader()
                                  : Center(child: CircularProgressIndicator())
                              : controller.bestOfferList.isEmpty ||
                                      controller.productList.isEmpty
                                  ? EmptyData()
                                  : Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0, vertical: 0),
                                          child: Column(
                                            children: [
                                              sizedBox10(),
                                              AutoScrollText(),
                                              Padding(
                                                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                                child: TodaySpecialOfferWidget(
                                                  title: 'Today Special Offers',
                                                  items:
                                                  productControl.bestOfferList,
                                                  onItemTap: (item) {
                                                  }, onSeeAllTap: () {
                                                  productControl.bestOfferList[0].categoryID.toString();

                                                },
                                                ),
                                              ),
                                              Container(
                                                height: Responsive.height(18, context),
                                                width: Get.size.width,
                                                alignment: Alignment.centerLeft,
                                                child: CarouselSlider.builder(
                                                  itemCount: controller.todaySpecialList.length,
                                                  options: CarouselOptions(
                                                    height: Responsive.height(18, context),
                                                    enlargeCenterPage: true,
                                                    autoPlay: true,
                                                    autoPlayInterval: Duration(seconds: 3),
                                                    enableInfiniteScroll: true,
                                                    viewportFraction: 0.8, // Fraction of the screen that each item takes
                                                  ),
                                                  itemBuilder: (context, index, realIndex) {
                                                    TodaySpecialModel todaySpecial = controller.todaySpecialList[index];
                                                    return InkWell(
                                                      onTap: () {
                                                        // Add navigation logic based on index
                                                        if (index == 0) {
                                                          Get.to(const ViewAllCategoryProductScreen(), arguments:
                                                          {"categoryId": productControl.freshFruitsList[0].categoryID.toString(),
                                                            "categoryName": 'Fresh Fruits'});

                                                        } else if (index == 1) {
                                                          Get.to(const ViewAllCategoryProductScreen(), arguments:
                                                          {"categoryId": productControl.freshVegetablesList[0].categoryID.toString(),
                                                            "categoryName": 'Fresh Vegetables'});
                                                        } else {
                                                          // Default action for other indices
                                                          // Get.to(DefaultPageScreen(), arguments: {
                                                          //   "data": todaySpecial,
                                                          // });
                                                        }
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(10), // Add some rounded corners
                                                        child: CustomNetworkImageWidget(
                                                          image: todaySpecial.imageUrl,
                                                          fit: BoxFit.contain,
                                                        ),
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
                                                        InkWell(
                                                          onTap: () {
                                                            Get.to(const ViewAllCategoryListScreen())!
                                                                .then((value) {
                                                              controller
                                                                  .getFavoriteData();
                                                            });
                                                          },
                                                          child: Text(
                                                            "View All".tr,
                                                            style: TextStyle(
                                                                color: AppThemeData
                                                                    .groceryAppDarkBlue,
                                                                fontSize: 12,
                                                                fontFamily: AppThemeData
                                                                    .semiBold),
                                                          ),
                                                        )
                                                      ],
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
                                                        itemCount: controller
                                                            .categoryList.length,
                                                        itemBuilder: (_, i) {
                                                          CategoryModel categoryItem =
                                                              controller
                                                                  .categoryList[i];
                                                          return CategoryItemWidget(
                                                            categoryItem: categoryItem,
                                                            colorCode: categoryItem
                                                                .color
                                                                .toString(),
                                                          );
                                                        },
                                                        separatorBuilder:
                                                            (BuildContext context,
                                                                    int index) =>
                                                                sizedBoxW10(),
                                                      ),
                                                    ),
                                                    sizedBoxDefault(),
                                                    HorizontalProductWidget(
                                                      title: 'Fresh Vegetables',
                                                      items: productControl
                                                          .freshVegetablesList,
                                                      // Pass the actual list of items here
                                                      onItemTap: (item) {
                                                        // Handle item tap
                                                      }, onSeeAllTap: () {

                                                      Get.to(const ViewAllCategoryProductScreen(), arguments:
                                                      {"categoryId": productControl.freshVegetablesList[0].categoryID.toString(),
                                                        "categoryName": 'Fresh Vegetables'});
                                                    },
                                                    ),
                                                    sizedBoxDefault(),
                                                    HorizontalProductWidget(
                                                      title: 'Fresh Fruits',
                                                      items: productControl
                                                          .freshFruitsList,
                                                      // Pass the actual list of items here
                                                      onItemTap: (item) {
                                                        // Handle item tap
                                                      }, onSeeAllTap: () {
                                                      Get.to(const ViewAllCategoryProductScreen(), arguments:
                                                      {"categoryId": productControl.freshFruitsList[0].categoryID.toString(),
                                                        "categoryName": 'Fresh Fruits'});
                                                    },
                                                    ),
                                                    sizedBoxDefault(),
                                                    HorizontalProductWidget(
                                                      title: 'Exotic Vegetables',
                                                      items: productControl
                                                          .exoticVegetablesList,
                                                      // Pass the actual list of items here
                                                      onItemTap: (item) {
                                                        // Handle item tap
                                                      }, onSeeAllTap: () {
                                                      Get.to(const ViewAllCategoryProductScreen(), arguments:
                                                      {"categoryId": productControl.exoticVegetablesList[0].categoryID.toString(),
                                                        "categoryName": 'Exotic Vegetables'});



                                                    },
                                                    ),
                                                    sizedBoxDefault(),
                                                    HorizontalProductWidget(
                                                      title: 'Exotic Fruits',
                                                      items: productControl
                                                          .exoticFruitsList,
                                                      // Pass the actual list of items here
                                                      onItemTap: (item) {
                                                        // Handle item tap
                                                      }, onSeeAllTap: () {
                                                      Get.to(const ViewAllCategoryProductScreen(), arguments:
                                                      {"categoryId": productControl.exoticFruitsList[0].categoryID.toString(),
                                                        "categoryName": 'Exotic Fruits'});
                                                    },
                                                    ),
                                                    sizedBoxDefault(),
                                                    HorizontalProductWidget(
                                                      title: 'Green Vegetables',
                                                      items: productControl
                                                          .greenVegetablesList,
                                                      // Pass the actual list of items here
                                                      onItemTap: (item) {
                                                        // Handle item tap
                                                      }, onSeeAllTap: () {
                                                      Get.to(const ViewAllCategoryProductScreen(), arguments:
                                                      {"categoryId": productControl.greenVegetablesList[0].categoryID.toString(),
                                                        "categoryName": 'Green Vegetables'});
                                                    },
                                                    ),
                                                    sizedBoxDefault(),
                                                    HorizontalProductWidget(
                                                      title: 'Beverages',
                                                      items:
                                                          productControl.beveragesList,
                                                      // Pass the actual list of items here
                                                      onItemTap: (item) {
                                                        // Handle item tap
                                                      }, onSeeAllTap: () {
                                                      Get.to(const ViewAllCategoryProductScreen(), arguments:
                                                      {"categoryId": productControl.beveragesList[0].categoryID.toString(),
                                                        "categoryName": 'Beverages'});

                                                    },
                                                    ),
                                                    const SizedBox(
                                                      height: 25,
                                                    ),

                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "Established Brands".tr,
                                                            style: TextStyle(
                                                                color:
                                                                    AppThemeData.black,
                                                                fontSize: 18,
                                                                fontFamily: AppThemeData
                                                                    .semiBold),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Get.to(const ViewAllBrandScreen(),
                                                                    arguments: {
                                                                  "type": 'brand'
                                                                })!
                                                                .then((value) {
                                                              controller
                                                                  .getFavoriteData();
                                                            });
                                                          },
                                                          child: Text(
                                                            "View All".tr,
                                                            style: TextStyle(
                                                                color: AppThemeData
                                                                    .groceryAppDarkBlue,
                                                                fontSize: 12,
                                                                fontFamily: AppThemeData
                                                                    .semiBold),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      height: Responsive.height(
                                                          38.3, context),
                                                      alignment: Alignment.centerLeft,
                                                      child: controller
                                                              .establishedProductList
                                                              .isEmpty
                                                          ? Constant.showEmptyView(
                                                              message:
                                                                  "No Established Brands Found"
                                                                      .tr)
                                                          : ListView.builder(
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              padding: EdgeInsets.zero,
                                                              itemCount: controller
                                                                          .establishedProductList
                                                                          .length >=
                                                                      8
                                                                  ? 8
                                                                  : controller
                                                                      .establishedProductList
                                                                      .length,
                                                              itemBuilder:
                                                                  (context, index) {
                                                                ProductModel
                                                                    establishedBrandItem =
                                                                    controller
                                                                            .establishedProductList[
                                                                        index];

                                                                return EstablishedBrandItemWidget(
                                                                  establishedBrandItem:
                                                                      establishedBrandItem,
                                                                );
                                                              }),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                        ],
                      ),
                    )
                  ]),
                );
              });
        });
  }
}

class OffersItemWidget extends StatelessWidget {
  final ProductModel offerItem;
  final HomeController controller;
  final int index;

  const OffersItemWidget(
      {super.key,
      required this.offerItem,
      required this.controller,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(const ProductDetailsScreen(), arguments: {
          "productModel": offerItem,
        })!
            .then((value) {
          Get.delete<ProductDetailsController>();
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Container(
          width: Responsive.width(60, context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppThemeData.color[index % AppThemeData.color.length],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: NetworkImageWidget(
                    height: Responsive.height(6, context),
                    width: Responsive.height(6, context),
                    imageUrl: offerItem.photo.toString(),
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offerItem.name.toString(),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: const TextStyle(
                        color: AppThemeData.black,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                        fontFamily: AppThemeData.regular,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        offerItem.qty_pack.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppThemeData.black.withOpacity(0.50),
                          fontSize: 12,
                          fontFamily: AppThemeData.semiBold,
                        ),
                      ),
                    ),
                    offerItem.discount == "" || offerItem.discount == "0"
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              Constant.amountShow(amount: offerItem.price),
                              style: const TextStyle(
                                  color: AppThemeData.black,
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: AppThemeData.semiBold,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: [
                                Text(
                                  Constant.amountShow(
                                      amount: Constant.calculateDiscount(
                                              amount: offerItem.price!,
                                              discount: offerItem.discount!)
                                          .toString()),
                                  style: const TextStyle(
                                      color: AppThemeData.black,
                                      fontSize: 12,
                                      fontFamily: AppThemeData.semiBold,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  Constant.amountShow(amount: offerItem.price),
                                  style: TextStyle(
                                      color:
                                          AppThemeData.black.withOpacity(0.50),
                                      fontSize: 12,
                                      fontFamily: AppThemeData.semiBold,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryItemWidget extends StatelessWidget {
  final CategoryModel categoryItem;
  final String colorCode;

  const CategoryItemWidget(
      {super.key, required this.categoryItem, required this.colorCode});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = _getColorFromHex(colorCode);
    return InkWell(
      onTap: () {
        HomeController controller = Get.find<HomeController>();
        print(categoryItem.id);
        Get.to(const ViewAllCategoryProductScreen(), arguments: {
          "categoryId": categoryItem.id,
          "categoryName": categoryItem.title
        })!
            .then((value) {
          controller.getFavoriteData();
        });
      },
      child: Container(
        width: 120,
        // padding: EdgeInsets.all(Dimensions.paddingSize10),
        decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.05),
            border: Border.all(width: 0.5, color: backgroundColor),
            borderRadius: BorderRadius.circular(
              Dimensions.radius10,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NetworkImageWidget(
              // height: Responsive.height(7, context),
              width: 100,
              imageUrl: categoryItem.photo.toString(),
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              categoryItem.title.toString(),
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 12,
                color: backgroundColor,
                overflow: TextOverflow.ellipsis,
                fontFamily: AppThemeData.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', ''); // Remove # if present
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // Add alpha value if not present
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}





class AutoScrollText extends StatefulWidget {
  @override
  _AutoScrollTextState createState() => _AutoScrollTextState();
}

class _AutoScrollTextState extends State<AutoScrollText> {
  late final ScrollController _scrollController;
  final double _scrollDuration = 10.0; // Slower scroll duration (increase for smoother scrolling)

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    if (_scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 700), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(seconds: _scrollDuration.toInt()), // Slower scrolling animation
          curve: Curves.linear,
        ).then((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.minScrollExtent);
            _startAutoScroll();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Container(
        color: Theme.of(context).primaryColor.withOpacity(0.10),
        padding: EdgeInsets.all(12.0), // Replace Dimensions.paddingSize12 with fixed value for simplicity
        child: Row(
          children: List.generate(
            2, // Repeat content if necessary
                (index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Order before 9am and get before 4pm.',
                style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor), // Replace montserratMedium with TextStyle for simplicity
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

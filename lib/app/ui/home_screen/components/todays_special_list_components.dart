import 'dart:math';

import 'package:ebasket_customer/app/ui/login_screen/login_screen.dart';
import 'package:ebasket_customer/utils/dimensions.dart';
import 'package:ebasket_customer/widgets/custom_button_widget.dart';
import 'package:ebasket_customer/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/controller/view_all_product_controller.dart';
import 'package:ebasket_customer/app/model/favourite_item_model.dart';
import 'package:ebasket_customer/app/model/item_attributes.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:ebasket_customer/services/show_toast_dialog.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/app/ui/product_details_screen/product_details_screen.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:ebasket_customer/theme/responsive.dart';
import 'package:ebasket_customer/widgets/network_image_widget.dart';

import '../../../../utils/theme/light_theme.dart';

class TodaySpecialListComponents extends StatefulWidget {
  final ProductModel trustedBrandItem;
  const TodaySpecialListComponents({super.key, required this.trustedBrandItem,});

  @override
  State<TodaySpecialListComponents> createState() => _TodaySpecialListComponentsState();
}

class _TodaySpecialListComponentsState extends State<TodaySpecialListComponents> {
  RxList<CartProduct> cartProducts = <CartProduct>[].obs;
  RxInt productQnt = 0.obs;
  RxDouble priceTemp = 0.0.obs;

  // ProductListController controller = Get.put(ProductListController());

  @override
  Widget build(BuildContext context) {
    Rx<ProductModel> trustedBrandItem = widget.trustedBrandItem.obs;
    return GetBuilder(
        init: ProductListController(),
        builder: (controller) {
          return InkWell(
            onTap: () {
              Get.to(const ProductDetailsScreen(), arguments: {
                "productModel": widget.trustedBrandItem,
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppThemeData.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x19020202),
                          blurRadius: 10,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSize10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<List<CartProduct>>(
                              stream: controller.homeController.cartDatabase.value.watchProducts,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const SizedBox();
                                } else if (snapshot.hasData) {
                                  cartProducts.value = snapshot.data!;

                                  trustedBrandItem.value.productQuantity = 0;
                                  if (cartProducts.isNotEmpty) {
                                    for (CartProduct cartProduct in cartProducts) {
                                      if (cartProduct.id == "${trustedBrandItem.value.id!}~") {
                                        trustedBrandItem.value.productQuantity = cartProduct.quantity;
                                        productQnt.value = cartProduct.quantity;
                                      }
                                    }
                                  }

                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    controller.update();
                                  });
                                  return const SizedBox(
                                    height: 0,
                                    width: 0,
                                  );
                                } else {
                                  return const SizedBox(
                                    height: 0,
                                    width: 0,
                                  );
                                }
                              }),
                          Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomNetworkImageWidget(
                                    // height: Get.size.height,
                                      height: 80,
                                      width: 80,
                                      image: widget.trustedBrandItem.photo.toString()),
                                  // const SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            trustedBrandItem.value.name.toString(),
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: AppThemeData.black,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: AppThemeData.bold,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              widget.trustedBrandItem.qty_pack.toString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppThemeData.black.withOpacity(0.50),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: AppThemeData.semiBold,
                                              ),
                                            ),
                                          ),
                                          widget.trustedBrandItem.discount == "" || widget.trustedBrandItem.discount == "0"
                                              ? Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              Constant.amountShow(amount: widget.trustedBrandItem.price),
                                              style: const TextStyle(
                                                  color: AppThemeData.black,
                                                  fontSize: 12,
                                                  overflow: TextOverflow.ellipsis,
                                                  fontFamily: AppThemeData.regular,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                          )
                                              : Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  Constant.amountShow(
                                                      amount: Constant.calculateDiscount(amount: widget.trustedBrandItem.price!, discount: widget.trustedBrandItem.discount!)
                                                          .toString()),
                                                  style: const TextStyle(
                                                      color: AppThemeData.black,
                                                      fontSize: 12,
                                                      overflow: TextOverflow.ellipsis,
                                                      fontFamily: AppThemeData.regular,
                                                      fontWeight: FontWeight.w200),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  Constant.amountShow(amount: widget.trustedBrandItem.price),
                                                  style: TextStyle(
                                                      color: AppThemeData.black.withOpacity(0.50),
                                                      fontSize: 12,
                                                      fontFamily: AppThemeData.regular,
                                                      decoration: TextDecoration.lineThrough,
                                                      fontWeight: FontWeight.w200),
                                                ),

                                              ],
                                            ),
                                          ),
                                          trustedBrandItem.value.productQuantity == 0 || trustedBrandItem.value.productQuantity == -1
                                              ?
                                          CustomButtonWidget(
                                            height: Responsive.height(4, context),
                                            width: Responsive.width(30, context),
                                            fontSize: 10,
                                            buttonText: 'Add To Cart',
                                            onPressed: () {
                                              if (Constant.currentUser.id != null) {
                                                productQnt.value = 1;
                                                trustedBrandItem.value.productQuantity = 1;
                                                setState(() {});
                                                addToCard(trustedBrandItem.value, true, controller);
                                              } else {
                                                Get.to( LoginScreen(), transition: Transition.rightToLeftWithFade);
                                              }
                                            },)
                                              : Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: SizedBox(
                                              height: Responsive.height(6, context),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          if (productQnt.value > 0) {
                                                            productQnt.value = productQnt.value - 1;
                                                            trustedBrandItem.value.productQuantity = trustedBrandItem.value.productQuantity! - 1;
                                                            removeToCard(trustedBrandItem.value, true, controller);
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                            color: Theme.of(context).primaryColor,
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: const Icon(
                                                            Icons.remove,
                                                            color: AppThemeData.black,
                                                            size: 16,
                                                          ))),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Obx(
                                                        () => SizedBox(
                                                      width: Responsive.width(5.5, context),
                                                      child: Text(
                                                        "${trustedBrandItem.value.productQuantity}",
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          fontFamily: AppThemeData.medium,
                                                          color: AppThemeData.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          if (trustedBrandItem.value.quantity! > productQnt.value || trustedBrandItem.value.quantity! == -1) {
                                                            setState(() {
                                                              productQnt.value++;
                                                            });
                                                            addToCard(trustedBrandItem.value, true, controller);
                                                          } else {
                                                            ShowToastDialog.showToast("Item out of stock");
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                            color: Theme.of(context).primaryColor,
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: const Icon(
                                                            Icons.add,
                                                            color: AppThemeData.black,
                                                            size: 16,
                                                          ))),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )

                                ],
                              ),
                              Positioned(
                                right: 5,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (Constant.currentUser.id != null) {
                                        var contain = controller.listFav.where((element) => element.productId == trustedBrandItem.value.id);

                                        if (contain.isNotEmpty) {
                                          for (int i = 0; i < controller.listFav.length; i++) {
                                            if (controller.listFav[i].productId == trustedBrandItem.value.id) {
                                              FavouriteItemModel favouriteModel =
                                              FavouriteItemModel(id: controller.listFav[i].id, productId: trustedBrandItem.value.id, userId: FireStoreUtils.getCurrentUid());
                                              FireStoreUtils.removeFavouriteItem(favouriteModel);
                                              controller.listFav.removeAt(i);
                                            }
                                          }
                                        } else {
                                          FavouriteItemModel favouriteModel =
                                          FavouriteItemModel(id: Constant.getUuid(), productId: trustedBrandItem.value.id, userId: FireStoreUtils.getCurrentUid());
                                          FireStoreUtils.addFavouriteItem(favouriteModel);
                                          controller.listFav.add(favouriteModel);
                                        }
                                      } else {
                                        Get.to( LoginScreen(), transition: Transition.rightToLeftWithFade);
                                      }
                                    });
                                  },
                                  child: controller.listFav.where((element) => element.productId == trustedBrandItem.value.id).isNotEmpty
                                      ? Icon(
                                    Icons.favorite,
                                    color: appColor,
                                  )
                                      : Icon(
                                    Icons.favorite_border,
                                    color: appColor,
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Positioned(left: 0,top: 0,right: 0,
                  //     child: Container(
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.only(
                  //             topLeft: Radius.circular(12),
                  //             topRight: Radius.circular(12)
                  //           ),
                  //           color: appColor,
                  //         ),
                  //         child: Text('${widget.trustedBrandItem.time_remaining.toString()} hours left',
                  //           textAlign: TextAlign.center,
                  //           style: const TextStyle(
                  //         color: AppThemeData.white,
                  //         fontSize: Dimensions.fontSize14,
                  //         fontWeight: FontWeight.w400,
                  //         fontFamily: AppThemeData.regular,
                  //           ),)))
                ],
              ),
            ),
          );
        });
  }

  addToCard(ProductModel productModel, bool isIncrementQuantity, ProductListController controller) async {
    List<CartProduct> cartProducts = await controller.homeController.cartDatabase.value.allCartProducts;
    if (productQnt.value > 1) {
      String mainPrice = "";

      if (productModel.discount != null && productModel.discount!.isNotEmpty && double.parse(productModel.discount!) != 0) {
        mainPrice = Constant.calculateDiscount(amount: productModel.price!, discount: productModel.discount!).toString();
      } else {
        mainPrice = productModel.price!;
      }
      final bool productIsInList = cartProducts.any((product) => product.id == "${productModel.id!}~");

      if (productIsInList) {
        CartProduct element = cartProducts.firstWhere((product) => product.id == "${productModel.id!}~");

        await controller.homeController.cartDatabase.value.updateProduct(CartProduct(
            id: element.id,
            name: element.name,
            photo: element.photo,
            price: element.price,
            quantity: isIncrementQuantity ? element.quantity + 1 : element.quantity,
            category_id: element.category_id,
            discountPrice: element.discountPrice!,
            hsn_code: element.hsn_code,
            description: element.description,
            discount: element.discount,
            unit: element.unit));
      } else {
        await controller.homeController.cartDatabase.value.updateProduct(CartProduct(
          // id: "${productModel.id!}~${productModel.variantInfo != null ? productModel.variantInfo!.variantId.toString() : ""}",
            id: "${productModel.id!}~",
            name: productModel.name!,
            photo: productModel.photo!,
            price: productModel.price!,
            discountPrice: productModel.discount != null && productModel.discount!.isNotEmpty && double.parse(productModel.discount!) != 0 ? mainPrice : '0',
            quantity: productModel.quantity!,
            category_id: productModel.categoryID!,
            hsn_code: productModel.hsn_code!,
            description: productModel.description!,
            discount: productModel.discount!,
            unit: productModel.unit!,
            variant_info: productModel.variantInfo));
      }
      setState(() {});
    } else {
      controller.homeController.cartDatabase.value.addProduct(productModel, controller.homeController.cartDatabase.value, isIncrementQuantity);
    }
    updatePrice(controller);
  }

  void updatePrice(ProductListController controller) {
    List<CartProduct> cartProducts = [];
    Future.delayed(const Duration(milliseconds: 500), () {
      cartProducts.clear();

      controller.homeController.cartDatabase.value.allCartProducts.then((value) {
        priceTemp.value = 0;
        cartProducts.addAll(value);
        for (int i = 0; i < cartProducts.length; i++) {
          CartProduct e = cartProducts[i];

          priceTemp.value += double.parse(e.price) * e.quantity;
          setState(() {});
        }
      });
    });
  }

  removeToCard(ProductModel productModel, bool isIncrementQuantity, ProductListController controller) async {
    List<CartProduct> cartProducts = await controller.homeController.cartDatabase.value.allCartProducts;
    if (productQnt.value >= 1) {
      String mainPrice = "";

      if (productModel.discount != null && productModel.discount!.isNotEmpty && double.parse(productModel.discount!) != 0) {
        mainPrice = Constant.calculateDiscount(amount: productModel.price!, discount: productModel.discount!).toString();
      } else {
        mainPrice = productModel.price!;
      }
      final bool productIsInList = cartProducts.any((product) => product.id == "${productModel.id!}~");

      if (productIsInList) {
        CartProduct element = cartProducts.firstWhere((product) => product.id == "${productModel.id!}~");

        await controller.homeController.cartDatabase.value.updateProduct(CartProduct(
            id: element.id,
            name: element.name,
            photo: element.photo,
            price: element.price,
            quantity: isIncrementQuantity ? element.quantity - 1 : element.quantity,
            category_id: element.category_id,
            discountPrice: element.discountPrice!,
            hsn_code: element.hsn_code,
            description: element.description,
            discount: element.discount,
            unit: element.unit));
      } else {
        await controller.homeController.cartDatabase.value.updateProduct(CartProduct(
            id: "${productModel.id!}~",
            name: productModel.name!,
            photo: productModel.photo!,
            price: productModel.price.toString(),
            discountPrice: (productModel.discount != null && productModel.discount!.isNotEmpty && double.parse(productModel.discount!) != 0) ? mainPrice : '0',
            quantity: productModel.quantity!,
            category_id: productModel.categoryID!,
            hsn_code: productModel.hsn_code!,
            description: productModel.description!,
            discount: productModel.discount!,
            unit: productModel.unit!,
            variant_info: productModel.variantInfo));
      }
    } else {
      controller.homeController.cartDatabase.value.removeProduct("${productModel.id!}~${productModel.variantInfo != null ? productModel.variantInfo!.variantId.toString() : ""}");

      setState(() {
        productQnt.value = 0;
      });
    }

    setState(() {});
    updatePrice(controller);
  }
}

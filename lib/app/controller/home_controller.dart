import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebasket_customer/app/model/address_model.dart';
import 'package:ebasket_customer/app/model/todays_special_model.dart';
import 'package:ebasket_customer/app/model/vendor_model.dart';
import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/model/category_model.dart';
import 'package:ebasket_customer/app/model/favourite_item_model.dart';
import 'package:ebasket_customer/app/model/location_lat_lng.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/app/model/user_model.dart';
import 'package:ebasket_customer/main.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:ebasket_customer/constant/constant.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxList<ProductModel> bestOfferList = <ProductModel>[].obs;
  RxList<TodaySpecialModel> todaySpecialList = <TodaySpecialModel>[].obs;

  RxList<ProductModel> brandList = <ProductModel>[].obs;
  RxList<FavouriteItemModel> listFav = <FavouriteItemModel>[].obs;
  Rx<TextEditingController> searchTextFiledController = TextEditingController().obs;
  RxInt cartCount = 0.obs;
  Rx<CartDatabase> cartDatabase = CartDatabase().obs;
  RxList<ProductModel> filterProductList = <ProductModel>[].obs;
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList<ProductModel> establishedProductList = <ProductModel>[].obs;
  Rx<VendorModel> vendorModel = VendorModel().obs;

  RxDouble animationValue = 0.0.obs;
  bool isFirstRun = true;

  @override
  void onInit() {
    super.onInit();
    // _checkFirstRun(); // Check for the first run and show the dialog if needed
    getUserData();
    getAllProduct();
    startAnimation();

    cartDatabase.value = Provider.of<CartDatabase>(MyAppState.navigatorKey.currentContext!);
    // addSampleBanners();
  }

  // Check if the app is running for the first time
  // Future<void> _checkFirstRun() async {
  //   // SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // bool? firstRun = prefs.getBool('firstRun');
  //   //
  //   // if (firstRun == null || firstRun == true) {
  //     // Show the dialog
  //     _showWelcomeDialog();
  //
  //     // Set the firstRun flag to false after showing the dialog
  //     // await prefs.setBool('firstRun', false);
  //   // }
  // }

  // Function to show a welcome dialog or any other dialog
  void _showWelcomeDialog() {
    Get.dialog(
      Dialog(
        child: Container(decoration: BoxDecoration(image: DecorationImage(image: 
        AssetImage('assets/images/coupon_bg.png'))),),
      ),
    );
  }

  getUserData() async {
    if (Constant.currentUser.id != null) {
      await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) async {
        if (value != null) {
          userModel.value = value;
          if (userModel.value.shippingAddress!.isNotEmpty) {
            if (userModel.value.shippingAddress!.where((element) => element.isDefault == true).isNotEmpty) {
              Constant.selectedPosition = userModel.value.shippingAddress!.where((element) => element.isDefault == true).single;
            } else {
              Constant.selectedPosition = userModel.value.shippingAddress!.first;
            }
          } else {
            Constant.selectedPosition = AddressModel();
          }

          update();
        }
      });
    }
    await getFavoriteData();
    await getTax();

    update();
  }

  getTax() async {
    if (Constant.selectedPosition.id != null) {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
          double.parse(Constant.selectedPosition.location!.latitude.toString()), double.parse(Constant.selectedPosition.location!.longitude.toString()));

      Constant.country = placeMarks.first.country;
      await FireStoreUtils().getTaxList().then((value) {
        if (value != null) {
          Constant.taxList = value;
        }
      });
      getData();
    } else {
      Constant.selectedPosition = AddressModel();
    }
  }

  getData() async {
    await FireStoreUtils.getCategories().then((value) {
      if (value != null) {
        categoryList.value = value;
      }
    });
    await FireStoreUtils.getTodaySpecial().then((value) {
      if (value != null) {
        todaySpecialList.value = value;
      }
    });

    await FireStoreUtils.getVendor().then((value) {
      if (value != null) {
        vendorModel.value = value;
      }
    });
    Constant.distance = (Constant.getKm(LocationLatLng(latitude: Constant.selectedPosition.location!.latitude, longitude: Constant.selectedPosition.location!.longitude),
        LocationLatLng(latitude: vendorModel.value.latitude, longitude: vendorModel.value.longitude)));

    bestOfferList.clear();
    establishedProductList.clear();

    if (double.parse(Constant.vendorRadius) >= double.parse(Constant.distance)) {
      FireStoreUtils.getBestOfferProducts().then((value) {
        if (value != null) {
          bestOfferList.value = value;
          update();
        }
      });

      FireStoreUtils.getEstablishBrandProducts().then((value) {
        if (value != null) {
          for (var element in value) {
            if (element.brandID != null) {
              establishedProductList.value = value;
              update();
            }
          }
        }
      });
    }
    isLoading.value = false;

    update();
  }

  getFavoriteData() async {
    await FireStoreUtils.getFavouritesProductList(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        listFav.value = value;
      }
    });
    update();
  }

  getAllProduct() async {
    await FireStoreUtils.getAllDeliveryProducts().then((value) {
      if (value != null) {
        productList.value = value;
      }
    });
  }

  getFilterData(String value) async {
    if (value.toString().isNotEmpty) {
      filterProductList.value = productList.where((e) => e.name!.toLowerCase().contains(value.toLowerCase().toString()) || e.name!.startsWith(value.toString())).toList();
    } else {
      filterProductList.value = productList;
    }
    update();
  }

  void startAnimation() {
    animationValue.value = 0.0; // Reset to start position
    Future.delayed(Duration(milliseconds: 100), () {
      animationValue.value = 1.0; // Move text to the end position
      Future.delayed(Duration(seconds: 5), startAnimation);
    });
  }

  Future<void> addBannerToFirestore(TodaySpecialModel banner) async {
    CollectionReference bannerCollection = FirebaseFirestore.instance.collection('todays_special');

    await bannerCollection.doc(banner.id).set(banner.toJson()).then((_) {
      print("Banner added: ${banner.title}");
    }).catchError((error) {
      print("Failed to add banner: $error");
    });
  }

  void addSampleBanners() async {
    List<TodaySpecialModel> banners = [
      TodaySpecialModel(
        id: 'banner1',
        title: 'Special Offer on Potatoes!',
        imageUrl: 'https://example.com/potatoes-banner.jpg',
        linkUrl: 'https://example.com/potatoes',
        publish: true,
      ),
      TodaySpecialModel(
        id: 'banner2',
        title: 'Fresh Apples Discount!',
        imageUrl: 'https://example.com/apples-banner.jpg',
        linkUrl: 'https://example.com/apples',
        publish: true,
      ),
      TodaySpecialModel(
        id: 'banner3',
        title: 'Buy One Get One Free!',
        imageUrl: 'https://example.com/bogo-banner.jpg',
        linkUrl: 'https://example.com/bogo',
        publish: true,
      ),
    ];

    for (var banner in banners) {
      await addBannerToFirestore(banner);
    }
  }


}


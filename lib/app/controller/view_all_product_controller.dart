import 'package:flutter/material.dart';
import 'package:ebasket_customer/app/controller/home_controller.dart';
import 'package:ebasket_customer/app/model/attributes_model.dart';
import 'package:ebasket_customer/app/model/favourite_item_model.dart';
import 'package:ebasket_customer/app/model/item_attributes.dart';
import 'package:ebasket_customer/app/model/product_model.dart';
import 'package:ebasket_customer/services/firebase_helper.dart';
import 'package:ebasket_customer/services/localDatabase.dart';
import 'package:get/get.dart';


class ProductListController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<ProductModel> productList = <ProductModel>[].obs;
  RxList<ProductModel> productSearchList = <ProductModel>[].obs;
  RxList<ProductModel> freshVegetablesList = <ProductModel>[].obs;
  RxList<ProductModel> freshFruitsList = <ProductModel>[].obs;
  RxList<ProductModel> exoticVegetablesList = <ProductModel>[].obs;
  RxList<ProductModel> exoticFruitsList = <ProductModel>[].obs;
  RxList<ProductModel> greenVegetablesList = <ProductModel>[].obs;
  RxList<ProductModel> beveragesList = <ProductModel>[].obs;
  RxList<ProductModel> bakeryList = <ProductModel>[].obs;
  RxList<ProductModel> dairyProductList = <ProductModel>[].obs;

  RxList<ProductModel> bestOfferList = <ProductModel>[].obs;
  RxList<String> selectedBrandId = <String>[].obs;

  RxList<CartProduct> cartProducts = <CartProduct>[].obs;
  RxInt cartCount = 0.obs;
  RxString categoryId = '0'.obs;
  RxString categoryName = ''.obs;
  Rx<TextEditingController> searchTextFieldController = TextEditingController().obs;
  RxList<FavouriteItemModel> listFav = <FavouriteItemModel>[].obs;
  HomeController homeController = Get.find<HomeController>();
  RxString type = ''.obs;
  RxList<Attributes>? attributes = <Attributes>[].obs;
  RxList<Variants>? variants = <Variants>[].obs;
  RxList<String> selectedVariants = <String>[].obs;
  RxList<String> selectedIndexVariants = <String>[].obs;
  RxList<String> selectedIndexArray = <String>[].obs;
  RxList<AttributesModel> attributesList = <AttributesModel>[].obs;
  RxInt selectedVariantIndex = 0.obs;
  RxList<String> tempProduct = <String>[].obs;
  RxList<CartProduct> tempCartProducts = <CartProduct>[].obs;

  @override
  void onInit() {
    super.onInit();
    getData();
    getFavoriteData();
    fetchFreshVegetablesProducts();
    fetchFreshFruitProducts();
    fetchExoticVegetablesProducts();
    fetchExoticFruitsListProducts();
    fetchGreenVegetablesListProducts();
    fetchBeveragesListProducts();
    fetchBakeryListProducts();
    fetchDairyListProducts();
    getBestOfferProducts();
    print(' Product controller id ${categoryId}');
  }

  Future<void> fetchProductsById(String? CategoryId) async {
    isLoading.value = true;
    try {

      final value = await FireStoreUtils.getProductListByCategoryId(CategoryId!);
      if (value != null) {
        productList.value = value;
        productSearchList.value = value;
      }
    } catch (error) {
      print('Error fetching fresh vegetables products: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getData() async {
    dynamic argumentData = Get.arguments;
    selectedVariantIndex.value = -1;

    if (argumentData != null) {
      if (argumentData['categoryId'] != null) {
        categoryId.value = argumentData['categoryId'] ?? '0';
        categoryName.value = argumentData['categoryName'] ?? '';

        try {
          final value = await FireStoreUtils.getProductListByCategoryId(categoryId.value);
          if (value != null) {
            productList.value = value;
            productSearchList.value = value;
          }
        } catch (e) {
          print('Error fetching products by category ID: $e');
        }
        isLoading.value = false;

      } else if (argumentData['type'] != null) {
        type.value = argumentData['type'] ?? '';

        if (type.value == 'brand') {
          try {
            final value = await FireStoreUtils.getEstablishBrandProducts();
            if (value != null) {
              for (var element in value) {
                if (element.brandID != null) {
                  productList.value = value;
                  productSearchList.value = value;
                }
              }
            }
          } catch (e) {
            print('Error fetching brand products: $e');
          }

        } else if (type.value == 'checkoutBrand') {
          try {
            tempCartProducts.value = await homeController.cartDatabase.value.allCartProducts;
            for (int i = 0; i < tempCartProducts.length; i++) {
              tempProduct.add(tempCartProducts[i].id.toString());
            }

            final value = await FireStoreUtils.getAllDeliveryProducts();
            if (value != null) {
              for (var element in value) {
                if (element.brandID != null && !tempProduct.contains('${element.id!}~')) {
                  productList.add(element);
                  productSearchList.add(element);
                }
              }
            }
          } catch (e) {
            print('Error fetching delivery products: $e');
          }

        } else {
          try {
            final value = await FireStoreUtils.getBestOfferProducts();
            if (value != null) {
              productList.value = value;
              productSearchList.value = value;
            }
          } catch (e) {
            print('Error fetching best offer products: $e');
          }
        }

        isLoading.value = false;
      }

      try {
        final value = await FireStoreUtils.getVendorAttribute();
        if (value != null) {
          attributesList.value = value;
        }
      } catch (e) {
        print('Error fetching vendor attributes: $e');
      }

      update();
    } else {
      print('No arguments found');
    }
  }


  Future<void> fetchFreshVegetablesProducts() async {
    const String staticCategoryId = '65d85efaa0c87';
    try {
      final value = await FireStoreUtils.getProductListByCategoryId(staticCategoryId);
      if (value != null) {
        freshVegetablesList.value = value;
      }
    } catch (error) {
      print('Error fetching fresh vegetables products: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFreshFruitProducts() async {
    const String staticCategoryId = '65d86088c7958';
    try {
      final value = await FireStoreUtils.getProductListByCategoryId(staticCategoryId);
      if (value != null) {
        freshFruitsList.value = value;
      }
    } catch (error) {
      print('Error fetching fresh fruit products: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchExoticVegetablesProducts() async {
    const String staticCategoryId = '65d860d6ea757';
    try {
      final value = await FireStoreUtils.getProductListByCategoryId(staticCategoryId);
      if (value != null) {
        exoticVegetablesList.value = value;
      }
    } catch (error) {
      print('Error fetching exotic vegetables products: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchExoticFruitsListProducts() async {
    const String staticCategoryId = '65e5abad2c9f7';
    try {
      final value = await FireStoreUtils.getProductListByCategoryId(staticCategoryId);
      if (value != null) {
        exoticFruitsList.value = value;
      }
    } catch (error) {
      print('Error fetching exotic fruits products: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchGreenVegetablesListProducts() async {
    const String staticCategoryId = '65e5ac604f4f2';
    try {
      final value = await FireStoreUtils.getProductListByCategoryId(staticCategoryId);
      if (value != null) {
        greenVegetablesList.value = value;
      }
    } catch (error) {
      print('Error fetching green vegetables products: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBeveragesListProducts() async {
    const String staticCategoryId = '65e5acb0ecc9e';
    try {
      final value = await FireStoreUtils.getProductListByCategoryId(staticCategoryId);
      if (value != null) {
        beveragesList.value = value;
      }
    } catch (error) {
      print('Error fetching beverages products: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBakeryListProducts() async {
    const String staticCategoryId = '665b313d67893';
    try {
      final value = await FireStoreUtils.getProductListByCategoryId(staticCategoryId);
      if (value != null) {
        bakeryList.value = value;
      }
    } catch (error) {
      print('Error fetching bakery products: $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDairyListProducts() async {
    const String staticCategoryId = '65e5ac7cea30c';
    try {
      final value = await FireStoreUtils.getProductListByCategoryId(staticCategoryId);
      if (value != null) {
        dairyProductList.value = value;
      }
    } catch (error) {
      print('Error fetching dairy products: $error');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> getBestOfferProducts() async {
    isLoading.value = true;  // Indicate that data fetching is in progress
    try {
      final value = await FireStoreUtils.getBestOfferProducts();  // Fetch best offer products
      if (value != null) {
        bestOfferList.value = value;  // Assign the products to the productList// Also assign to search list for easy filtering
      }
    } catch (error) {
      print('Error fetching best offer products: $error');
    } finally {
      isLoading.value = false;  // Indicate that loading has finished
    }
  }


  Future<void> getFavoriteData() async {
    try {
      final value = await FireStoreUtils.getFavouritesProductList(FireStoreUtils.getCurrentUid());
      if (value != null) {
        listFav.value = value;
      }
    } catch (e) {
      print('Error fetching favorite products: $e');
    }
  }

  void getFilterData(String value) {
    if (value.isNotEmpty) {
      productSearchList.value = productList.where((e) =>
          e.name!.toLowerCase().contains(value.toLowerCase())).toList();
    } else {
      productSearchList.value = productList;
    }
  }
}


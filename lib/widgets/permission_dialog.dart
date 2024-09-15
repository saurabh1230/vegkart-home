import 'package:flutter/material.dart';
import 'package:ebasket_customer/theme/app_theme_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../utils/theme/light_theme.dart';

class PermissionDialog extends StatelessWidget {
  const PermissionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: SizedBox(
          width: 500,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.add_location_alt_rounded, color: Theme.of(context).primaryColor, size: 100),
            const SizedBox(height: 20),
            const Text(
              'You denied location permission forever. Please allow location permission from your app settings and receive more accurate delivery.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(width: 2, color: Theme.of(context).primaryColor)),
                    minimumSize: const Size(1, 50),
                  ),
                  child: const Text('close'),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColor,
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side:  BorderSide(
                          color: appColor,
                        ),
                      ),
                    ),
                    child: const Text(
                      'settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:  Colors.white,
                      ),
                    ),
                    onPressed:() async {
                      await Geolocator.openAppSettings();
                   Get.back();
                    },
                  ),
                ),
              )

            ]),
          ]),
        ),
      ),
    );
  }
}

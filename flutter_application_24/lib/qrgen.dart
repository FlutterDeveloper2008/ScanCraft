import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class gen1 extends StatelessWidget {
  gen1({super.key, required this.website});
  final String website;
  final ScreenshotController screenshotController = ScreenshotController();
  Future<void> save() async {
    final Uint8List? uint8list = await screenshotController.capture();
    if (uint8list != null) {
      final PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) {
        final result = await ImageGallerySaver.saveImage(uint8list);
        if (result['isSuccess']) {
          print('Image Saved to Galarey');
        } else {
          print('Failed to save image:${result['error']} ');
        }
      } else {
        print('Permission to access storage denied');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Screenshot(
              controller: screenshotController,
              child: QrImageView(
                backgroundColor: Colors.white,
                data: website,
                version: QrVersions.auto,
                gapless: false,
                size: 320,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Text(
              'Your QR is ready !',
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            Text(
              'You can screenshot it to save.',
              style: TextStyle(color: Colors.black, fontSize: 23),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

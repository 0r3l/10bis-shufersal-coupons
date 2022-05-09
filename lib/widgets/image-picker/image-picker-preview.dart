import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tenbis_shufersal_coupons/models/picked-image.dart';

class ImagePickerPreview extends StatelessWidget {
  ImagePickerPreview({Key? key, required this.pickedImage}) : super(key: key);
  final PickedImage? pickedImage;

  @override
  Widget build(BuildContext context) {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (pickedImage!.imageFile != null) {
      return kIsWeb
          ? Image.network(pickedImage!.imageFile!.path)
          : Image.file(File(pickedImage!.imageFile!.path));
    } else if (pickedImage!.pickImageError != null) {
      return Text(
        'שגיאה בבחירת תמונה: ${pickedImage!.pickImageError}',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'לא נבחרה תמונה עדיין',
        textAlign: TextAlign.center,
      );
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (pickedImage!.retrieveDataError != null) {
      final Text result = Text(pickedImage!.retrieveDataError!);
      return result;
    }
    return null;
  }
}

import 'package:image_picker/image_picker.dart';

class PickedImage {
  PickedImage(
      {required this.imageFile,
      required this.retrieveDataError,
      required this.pickImageError});
  String? retrieveDataError;
  PickedFile? imageFile;
  dynamic pickImageError;
}

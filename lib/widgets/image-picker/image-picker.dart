import 'package:flutter/material.dart';
import 'package:tenbis_shufersal_coupons/models/picked-image.dart';
import 'package:image_picker/image_picker.dart';

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);

class GissImagePicker extends StatefulWidget {
  GissImagePicker({Key? key, required this.onImageSelect}) : super(key: key);

  final ValueChanged<PickedImage> onImageSelect;

  @override
  _GissImagePickerState createState() => _GissImagePickerState();
}

class _GissImagePickerState extends State<GissImagePicker> {
  final ImagePicker _picker = ImagePicker();
  String? _retrieveDataError;
  PickedFile? _imageFile;
  dynamic _pickImageError;
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: FloatingActionButton(
            onPressed: () {
              _onImageButtonPressed(ImageSource.gallery, context: context);
            },
            heroTag: 'image0',
            tooltip: 'Pick Image from gallery',
            child: const Icon(Icons.photo),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: FloatingActionButton(
            onPressed: () {
              _onImageButtonPressed(ImageSource.camera, context: context);
            },
            heroTag: 'image2',
            tooltip: 'Take a Photo',
            child: const Icon(Icons.camera_alt),
          ),
        ),
      ],
    );
  }

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile =
          await _picker.getImage(source: source, maxWidth: 500, maxHeight: 500);
      setState(() {
        _imageFile = pickedFile;
        widget.onImageSelect(PickedImage(
            imageFile: _imageFile,
            pickImageError: _pickImageError,
            retrieveDataError: _retrieveDataError));
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.image) {
        setState(() {
          _imageFile = response.file;
        });
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }
}

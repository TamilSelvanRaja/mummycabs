import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mummy_cabs/services/utils.dart';

class ImageController extends ChangeNotifier {
  Utils utils = Utils();

  final _picker = ImagePicker();

  Future goToCameraScreen(BuildContext context, ImageSource selectedSource) async {
    try {
      final pickedFile = await _picker.pickImage(source: selectedSource, imageQuality: 100);
      if (pickedFile != null) {
        return pickedFile.path;
      }
    } on PlatformException catch (e) {
      if (e.code == 'camera_access_denied') {
        utils.showToast("Failed", "File Access Permission Denied");
        await AppSettings.openAppSettings(type: AppSettingsType.settings);
      }
    } catch (e) {
      // print(e);
    }
  }
}

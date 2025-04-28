import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

Future<String?> uploadImageCloudinary(File imageFile) async {
  final cloudName = "dew79mrbd";
  final uploadPreset = "flutterupload";

  final url = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

  try{
    final formData = FormData.fromMap({
      'file' : await MultipartFile.fromFile(imageFile.path),
      'upload_preset' : uploadPreset,
    });

    final response = await Dio().post(url, data: formData);

    if (response.statusCode == 200) {
      final imageUrl = response.data['secure_url'];
      print('Uploaded image URL: $imageUrl');
      return imageUrl;
    }else{
      print('Upload failed');
      return null;
    }
  }catch(e){
    print("Upload error: $e");
    return null;
  }
}
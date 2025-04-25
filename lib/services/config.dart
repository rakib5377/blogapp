import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String?> uploadImage(File imageFile) async {
  try{
    String uploadUrl = "https://api.imgbb.com/1/upload?key=${dotenv.env["imgbbAPIKEY"]}";

    FormData formData = FormData.fromMap({
      "image" : await MultipartFile.fromFile(imageFile.path, filename: "upload.jpg")
    });
    Dio dio = Dio();

    Response response = await dio.post(
      uploadUrl, data: formData,
      options: Options(
        headers: {
          "Content-Type" : "multipart/form-data",
        },
      ),
    );

    if (response.statusCode == 200 && response.data['success'] == true){
      String imageUrl = response.data['data']['url'];
      print('Uploaded image URL: $imageUrl');
      return imageUrl;
    }else{
      print('Failed to upload image: ${response.data}');
      return null;
    }
  } catch(e) {
    print('Error uploading image: $e');
    return null;
  }
}
import 'package:flutter/cupertino.dart';

class ImageServices{
  static ImageProvider moviePoster(String url){
    try{
      return NetworkImage(url);
    }catch(e){
      return AssetImage("asserts/no_picture_avatar.jpg");
    }
  }
}
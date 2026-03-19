import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ImageErrorBuilderUtils {
  ///get network image from url
  ///if no image found (i.e on error) user profile icon will be shown
  static Widget getUserProfile(BuildContext context) {
    return Container(
      color: Colors.lightBlue,
      child: Icon(Icons.person, size: 20.w, color: Colors.white),
    );
  }

  ///Image error builder where is no image found first alphabet of user name will be shown
  ///like Aakash Ghimire => (AG)
  static Widget getUserName(BuildContext context, String name) {
    try {
      final List<String> firstLetters = name
          .split(' ')
          .map((word) => word[0].toUpperCase())
          .toList();

      return Text(
        "${firstLetters.first}${firstLetters.length > 1 ? firstLetters[1] : ''}",
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    } catch (e) {
      return const Text('');
    }
  }

  ///File image asset that is used to show selected file preview
  static Widget getFilePlaceHolder() => Container(
    color: Colors.lightBlue,
    child: Column(
      children: [
        SizedBox(height: 2.h),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            width: 20.w,
            height: 20.w,
            fit: BoxFit.fill,
            'assets/icons/icons/file.png',
          ),
        ),
      ],
    ),
  );
}

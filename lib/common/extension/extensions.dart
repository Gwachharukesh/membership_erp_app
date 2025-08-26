import 'dart:developer';

import 'package:nepali_utils/nepali_utils.dart';

extension StringExtension on String{
  /// capitalize first letter of the string and make lowercaswe for rest
  /// eg- rohan sHRESTHA -> Rohan shrestha
  String toCapitalize(){
    var words  = split(' ');
    for(var i = 0; i < words.length; i++){
      if(words[i] != ''){
        words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
      }
    }
    return words.join(' ');
  }

  /// Capitalize first letter of the string
  /// eg- rohan sHRESTHA -> Rohan sHRESTHA
  String toCapitalizeOnlyFirst(){
    if(isEmpty) return '';
    var words = this[0].toUpperCase() + substring(1);
    return words;
  }

  /// Get first charecter of given name till the [maxCount].
  /// eg- if [maxCount] is 3 and given string is ram bahadur rana magar, it reutns RBR.
  /// Here, R is taken from ram, B from bahadur and R from rana.
  String toInitials({int maxCount = 2}){
    var words = split(' ');
    for(var i = 0; i < words.length; i++){
      if(words[i] != ''){
        words[i] = words[i][0].toUpperCase();
      }
    }
    return words.take(maxCount).join();
  }

  /// Conern given string into datetime if possible otherwise return null.
  DateTime? toDateTime({bool isBs = false, String? format}){
    try{
      if(isBs){
        return NepaliDateTime.tryParse(this)?.toDateTime();
      }
      return DateTime.tryParse(this);
    }on Exception catch(e){
      log(e.toString());
      return null;
    }
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class VTimeStamps{
    VTimeStamps._();

    static
    Timestamp getDateFrom(int day){
      return Timestamp.fromDate(DateTime.now().subtract(Duration(days: day)));
    }

    static
    Timestamp getDateTo(int day){
      return Timestamp.fromDate(DateTime.now().add(Duration(days: day)));
    }

    static
    Timestamp getDateNow(int day){
      return Timestamp.fromDate(DateTime.now());
    }
}
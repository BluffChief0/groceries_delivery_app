import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String uniteAddress({
  required String street,
  required String building,
  required String entrance,
  required String floor,
  required String apartment,
}) {
  String address = '';
  address += street;
  address += ', дом $building';
  if (entrance.isNotEmpty) {
    address += ', подъезд $entrance';
  }
  if (floor.isNotEmpty) {
    address += ', этаж $floor';
  }
  if (apartment.isNotEmpty) {
    address += ', квартира $apartment';
  }
  return address;
}

String uniteTime({
  required DateTime date,
  required TimeOfDay time,
}) {
  final format = DateFormat('yyyy-MM-dd');
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  final format24 = DateFormat.Hm();
  final deliveryTime = '${format.format(date)}T${format24.format(dt)}:00';
  return deliveryTime;
}

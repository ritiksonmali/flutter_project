import 'package:flutter/cupertino.dart';

class DeliveryInstruction {
  DeliveryInstruction(
      {required this.id,
      required this.name,
      required this.active,
      required this.icon});
  int id;
  String name;
  bool active;
  IconData icon;
}

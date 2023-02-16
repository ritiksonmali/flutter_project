import 'package:flutter/material.dart';
import 'package:flutter_login_app/Pages/cart/DeliveryInstruction.dart';

const List<Map<String, dynamic>> instructionlist = [
  {
    "id": "1",
    "name": "Avoid\nringing bell",
    "active": false,
    "icon": Icons.notifications_active,
  },
  {
    "id": "2",
    "name": "Leave at \nthe door",
    "active": false,
    "icon": Icons.door_front_door
  },
  {
    "id": "3",
    "name": "Direction \nto Reach",
    "active": false,
    "icon": Icons.directions,
  },
  {
    "id": "4",
    "name": "Avoid\nCalling",
    "active": false,
    "icon": Icons.call,
  },
  {
    "id": "5",
    "name": "Leave with\nSecurity",
    "active": false,
    "icon": Icons.security,
  },
];

List<DeliveryInstruction> instructionData = [
  DeliveryInstruction(
    id: 1,
    name: "Avoid\nringing bell",
    active: false,
    icon: Icons.notifications_active,
  ),
  DeliveryInstruction(
    id: 2,
    name: "Leave at \nthe door",
    active: false,
    icon: Icons.door_front_door,
  ),
  DeliveryInstruction(
    id: 3,
    name: "Direction \nto Reach",
    active: false,
    icon: Icons.directions,
  ),
  DeliveryInstruction(
    id: 4,
    name: "Avoid\nCalling",
    active: false,
    icon: Icons.call,
  ),
  DeliveryInstruction(
    id: 5,
    name: "Leave with\nSecurity",
    active: false,
    icon: Icons.security,
  ),
];

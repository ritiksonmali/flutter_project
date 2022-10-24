// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class QuantityButton extends StatefulWidget {
//   final int initialQuantity;
//   final Future<int>? Function(int) onQuantityChange;
//   const QuantityButton(
//       {Key? key, required this.initialQuantity, required this.onQuantityChange})
//       : super(key: key);

//   @override
//   _QuantityButtonState createState() =>
//       _QuantityButtonState(quantity: initialQuantity);
// }

// class _QuantityButtonState extends State<QuantityButton> {
//   int quantity;
//   bool isSaving = false;
//   _QuantityButtonState({required this.quantity});

//   void changeQuantity(int newQuantity) async {
//     setState(() {
//       isSaving = true;
//     });
//     newQuantity = await widget.onQuantityChange(newQuantity) ?? newQuantity;
//     setState(() {
//       quantity = newQuantity;
//       isSaving = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(children: [
//       IconButton(
//           color: Colors.black,
//           onPressed: (isSaving || quantity < 1)
//               ? null
//               : () => changeQuantity(quantity - 1),
//           icon: Icon(Icons.remove)),
//       Text(quantity.toString()),
//       IconButton(
//           color: Colors.black,
//           onPressed: (isSaving) ? null : () => changeQuantity(quantity + 1),
//           icon: Icon(Icons.add)),
//     ]);
//   }
// }

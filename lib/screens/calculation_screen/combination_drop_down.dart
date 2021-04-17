import 'package:dscore_app/screens/calculation_screen/calculation_screen_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class CombinationDropDown extends StatefulWidget {
//   @override
//   _CombinationDropDownState createState() => _CombinationDropDownState();
// }
//
// class _CombinationDropDownState extends State<CombinationDropDown> {
//   List<num> _points = [0.1, 0.2, 0.3, 0.4];
//   num _selectItem = 0;
//
//   void initState() {
//     super.initState();
//     setItems();
//     _selectItem = _points[0];
//   }
//
//   void setItems() {
//     _points..add(DropdownMenuItem(
//       child: Text(
//         0.1,
//         style: TextStyle(fontSize: 30.0),
//       ),
//       value: 1,
//     ))..add(DropdownMenuItem(
//       child: Text(
//         '0.2',
//         style: TextStyle(fontSize: 30.0),
//       ),
//       value: 2,
//     ))..add(DropdownMenuItem(
//       child: Text(
//         '0.3',
//         style: TextStyle(fontSize: 30.0),
//       ),
//       value: 3,
//     ))..add(DropdownMenuItem(
//       child: Text(
//         '0.4',
//         style: TextStyle(fontSize: 30.0),
//       ),
//       value: 4,
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton(
//       items: _points,
//       value: _selectItem,
//       onChanged: (value) =>
//       {
//         setState(
//               () {
//             _selectItem = value;
//           },
//         ),
//       },
//     );
//   }
// }

class CombinationDropDown extends StatelessWidget {
  final List<DropdownMenuItem> _cvPoints = [
    _cvPointItem(0.1),
    _cvPointItem(0.2),
    _cvPointItem(0.3),
    _cvPointItem(0.4),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<CalculationScreenModel>(
      builder: (context, model, child) {
        return DropdownButton(
          items: _cvPoints,
        );
      },
    );
  }
}

DropdownMenuItem _cvPointItem(num point) {
  return DropdownMenuItem(
    child: Text(
      '$point',
      style: TextStyle(fontSize: 30.0),
    ),
  );
}

//uncomment if you will add more pages in on boarding

// import 'package:flutter/material.dart';

// import '../../core/utils/app_values.dart';

// class Indicator extends StatefulWidget {
//   final int numPages;
//   final int currentPage;

//   const Indicator({
//     super.key,
//     required this.numPages,
//     required this.currentPage,
//   });

//   @override
//   State<Indicator> createState() => _IndicatorState();
// }

// class _IndicatorState extends State<Indicator> {
//   List<Widget> _buildPageIndicator() {
//     List<Widget> list = [];
//     for (int i = 0; i < widget.numPages; i++) {
//       list.add(i == widget.currentPage ? _indicator(true) : _indicator(false));
//     }
//     return list;
//   }

//   Widget _indicator(bool isActive) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 150),
//       margin: const EdgeInsets.symmetric(horizontal: 8.0),
//       height: AppHeight.h8,
//       width: AppWidth.w10,
//       decoration: BoxDecoration(
//         color: isActive ? const Color(0xFF0AEF7C) : const Color(0xFFe9e9e9),
//         borderRadius: BorderRadius.all(Radius.circular(AppSize.s12)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: _buildPageIndicator(),
//     );
//   }
// }

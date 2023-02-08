import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderNowScreen extends StatelessWidget {
  final List<Map<String, dynamic>>? selectedCartListItemsInfo;
  final double? totalAmount;
  final List<int>? selectedCartIDs;

  const OrderNowScreen({
    super.key,
    this.selectedCartListItemsInfo,
    this.totalAmount,
    this.selectedCartIDs,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

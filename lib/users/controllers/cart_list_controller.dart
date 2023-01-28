
import 'package:clothes_app/users/models/cart_model.dart';
import 'package:get/get.dart';

class CartListController extends GetxController{
  final RxList<Cart> _cartList = <Cart>[].obs;
  final RxList<int> _selectedItems = <int>[].obs;
  final RxBool _isSelectedAllItems = false.obs;
  final RxDouble _total = 0.0.obs;


  List<Cart> get cartList => _cartList.value;
  List<int> get selectedItemsList => _selectedItems.value;
  bool get isSelectedAllItems => _isSelectedAllItems.value;
  double get total => _total.value;

  setCartList(List<Cart> list){
    _cartList.value = list;
  }

  setAddSelected(int selectedItemId){
    _selectedItems.value.add(selectedItemId);
    update();
  }

  setDeleteItem(int selectedItemId){
    _selectedItems.value.remove(selectedItemId);
    update();
  }

  setIsSelectedAllItems(){
    // !false = true
    _isSelectedAllItems.value = !_isSelectedAllItems.value;
  }

  setClearAllSelectedItems(){
    _selectedItems.value.clear();
    update();
  }

  setTotal(double overallTotal){
    _total.value = overallTotal;
  }

}
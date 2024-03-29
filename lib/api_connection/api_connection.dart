class API {
  // Get IP from terminal ipconfig
  static const hostConnect = "http://192.168.8.100/api_clothes_store/";
  static const hostConnectUser = "$hostConnect/user/";
  static const hostConnectAdmin = "$hostConnect/admin/";
  static const hostItems = "$hostConnect/items/";
  static const hostClothes = "$hostConnect/clothes/";
  static const hostCart = "$hostConnect/cart/";
  static const hostFavorite = "$hostConnect/favorite/";
  static const hostOrder = "$hostConnect/order/";
  static const hostImages = "$hostConnect/transactions_proof_images/";

  //===========================================================
  //        For User
  //===========================================================

  // Email Validattion
  static const validateEmail = "$hostConnectUser/validate_email.php";

  // Signup user
  static const signup = "$hostConnectUser/signup.php";

  // Login User
  static const login = "$hostConnectUser/login.php";

  //===========================================================
  //        For Admin
  //===========================================================

  // Login Admin
  static const loginAdmin = "$hostConnectAdmin/login.php";
  static const receivedOrdersAdmin = "$hostConnectAdmin/read_orders.php";


  //===========================================================
  //        For Items
  //===========================================================

  // Upload Items
  static const uploadItems = "$hostItems/upload.php";

  // Search Items
  static const searchItems = "$hostItems/search.php";

  //===========================================================
  //        For Clothes
  //===========================================================

  // Popular Clothes
  static const getTrendingClothes = "$hostClothes/trending_clothes.php";

  // All New Collection
  static const getAllNewClothesCollection = "$hostClothes/all_new_clothes.php";



  //===========================================================
  //        For Cart
  //===========================================================

  // Add in Cart
  static const addToCart = "$hostCart/add.php";

  // Read from Cart
  static const getCartList = "$hostCart/read.php";

  // Delete from Cart
  static const deleteSelectedItemsFromCart = "$hostCart/delete.php";

  // Update Cart
  static const updateSelectedItemsQuantityInCart = "$hostCart/update.php";


  //===========================================================
  //        For Favorite
  //===========================================================

  // Add in Favorite
  static const addFavorite = "$hostFavorite/add.php";

  // Delete from Favorite
  static const deleteFromFavorite = "$hostFavorite/delete.php";

  // Validate Favorite
  static const validateFavorite = "$hostFavorite/validate_favorite.php";

  // Read Favorite
  static const readFavorite = "$hostFavorite/read.php";


  //===========================================================
  //        For Order
  //===========================================================

  // Add Order
  static const addOrder = "$hostOrder/add.php";

  // Read Orders
  static const getOrders = "$hostOrder/read.php";

  // Read Orders
  static const getOrdersHistory = "$hostOrder/read_history.php";

  // Update Order Status
  static const updateOrderStatus = "$hostOrder/update.php";

}

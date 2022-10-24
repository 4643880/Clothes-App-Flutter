class API {
  // Get IP from terminal ipconfig
  static const hostConnect = "http://192.168.196.180/api_clothes_store/";
  static const hostConnectUser = "$hostConnect/user/";
  static const hostConnectAdmin = "$hostConnect/admin/";

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

}
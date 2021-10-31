class Constants {
  static final instance = Constants();
  //
  var id_key = "id";
  var fname_key = "fname";
  var lname_key = "lname";
  var phone_key = "phone";
  var email_key = "email";
  var address_key = "institution";
  var photo_key = "photo";
  var verificationId_key = "verificationId";
  var registration_key = "isRegistration";
  var login_key = "isLoggedin";
  var verificationKey = "isVerified";
  var authTypeKey = "authTypeKey";
  var tokenKey = "tokenKey";

  var platformKey = "platformKey";

  var genericError = "An Error Has Occured!";
  var internetError = "No Internet Found!";
  var dataError = "No Data Found!";
  var genericSuccess = "Success!";
//
  static const Pattern emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
}

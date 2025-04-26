// class Util {
//   // static final String BASE_URL = "http://192.168.0.11:5001/api/client/";
//   // static final String BASE_URL1 = "http://192.168.0.11:5001/api/list/";
//
//
//   // static final String Main_BasrUrl = "https://app.rmpro.in/backend";
//   static final String Main_BasrUrl = "https://app.rmpro.in/backend";
//   static final String Url = "https://app.rmpro.in";
//   static final String Url_kyc = "https://app.rmpro";
//   static final String Local_Url = "http://192.168.0.11:5001";
//
//   static final String BASE_URL = "$Main_BasrUrl/api/client/";
//   static final String BASE_URL1 = "$Main_BasrUrl/api/list/";
//
//
//
//   static final String Register_Api = BASE_URL + "add";
//   static final String Login_Api = BASE_URL + "login";
//   static final String Forgotpassword_Api = BASE_URL + "forgot-password";
//   static final String resetPassword_Api = BASE_URL + "reset-password";
//   static final String Profile_Api = BASE_URL + "detail";
//   static final String Slider_Api = BASE_URL1 + "banner";
//   static final String SubscriptionsPlan_Api = BASE_URL1 + "planbycategory";
//   static final String MySubscriptions_Api = BASE_URL1 + "myplan";
//   static final String Blogs_Api = BASE_URL1 + "blogspagination";
//   static final String News_Api = BASE_URL1 + "news";
//   static final String Faq_Api = BASE_URL1 + "faq";
//   static final String PrivacyPolicy_Api = BASE_URL1;
//   static final String TermsCondition_Api = BASE_URL1;
//   static final String DeleteAccount_Api = BASE_URL + "deleteclient";
//   static final String Signal_Api = BASE_URL1 + "signalclient";
//   static final String AddRequest_Api = BASE_URL1 + "addrequest";
//   static final String Close_Signal_Api = BASE_URL1 + "closesignalclient";
//   static final String AllCoupons_Api = BASE_URL1 + "coupon";
//   static final String Basket_Api = BASE_URL1 + "basket";
//   static final String ChangePassword_Api = BASE_URL + "change-password";
//   static final String SignalTabs_Api = BASE_URL1 + "service";
//   static final String ApplyCoupon_Api = BASE_URL1 + "applycoupon";
//   static final String AddPlansSubscription_Api = BASE_URL1 + "addplansubscription";
//   static final String AddBasketSubscription_Api = BASE_URL1 + "addbasketsubscription";
//   static final String RequestPayout_Api = BASE_URL + "requestpayout";
//   static final String ReferEarn_Api = BASE_URL + "referearn";
//   static final String PayoutHistory_Api = BASE_URL + "payoutlist";
//   static final String Broadcast_Api = BASE_URL + "broadcast";
//
// }

class Util {

  static String _BaseUrl = "https://stockboxpnp.pnpuniverse.com";

  // Method to update BaseUrl at runtime
  static void updateBaseUrl(String newUrl) {
    _BaseUrl = newUrl;
  }

  static String get BaseUrl => _BaseUrl;
  static String get Main_BasrUrl => "$BaseUrl/backend";
  static String get Url => BaseUrl;

  static String get Url_kyc {
    try {
      Uri uri = Uri.parse(BaseUrl);
      List<String> parts = uri.host.split('.');
      if (parts.length >= 2) {
        // Remove last segment like .com, .in, .net, etc.
        parts.removeLast();
        String newHost = parts.join('.');
        return "${uri.scheme}://$newHost";
      } else {
        return BaseUrl; // fallback
      }
    } catch (e) {
      return BaseUrl; // fallback
    }
  }


  static String get Local_Url => "http://192.168.0.11:5001";
  static String get BASE_URL => "$Main_BasrUrl/api/client/";
  static String get BASE_URL1 => "$Main_BasrUrl/api/list/";


  static String get Register_Api => BASE_URL + "add";
  static String get Login_Api => BASE_URL + "login";
  static String get Forgotpassword_Api => BASE_URL + "forgot-password";
  static String get resetPassword_Api => BASE_URL + "reset-password";
  static String get Profile_Api => BASE_URL + "detail";
  static String get State_Api => BASE_URL1 + "getstates";
  static String get City_Api => BASE_URL1 + "getcitybystates";
  static String get Slider_Api => BASE_URL1 + "banner";
  static String get SubscriptionsPlan_Api => BASE_URL1 + "planbycategory";
  static String get MySubscriptions_Api => BASE_URL1 + "myplan";
  static String get Blogs_Api => BASE_URL1 + "blogspagination";
  static String get News_Api => BASE_URL1 + "news";
  static String get Faq_Api => BASE_URL1 + "faq";
  static String get PrivacyPolicy_Api => BASE_URL1;
  static String get TermsCondition_Api => BASE_URL1;
  static String get DeleteAccount_Api => BASE_URL + "deleteclient";
  static String get Signal_Api => BASE_URL1 + "signalclient";
  static String get AddRequest_Api => BASE_URL1 + "addrequest";
  static String get Close_Signal_Api => BASE_URL1 + "closesignalclient";
  static String get AllCoupons_Api => BASE_URL1 + "coupon";
  static String get Basket_Api => BASE_URL1 + "basket";
  static String get ChangePassword_Api => BASE_URL + "change-password";
  static String get SignalTabs_Api => BASE_URL1 + "service";
  static String get ApplyCoupon_Api => BASE_URL1 + "applycoupon";
  static String get AddPlansSubscription_Api => BASE_URL1 + "addplansubscription";
  static String get AddBasketSubscription_Api => BASE_URL1 + "addbasketsubscription";
  static String get RequestPayout_Api => BASE_URL + "requestpayout";
  static String get ReferEarn_Api => BASE_URL + "referearn";
  static String get PayoutHistory_Api => BASE_URL + "payoutlist";
  static String get Broadcast_Api => BASE_URL + "broadcast";

}

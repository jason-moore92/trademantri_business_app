import 'package:intl/intl.dart';

class AppConfig {
  static double mobileDesignWidth = 411.43;
  static double mobileDesignHeight = 813.43;

  // support
  static String appStoreId = "1591157360";
  static String appStoreLink = "https://www.apple.com/app-store/";
  static String playStoreLink = "https://play.google.com/store/apps/details?id=com.tradilligence.tradeMantriBiz";
  static String forgotPasswordLink = "auth/forgot-password";
  static String disclaimerDocLink = "https://tm-legal-docs.s3.ap-south-1.amazonaws.com/TM-DISCLAIMER.pdf";
  static String privacyDocLink = "https://tm-legal-docs.s3.ap-south-1.amazonaws.com/TM-PRIVACY+POLICY.pdf";
  static String termsDocLink = "https://tm-legal-docs.s3.ap-south-1.amazonaws.com/TM-Terms%26Conditions.pdf";
  static String kycDocHelpLink = "https://tm-store-kyc-docs-bucket.s3.ap-south-1.amazonaws.com/KYC-Documents-Help.pdf";
  static double companyLatitude = 17.4520399;
  static double companyLongitude = 78.3894064;
  static String supportEmail = "info@trademantri.com";
  static String companyName = "TradeMantri";
  static String companyAddress = "Quixtart Business Center , 4th Floor, Plot 532 100 Feet Road, Ayyappa Society";
  static String companyArea = "Madhapur";
  static String companyCity = "Hyderabad";
  static String companyState = "Telangana";
  static String companyZip = "500081";
  //////////////////////////////////////////////////

  ///
  static int supportRepeatCount = 3;
  static int countLimitForList = 10;

  static int deliveryDistance = 10;
  static List<dynamic> distances = [
    {"text": "10Km", "value": 10},
    {"text": "20Km", "value": 20},
    {"text": "25Km", "value": 25},
    {"text": "50Km", "value": 50}
  ];
  static List<String> serviceProvidedList = ["Hourly", "Half Day", "Daily", "Monthly", "Yearly", "On Request"];
  static List<String> deliveryAddressType = ["Home", "Office", "Others"];
  static List<dynamic> tipData = ["no", 5, 7, 10, 15, 20, 25, "Custom"];
  static List<dynamic> quantityTypeList = ["Kgs", "Grams", "Units", "Liters", "ML", "Tons"];

  static Map<String, dynamic> deliveryPrice = {
    "initialDistance": 6,
    "initialPrice": 40,
    "additionalDistance": 0.2,
    "additionalPrice": 1,
  };

  static List<dynamic> transactionStatusData = [
    {"id": "unsettled", "name": "Unsettled"},
    {"id": "settled", "name": "Settled"},
  ];

  static List<dynamic> orderStatusData = [
    {"id": "all", "name": "ALL"},
    {"id": "order_placed", "name": "New Orders"},
    {"id": "order_accepted", "name": "Accepted"},
    {"id": "order_paid", "name": "Paid"},
    {"id": "pickup_ready", "name": "PickUp ready"},
    {"id": "delivery_ready", "name": "Delivery ready"},
    {"id": "delivered", "name": "Delivered"},
    {"id": "order_cancelled", "name": "Cancelled"},
    {"id": "order_rejected", "name": "Rejected"},
    {"id": "order_completed", "name": "Completed"},
    {"id": "all", "name": "ALL"},
  ];

  static List<dynamic> stockTypes = [
    {"value": "debit", "text": "Sell"},
    {"value": "credit", "text": "Buy"},
  ];

  static List<dynamic> bargainRequestStatusData = [
    {"id": "all", "name": "ALL"},
    {"id": "requested", "name": "Requested"},
    {"id": "counter_offer", "name": "Counter Offer"},
    {"id": "accepted", "name": "Accepted"},
    {"id": "completed", "name": "Completed"},
    {"id": "rejected", "name": "Rejected"},
    {"id": "cancelled", "name": "Cancelled"},
  ];

  static List<dynamic> bargainSubStatusData = [
    {"id": "new_requested", "name": "New Requested"},
    {"id": "user_counter_offer", "name": "User Counter Offer"},
    {"id": "store_count_offer", "name": "Store Counter Offer"},
  ];

  static List<dynamic> reverseAuctionStatusData = [
    {"id": "all", "name": "ALL"},
    {"id": "requested", "name": "Bid Request"},
    {"id": "store_offer", "name": "Store Offer"},
    {"id": "cancelled", "name": "Cancelled"},
    {"id": "accepted", "name": "Accepted"},
    {"id": "past", "name": "Old Auctions"},
  ];

  static Map<String, dynamic> bargainHistoryData = {
    "requested": {
      "title": "New Bargain Request",
      "text": "A new bargain request has been made by userName to the store storeName",
    },
    "store_count_offer": {
      "title": "Counter offer from store",
      "text": "A counter offer has been made by store storeName to the userName bargain request",
    },
    "user_counter_offer": {
      "title": "Counter offer from User",
      "text": "A counter bargain request has been made by userName to the store storeName",
    },
    "accepted": {
      "title": "Bargain Request accepted",
      "text": "This bargian request was accepted by store storeName",
    },
    "rejected": {
      "title": "Bargain Request rejected",
      "text": "This bargian request was rejected by store storeName",
    },
    "cancelled": {
      "title": "Bargain Request cancelled",
      "text": "This bargian request was cancelled by userName",
    },
    "quantity_updated": {
      "title": "Bargain Request Quantity Updated",
      "text": "Store updated the quantity of bargain request from initial_value to updated_value",
    }
  };

  static Map<String, dynamic> notificationStatusData = {
    "action": "Action",
    "bargain": "Bargain",
    "chats": "Chats",
    "discounts": "Discounts",
    "jobs": "Jobs",
    "order": "Order",
    "profile": "Profile",
    "reward_points": "Reward Points",
  };

  static String storeType = "Retailer,Wholesaler,Service,Distributor,Manufacturer";

  static List<dynamic> taxValues = [
    {"text": "No Tax", "value": 0},
    {"text": "5%", "value": 5},
    {"text": "12%", "value": 12},
    {"text": "18%", "value": 18},
    {"text": "28%", "value": 28}
  ];

  static List<dynamic> taxTypes = [
    {"text": "TaX Inclusive", "value": "Inclusive"},
    {"text": "Tax Exclusive", "value": "Exclusive"},
  ];

  static String encryptKeyString = "	Ïx_ü6H1Ãjº¤_ã«";

  static Map<String, dynamic> initialSettings = {
    "notification": true,
    "bargainEnable": true,
    "bargainOfferPricePercent": 40.0,
  };

  static List<dynamic> orderDataFilter = [
    {"text": "Day", "value": "day"},
    {"text": "Week", "value": "week"},
    {"text": "Month", "value": "month"},
  ];

  static String letterSampleDoc = "https://tm-legal-docs.s3.ap-south-1.amazonaws.com/Letter+of+Undertaking.pdf";

  static Map<String, dynamic> orderCategories = {
    "cart": "Cart",
    "assistant": "Assistant",
    "reverse_auction": "Reverse Auction",
    "bargain": "Bargain",
  };

  static List<dynamic> attributesTypes = [
    "Color",
    "Size",
    "Weight",
  ];

  static List<dynamic> salaryType = [
    {"text": "Hourly", "value": "Hourly"},
    {"text": "Daily", "value": "Daily"},
    {"text": "Weekly", "value": "Weekly"},
    {"text": "Monthly", "value": "Monthly"},
    {"text": "Yearly", "value": "Yearly"},
  ];

  static List<dynamic> jobStatusType = [
    {"text": "Open", "value": "open"},
    {"text": "Paused", "value": "paused"},
    {"text": "Closed", "value": "closed"},
  ];

  static List<dynamic> appliedJobStatusType = [
    {"text": "Applied", "id": "applied"},
  ];

  static List<dynamic> appliedJobApprovalStatusType = [
    {"text": "Not Viewed", "id": ""},
    {"text": "Viewed", "id": "viewed"},
    {"text": "Accepted", "id": "accepted"},
    {"text": "Rejected", "id": "rejected"},
  ];

  static List<dynamic> discountTypeForCoupon = [
    {"text": "Percentage", "value": "PERCENTAGE"},
    {"text": "Fixed amount", "value": "FIXED_AMOUNT"},
    // {"text": "Free Shipping", "value": "Free Shipping"},
    {"text": "Buy X Get Y", "value": "BOGO"},
  ];

  static List<dynamic> discountBuyValueForCoupon = [
    {"text": "Free", "value": "Free"},
    {"text": "Percentage", "value": "Percentage"},
  ];

  static List<dynamic> appliesToForCoupon = [
    {"text": "Entire Order", "value": "Entire_Order"},
    {"text": "Specific Categories", "value": "Categories"},
    {"text": "Specific Products", "value": "Items"},
  ];

  static List<dynamic> minRequirementsForCoupon = [
    {"text": "None", "value": "None"},
    {"text": "Minimum purchase amount", "value": "Purchase_Amount"},
    {"text": "Minimum quantity", "value": "Purchase_Quantity"},
  ];

  static List<dynamic> customerEligibilityForCoupon = [
    {"text": "Everyone", "value": "Everyone"},
    {"text": "Specific Customers", "value": "Specific_Customers"},
  ];

  static List<dynamic> businessEligibilityForCoupon = [
    {"text": "Everyone", "value": "Everyone"},
    {"text": "Specific Businesses", "value": "Specific_Businesses"},
  ];

  static List<dynamic> eligibilityForCoupon = [
    {"text": "Customer coupon", "value": "for_customer"},
    {"text": "Business B2B coupon", "value": "for_business"},
  ];

  static List<dynamic> usageLimitsForCoupon = [
    {"text": "Unlimited", "value": "Unlimited"},
    {"text": "Limit number of times this discount can be used in total", "value": "Number_Limit"},
    {"text": "Limit to one use per customer", "value": "One_Per_Customer"},
  ];

  static Map<String, dynamic> discountTypeImages = {
    "PERCENTAGE": "https://tm-coupons-bucket.s3.ap-south-1.amazonaws.com/Coupons/percentage-discount-default.png",
    "FIXED_AMOUNT": "https://tm-coupons-bucket.s3.ap-south-1.amazonaws.com/Coupons/rupee-discount-default.png",
    "BOGO": "https://tm-coupons-bucket.s3.ap-south-1.amazonaws.com/Coupons/bogo-coupon-default.png",
  };

  static List<dynamic> announcementTo = [
    {"text": "Post to All Customers", "value": "CUSTOMERS_ONLY"},
    {"text": "Post to All Business", "value": "BUSINESS_ONLY"},
  ];

  static List<dynamic> announcmentType = [
    {"value": "BASIC"},
    {"value": "BASIC_WITH_COUPON"}
  ];

  static List<dynamic> announcementImage = [
    "https://tm-announcements-bucket.s3.ap-south-1.amazonaws.com/announcements/announcements-default.png",
  ];

  static Map<String, dynamic> purchaseItemStatus = {
    "open": "Open",
    "close": "Close",
    "reject": "Reject",
    "fullfilled": "FullFilled",
  };

  static List<dynamic> purchaseStatusData = [
    {"id": "sent", "name": "Sent"},
    {"id": "received", "name": "Received"},
  ];

  static List<dynamic> b2bOrderStatusData = [
    {"id": "all", "name": "ALL"},
    {"id": "order_accepted", "name": "Accepted"},
    {"id": "order_paid", "name": "Paid"},
    {"id": "pickup_ready", "name": "PickUp ready"},
    {"id": "delivery_ready", "name": "Delivery ready"},
    {"id": "delivery_start", "name": "Delivery Start"},
    {"id": "delivered", "name": "Delivered"},
    {"id": "order_completed", "name": "Completed"},
    {"id": "order_cancelled", "name": "Cancelled"},
    {"id": "order_rejected", "name": "Rejected"},
  ];

  static List<dynamic> deliveryChargeType = [
    {"text": "Flat Rate", "value": "PER_DELIVERY"},
    {"text": "Per KM", "value": "PER_KM"},
    {"text": "Free", "value": "Free"},
  ];

  static double galleryImageLimitSize = 5; // Mbyte
  static double galleryVideoLimitSize = 150; // Mbyte

  static List<String> timeSlotList = ["15", "30", "45", "60"];

  static List<dynamic> bookAppointmentStatus = [
    {"id": "all", "name": "ALL"},
    // {"id": "created", "name": "Created"},
    {"id": "accepted", "name": "Accepted"},
    {"id": "rejected", "name": "Rejected"},
    {"id": "cancelled", "name": "Cancelled"},
    {"id": "past", "name": "Past"},
  ];

  static DateFormat dateFormatter = new DateFormat("yyyy-MM-dd");

  static int establishedYear = 2016;
}

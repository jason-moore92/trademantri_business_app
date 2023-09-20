import 'dart:io';

class KYCDocsPageString {
  static String appbarTitle = "KYC Documents";
  static String description1 = "Telecom regulation in india obligate us to keey your KYC documents.";
  static String description2 = " Learn More ";
  static String description3 = "about what documents you can submit. Make sure flash is installed and popups are not blocked.";
  static String choose = "Please choose a document file";
  static String letterOfUndertakingDesc1 = "*  Download ";
  static String letterOfUndertakingDesc2 = "sample";
  static String letterOfUndertakingDesc3 = " file, Fill the detail and Upload it";
  static Map<String, dynamic> documentType = {
    "panCard": {
      "title": "Store Owner PAN or Aadhar Card",
      "fileName": "panCard",
      "path": "",
      "status": "No uploaded",
    },
    "certification": {
      "title": "Certificate of Incorporation",
      "fileName": "certification",
      "path": "",
      "status": "No uploaded",
    },
    "addressProof": {
      "title": "Company Address Proof",
      "fileName": "address",
      "path": "",
      "status": "No uploaded",
    },
    "passport": {
      "title": "Store Owner Passport Size Photo",
      "fileName": "passport",
      "path": "",
      "status": "No uploaded",
    },
    "letterOfUndertaking": {
      "title": "Letter of Undertaking",
      "fileName": "letterOfUndertaking",
      "path": "",
      "status": "No uploaded",
    },
  };

  static String upload = "Upload";
  static String select = "Choose a File";
}

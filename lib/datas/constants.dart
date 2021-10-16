const String smsUrl = "https://verify.smspoh.com/api/";
const String token =
    "VcDFsbOAZ3xpFVql7yLczsbAZmihyV9eZnUBdJHiz6-4k7_ggfNVllQxie5gEPMc";
const String smsToken =
    "SzhDl_-ytQEe2tTnRdg2UW4U7rFIbMmonUUQF8uJ1nAVxH5D08vNz8X_vA5TBLR1";
const String backendUrl = "https://api.thai2d3d.com/api";
const String version = "1.2.1";

Future<Map<String, String>> getHeaders() async {
  //timezone
  try {
    var headers = <String, String>{
      "content-type": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Access-Control-Allow-Credentials': 'true',
      "Access-Control-Allow-Methods": "GET, POST, PATCH, PUT, DELETE, OPTIONS",
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "apikey": "5b927b5a7f672",
      "app": "App",
      "version": version,
      "language": "en",
      // "Authorization": sysData.token == "" ? "" : "Bearer " + sysData.token,
    };
    return headers;
  } catch (ex) {
    var headers = <String, String>{
      "content-type": "application/json",
      "Access-Control-Allow-Origin": "*",
      'Access-Control-Allow-Credentials': 'true',
      "Access-Control-Allow-Methods": "GET, POST, PATCH, PUT, DELETE, OPTIONS",
      "Access-Control-Allow-Headers":
          "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "apikey": "5b927b5a7f672",
      "app": "App",
      "version": version,
      "language": "my",
      "Authorization": "",
    };
    return headers;
  }
}

Future<Map<String, String>> getHeadersWithOutToken() async {
  //timezone
  try {
    var headers = <String, String>{
      "content-type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET, POST, PATCH, PUT, DELETE, OPTIONS",
      "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
    };
    return headers;
  } catch (ex) {
    var headers = <String, String>{
      "content-type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET, POST, PATCH, PUT, DELETE, OPTIONS",
      "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
    };
    return headers;
  }
}

const String userCollection = "users";
const String transactions = "transactions";
const String notifications = "notifications";

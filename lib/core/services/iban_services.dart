import 'package:sevenapplication/utils/const_app.dart';
import 'package:http/http.dart' as http;

class IbanServices {
  static Future<void> ibanValidate(String iban) async {
    var apiURL = "https://api.ibanapi.com/v1/validate";
    var request = http.MultipartRequest('POST', Uri.parse(apiURL));
    request.fields.addAll({'iban': iban, 'api_key': ConstApp.ibanAPIKey});
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}

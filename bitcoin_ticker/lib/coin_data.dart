import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR',
  'NGN'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = 'C1B63352-74DF-4CA7-8F11-874E63F91FE3';


class CoinData {

  Future getCoinData({required String currency}) async {

    String requestUrl = '$coinAPIURL/BTC/$currency?apikey=$apiKey';
    http.Response response = await http.get(Uri.parse(requestUrl),);

    if(response.statusCode == 200) {
      String data = response.body;

      var decodedData = jsonDecode(data);
      var lastPrice = decodedData['rate'];
      return lastPrice;
    } else  {
      print(response.statusCode);
      throw 'Error with get request!';
    }
  }
}
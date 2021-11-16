import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = 'AUD';

  // Getting data for an android drop down list
  DropdownButton<String> androidDropDownButton() {
    List<DropdownMenuItem<String>> items = [];
    for(String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      items.add(newItem);
    }
     return DropdownButton<String>(
         value: selectedCurrency,
         items: items,
         onChanged: (value) {
           setState(() {
             if (value != null) {
               selectedCurrency = value;
             }
           });
         });
  }

  // Getting data for an iOS cupertino picker
  CupertinoPicker iOSPicker() {
    List<Text> items = [];
    for(String currency in currenciesList) {
      items.add(
          Text(
              currency,
            style: TextStyle(
              color: Colors.white,
            ),
          )
      );
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (int selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      children: items,
    );
  }

  Map<String, String> coinValues = {};
  Future getData() async {
    try {
      var data = await CoinData().getCoinData(currency: selectedCurrency);
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CryptoCard(
            value: coinValues['BTC'] ?? '?',
            selectedCurrency: selectedCurrency,
            cryptoCurrency: cryptoList[0],
          ),

          CryptoCard(
            value: coinValues['ETH'] ?? '?',
            selectedCurrency: selectedCurrency,
            cryptoCurrency: cryptoList[1],
          ),

          CryptoCard(
            value: coinValues['LTC'] ?? '?',
            selectedCurrency: selectedCurrency,
            cryptoCurrency: cryptoList[2],
          ),
          Spacer(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropDownButton(),
            ),
        ],
      ),
    );
  }
}



class CryptoCard extends StatelessWidget {
  const CryptoCard({
    Key? key,
    required this.value,
    required this.selectedCurrency,
    required this.cryptoCurrency,
  }) : super(key: key);

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

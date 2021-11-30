import 'dart:convert';

import 'package:credit_card_project/animated_route.dart';
import 'package:credit_card_project/models/creditcard_model.dart';
import 'package:credit_card_project/models/fromHex.dart';
import 'package:credit_card_project/views/authentication.dart';
import 'package:credit_card_project/views/camera_view.dart';
import 'package:flutter/material.dart';

import 'models/user_model.dart';
import 'package:http/http.dart' as http;

class CreditCardsPage extends StatefulWidget {

  final User user;
  const CreditCardsPage({Key key,this.user}) : super(key: key);

  @override
  State<CreditCardsPage> createState() => _CreditCardsPageState();
}

class _CreditCardsPageState extends State<CreditCardsPage> {

  bool isLoading = false;

  AnimatedRoute ar = AnimatedRoute();

  CreditCardModel card1 = CreditCardModel(
      color: Color(0xFF090943),
      cardNumber: "3546 7532 XXXX 9742",
      cardHolder: "HOUSSEM SELMI",
      cardExpiration: "05/2024",
  );

  List<CreditCardModel> cards = [];
  @override
  void initState() {
    cards.add(card1);
    setState(() {
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleSection(title: "Payment Details",
              subTitle: "How would you like to pay ?"),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    return  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: _buildCreditCard(
                          cardNumber: cards[index].cardNumber,
                          cardHolder: cards[index].cardHolder,
                          color:  cards[index].color,
                          cardExpiration: cards[index].cardExpiration
                      ),
                    );
                  },
                ),
              ),
              _buildAddCardButton(
                icon: Icon(Icons.add),
                color: Color(0xFF081603),
              )
            ],
          )
        ),
      ),
    );
  }

  // Build the title section
  Row _buildTitleSection({@required title, @required subTitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 16.0),
              child: Text(
                '$title',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
              child: Text(
                '$subTitle',
                style: TextStyle(fontSize: 21, color: Colors.black45),
              ),
            )
          ],
        ),
          MaterialButton(
            onPressed: () {
              Navigator.pushReplacement(context, ar.createRoute(AuthenticationPage(), true));
            },
            minWidth: 30,
          child: Text("Logout", textAlign: TextAlign.center,style: TextStyle(fontSize: 21,),
          ),
        )
      ],
    );
  }

  // Build the credit card widget
  Card _buildCreditCard(
      {@required Color color,
      @required String cardNumber,
      @required String cardHolder,
      @required String cardExpiration}) {
    return Card(
      elevation: 4.0,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        height: 200,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildLogosBlock(),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                '$cardNumber',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontFamily: 'CourrierPrime'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildDetailsBlock(
                  label: 'CARDHOLDER',
                  value: cardHolder,
                ),
                _buildDetailsBlock(label: 'VALID THRU', value: cardExpiration),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build the top row containing logos
  Row _buildLogosBlock() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Image.asset(
          "assets/images/contact_less.png",
          height: 20,
          width: 18,
        ),
        Image.asset(
          "assets/images/mastercard.png",
          height: 50,
          width: 50,
        ),
      ],
    );
  }

// Build Column containing the cardholder and expiration information
  Column _buildDetailsBlock({@required String label, @required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$label',
          style: TextStyle(
              color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
        ),
        Text(
          '$value',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

// Build the FloatingActionButton
  Container _buildAddCardButton({
    @required Icon icon,
    @required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      alignment: Alignment.center,
      child: isLoading ? CircularProgressIndicator() : FloatingActionButton(
        elevation: 2.0,
        onPressed: () async {
            isLoading = true;
            setState(() {
            });
            Navigator.push(context, ar.createRoute(CameraView(), false));
            cards.add(await generateCC());
            setState(() {
             isLoading = false;
           });
          },
        backgroundColor: color,
        mini: false,
        child: icon,
      ),
    );
  }

  Future<CreditCardModel> generateCC() async
  {
    Uri ccURL = Uri.parse("https://random-data-api.com/api/business_credit_card/random_card");
    Uri nameURL = Uri.parse("https://random-data-api.com/api/name/random_name");
    Uri colorURL = Uri.parse("https://random-data-api.com/api/color/random_color");

    var response = await http.get(ccURL);
    var nameRes = await http.get(nameURL);
    var colorRes = await http.get(colorURL);

    var data = json.decode(response.body);
    var nameJson = json.decode(nameRes.body);
    var colorJson = json.decode(colorRes.body);

    String expiryDate = "${data['credit_card_expiry_date'].toString().split("-")[1]}/${data['credit_card_expiry_date'].toString().split("-")[0]}";

    return CreditCardModel(
        color: HexColor(colorJson['hex_value']),
        cardExpiration: expiryDate,
        cardHolder: nameJson['name'],
        cardNumber: data['credit_card_number'].toString().replaceAll("-", " ")
    );

  }
}

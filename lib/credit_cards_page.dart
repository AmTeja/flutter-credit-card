import 'dart:convert';

import 'package:credit_card_project/animated_route.dart';
import 'package:credit_card_project/models/creditcard_model.dart';
import 'package:credit_card_project/models/fromHex.dart';
import 'package:credit_card_project/views/authentication.dart';
import 'package:credit_card_project/views/camera_view.dart';
import 'package:credit_card_project/views/carddetails.dart';
import 'package:flutter/material.dart';

import 'models/ccard.dart';
import 'models/user_model.dart';
import 'package:http/http.dart' as http;

class CreditCardsPage extends StatefulWidget {

  final User user;
  const CreditCardsPage({Key key,this.user}) : super(key: key);

  @override
  State<CreditCardsPage> createState() => _CreditCardsPageState();
}

class _CreditCardsPageState extends State<CreditCardsPage> {

  PageController pageController = PageController();

  bool gettingCards = false;
  bool isLoading = false;

  AnimatedRoute ar = AnimatedRoute();

  CreditCardModel card1 = CreditCardModel(
      color: Color(0xFF090943),
      cardNumber: "3546 7532 XXXX 9742",
      cardHolder: "HOUSSEM SELMI",
      cardExpiration: "05/2024",
  );

  List<CreditCardModel> cardList = [];
  @override
  void initState() {
    gettingCards = true;
    setState(() {

    });
    getCards();
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
              gettingCards ? Container(child: Center(child: CircularProgressIndicator(),),) :
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cardList.length,
                  itemBuilder: (context, index) {
                    return  Align(
                      heightFactor: 0.3,
                      alignment: Alignment.topCenter,
                      child: _buildCreditCard(
                          cardNumber: cardList[index].cardNumber,
                          cardHolder: cardList[index].cardHolder,
                          color:  cardList[index].color,
                          cardExpiration: cardList[index].cardExpiration,
                          card: cardList[index],
                      ),
                    );
                  },
                ),
              ),
              gettingCards ? Container() : _buildAddCardButton(
                icon: Icon(Icons.add, color: Color(0xFFFF63b1),),
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
  GestureDetector _buildCreditCard(
      {@required Color color,
      @required String cardNumber,
      @required String cardHolder,
      @required String cardExpiration,
      @required CreditCardModel card}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, ar.createRoute(CardView(card:  card,), false));
        },
      child: Card(
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
            await addCC();
            await getCards();
            // cardList.add(await generateCC());
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

  getCards() async
  {
    List<CreditCardModel> list = [];
    var token = widget.user.tokens.access.token.toString();
    Uri cardsURL = Uri.parse("https://flutter-assignment-api.herokuapp.com/v1/cards");

    var response = await http.get(
      cardsURL,
      headers: {
        'Content-Type': 'application/json',
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token'
      }
    );
    CCard cards = CCard.fromJson(json.decode(response.body));
    print(cards.totalResults);
    print(cards.results.length);
    try {
      for (int i = 0; i < cards.results.length; i++) {
        CreditCardModel ccm = CreditCardModel(
            color: await getRandomColor(),
            cardNumber: cards.results[i].cardNumber,
            cardHolder: cards.results[i].cardHolder,
            cardExpiration: cards.results[i].cardExpiration
        );
        list.add(ccm);
      }
      cardList = list;
    }finally {
      setState(() {
        gettingCards = false;
      });
    }
  }

  Future<Color> getRandomColor() async {
    Uri colorURL = Uri.parse("https://random-data-api.com/api/color/random_color");
    var colorRes = await http.get(colorURL);
    var colorJson = json.decode(colorRes.body);
    return HexColor(colorJson['hex_value']);
  }

  Future<void> addCC() async
  {
    Uri ccURL = Uri.parse("https://random-data-api.com/api/business_credit_card/random_card");
    Uri nameURL = Uri.parse("https://random-data-api.com/api/name/random_name");

    Uri url = Uri.parse("https://flutter-assignment-api.herokuapp.com/v1/cards");

    var ccResponse = await http.get(ccURL);
    var nameRes = await http.get(nameURL);

    var ccData = json.decode(ccResponse.body);
    var nameJson = json.decode(nameRes.body);

    var token = widget.user.tokens.access.token.toString();

    String expiryDate = "${ccData['credit_card_expiry_date'].toString().split("-")[1]}/${ccData['credit_card_expiry_date'].toString().split("-")[0]}";

    var body = {
      "name": "${nameJson['name'].toString()}'s Card",
      "cardExpiration": expiryDate,
      "cardHolder": nameJson['name'].toString(),
      "cardNumber": ccData['credit_card_number'].toString().replaceAll("-", " "),
      "category": "VISA",
    };

    var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'
        },
      body: json.encode(body),
    );
  }
}

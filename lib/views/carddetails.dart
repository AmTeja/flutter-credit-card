import 'package:credit_card_project/animated_route.dart';
import 'package:credit_card_project/credit_cards_page.dart';
import 'package:credit_card_project/models/creditcard_model.dart';
import 'package:flutter/material.dart';

class CardView extends StatefulWidget {

  final CreditCardModel card;

  const CardView({Key key, @required this.card}) : super(key: key);

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {

  AnimatedRoute ar = AnimatedRoute();

   @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: _buildCreditCard(
            color: widget.card.color,
            cardNumber: widget.card.cardNumber,
            cardExpiration: widget.card.cardExpiration,
            cardHolder: widget.card.cardHolder),
      ),
    );

  }

   Card _buildCreditCard(
       {@required Color color,
         @required String cardNumber,
         @required String cardHolder,
         @required String cardExpiration,
       }) {
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

}

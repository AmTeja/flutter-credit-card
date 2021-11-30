import 'package:credit_card_project/views/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../animated_route.dart';

class OnBoardingSlider extends StatefulWidget {
  @override
  State<OnBoardingSlider> createState() => _OnBoardingSliderState();
}

class _OnBoardingSliderState extends State<OnBoardingSlider> {

  int numOfPages = 3;
  int currentPage = 0;

  AnimatedRoute ar = AnimatedRoute();

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2c2c2c), Color(0xff000000)]
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 32),
                height: MediaQuery.of(context).size.height * 0.8,
                child: PageView(
                  controller: _pageController,
                  physics: ClampingScrollPhysics(),
                  onPageChanged: (int page) {
                    setState(() {
                      currentPage = page;
                    });
                  },
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 100,),
                        Center(
                          child: Lottie.asset("assets/lotties/cards1.json", repeat: false, fit: BoxFit.cover),
                        ),
                        SizedBox(height: 20,),
                        Text("Lorem Ipsum", style: TextStyle(color:  Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
                        SizedBox(height: 20,),
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Accumsan in nisl nisi scelerisque eu ultrices vitae auctor. Purus semper eget duis at. ",textAlign: TextAlign.center ,style: TextStyle(color: Colors.white, fontSize: 20),)
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 100,),
                        Center(
                          child: Lottie.asset("assets/lotties/cards2.json", repeat: false, fit: BoxFit.cover),
                        ),
                        Text("Lorem Ipsum", style: TextStyle(color:  Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
                        SizedBox(height: 20,),
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Accumsan in nisl nisi scelerisque eu ultrices vitae auctor. Purus semper eget duis at. ",textAlign: TextAlign.center ,style: TextStyle(color: Colors.white, fontSize: 20),)
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 60,),
                        Center(
                          child: Lottie.asset("assets/lotties/cards3.json", repeat: false, fit: BoxFit.cover),
                        ),
                        SizedBox(height: 30,),
                        Text("Lorem Ipsum", style: TextStyle(color:  Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
                        SizedBox(height: 20,),
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Accumsan in nisl nisi scelerisque eu ultrices vitae auctor. Purus semper eget duis at. ",textAlign: TextAlign.center ,style: TextStyle(color: Colors.white, fontSize: 20),)
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buildPageIndicator(),
              ),
              currentPage != numOfPages - 1 ? Expanded(
                child: Align(
                  alignment: FractionalOffset.centerRight,
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        _pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.ease);
                        currentPage++;
                      });
                    },
                    shape: StadiumBorder(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Next", textAlign: TextAlign.right,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Color(0xffff63b1)),),
                      ],
                    ),
                  ),
                ),
              ) : Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, ar.createRoute(AuthenticationPage(), false));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xffff63b1)
                              )
                            )
                          ),
                          child: Text("Get Started", style: TextStyle(color: Colors.white, fontSize: 24.9),)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildPageIndicator() {
    List<Widget> list = [];
    for(int i = 0; i < numOfPages; i++) {
        list.add(i == currentPage ? indicator(true) : indicator(false));
      }
    return list;
  }

  Widget indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Color(0xffff63b1),
          borderRadius: BorderRadius.circular(23.0)),
    );
  }
}

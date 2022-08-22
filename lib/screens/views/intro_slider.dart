import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lix/screens/views/login_view.dart';
import 'package:lix/screens/widgets/slide_1.dart';
import 'package:lix/screens/widgets/slide_2.dart';
import 'package:lix/screens/widgets/slide_3.dart';
import 'package:lix/screens/widgets/submit_button.dart';

class IntroSlider extends StatefulWidget {
  const IntroSlider({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _IntroSliderState createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
  int selectedSlide = 0;
  final PageController _pageController = PageController();
  final List<Widget> slides = [
    const Slide1(),
    const Slide2(),
    const Slide3(),
  ];
  Widget getActivePageIndicator() {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  Widget getNormalPageIndicator() {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: const Color(0xffb0cfe8).withOpacity(0.3),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  List<Widget> generatePageIndicator(int index) {
    List<Widget> widgets = <Widget>[];
    for (int i = 0; i < slides.length; i++) {
      if (index == i) {
        widgets.add(getActivePageIndicator());
      } else {
        widgets.add(getNormalPageIndicator());
      }
    }

    return widgets;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/intro_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 80,
            ),
            Column(
              children: [
                Container(
                  height: 250,
                  color: Colors.transparent,
                  alignment: Alignment.topLeft,
                  child: PageView(
                    onPageChanged: (index) {
                      setState(() {
                        selectedSlide = index;
                      });
                    },
                    controller: _pageController,
                    children: slides,
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: Row(
                    children: generatePageIndicator(selectedSlide),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SubmitButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()),
                    );
                  },
                  text: "Get Started",
                  disabled: false,
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ) /* add child content here */,
      ),
    ));
  }
}

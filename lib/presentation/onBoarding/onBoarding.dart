// import 'dart:math' as math;
// ignore_for_file: unused_import, file_names

import 'package:flutter/material.dart';

import '../../core/utils/app_values.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/reusable_widgets/main_button.dart';
import '../Home/home_screen.dart';
import 'indicator.dart';
import 'pageViewContent.dart';

//uncomment if you will add more pages in on boarding
class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({super.key});

  // final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);

  // int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: AppHeight.h550,
              child: PageView(
                physics: const ClampingScrollPhysics(),
                allowImplicitScrolling: true,
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: (int page) {
                  // setState(() {
                  //   _currentPage = page;
                  // });
                },
                children: <Widget>[
                  Pageviewcontent(
                    imagePath: 'assets/images/medcinesWithRights.png',
                    title: 'لن تفوّت أي جرعة بعد الآن',
                    subTitle:
                        'حافظ على انتظامك في تناول الدواء من خلال تذكيرات ذكية ودقيقة',
                    widgetChild: Column(
                      children: [
                        SizedBox(height: AppHeight.h20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'نظّم أدويتك بدقّة وسهولة',
                              style: TextStyle(fontSize: FontSize.s20),
                            ),
                            Icon(Icons.check_circle, color: mainColor),
                          ],
                        ),
                        SizedBox(height: AppHeight.h10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'تابع التزامك الصحي باستمرار',
                              style: TextStyle(fontSize: FontSize.s20),
                            ),
                            Icon(Icons.calendar_month_sharp, color: mainColor),
                          ],
                        ),
                        SizedBox(height: AppHeight.h10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'ذكّر نفسك بالدواء في الوقت المناسب',
                              style: TextStyle(fontSize: FontSize.s20),
                            ),
                            Icon(
                              Icons.notifications_active_rounded,
                              color: mainColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Pageviewcontent(
                  //   imagePath: 'assets/images/busLoc.jpg',
                  //   title: 'Track your bus in real-time',
                  //   subTitle:
                  //       'See exactly where your bus is and when it will arrive, saving your time.',
                  // ),
                  // Pageviewcontent(
                  //   imagePath: 'assets/images/busCommunity.jpg',
                  //   title: 'Commuinty-powered Accuracy',
                  //   subTitle:
                  //       'join a network of commuters sharing real time bus updates. Your contributions help everyone stay informed and on shedule.',
                  // ),
                ],
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Indicator(
            //       numPages: _numPages,
            //       currentPage: _currentPage,
            //     ), //indicator widget
            //   ],
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSize.s1,
          AppSize.s1,
          AppSize.s1,
          AppSize.s60,
        ),
        child: SizedBox(
          height: AppHeight.h50,
          width: AppWidth.w200,
          child: MainButton(
            buttonColor: mainColor,
            text: 'ابدء الان',
            textColor: Colors.black,
            height: AppHeight.h50,
            radius: AppSize.s10,
            width: double.infinity,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Homescreen()),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:spin/controllers/homeControllers/homeController.dart';
import 'package:spin/screens/widgets/indicator_painter_widget.dart';
import 'package:spin/screens/widgets/winner_widget.dart';
import 'package:toastification/toastification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamController<int> selected = StreamController<int>.broadcast();
  late ConfettiController _centerController;

  Homecontroller homecontroller = Get.put(Homecontroller());
  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    homecontroller.fetchDepartments(context);

    _centerController =
        ConfettiController(duration: const Duration(seconds: 10));
    super.initState();
  }

  bool canSpin = false;

  @override
  Widget build(BuildContext context) {
    bool flag = false;
    return PopScope(
      canPop: false,
      child: Scaffold(body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Obx(() {
                return Column(
                  children: [
                    appLogo(screenWidth, screenHeight),
                    departmentSelection(screenWidth, screenHeight, context),
                    Expanded(
                      child: homecontroller.dropdownValue.value ==
                                  "Choose Department" &&
                              homecontroller.dropdownValue.value == ''
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(screenHeight * 0.10),
                                child: Image(
                                    height: screenHeight,
                                    width: screenWidth,
                                    fit: BoxFit.contain,
                                    image: AssetImage(
                                        'assets/images/no_image.png')),
                              ),
                            )
                          : Obx(() {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  homecontroller.isLoadingEmployees.value
                                      ? Padding(
                                          padding: EdgeInsets.all(
                                              screenHeight / 2 * 0.02),
                                          child: Lottie.asset(
                                            'assets/animations/loader.json',
                                            height: screenHeight / 2,
                                            width: screenWidth / 2,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      : homecontroller.employeeList.length > 1
                                          ? spinnerWidget(screenWidth,
                                              screenHeight, flag, context)
                                          : Padding(
                                              padding: EdgeInsets.all(
                                                  screenHeight / 2 * 0.02),
                                              child: Image(
                                                  height: screenHeight / 2,
                                                  width: screenWidth / 2,
                                                  fit: BoxFit.contain,
                                                  image: AssetImage(
                                                      'assets/images/no_image.png')),
                                            ),
                                  contentWidget(
                                      screenWidth, flag, screenHeight),
                                ],
                              );
                            }),
                    ),
                  ],
                );
              }),
            );
          },
        ),
      )),
    );
  }

  Expanded contentWidget(double screenWidth, bool flag, double screenHeight) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
        ),
        child: AnimationLimiter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 500),
                childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                children: [
                  GradientText(
                    'It\'s Spinny Winny Time!',
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                    colors: [
                      Color(0xFF1A69A5),
                      Color(0xFF31949C),
                      Color(0xFF43B890),
                      Color(0xFF74C488),
                      Color(0xFFA3C897),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Get Lucky the First Time, Unlock Special Gifts by spinning the wheel!',
                    style: TextStyle(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                              0.3), // Adjust opacity for shadow intensity
                          blurRadius: 10.0, // How much to blur the shadow
                          offset: Offset(2, 4), // Offset the shadow position
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff1A69A5),
                          const Color(0xff17869E),
                          const Color(0xff36A097),
                          const Color(0xff3EAC93),
                          const Color(0xff61C08D),
                          const Color(0xff84C98B),
                          const Color(0xffA1D292)
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        flag = true;
                        canSpin = true;
                        if (homecontroller.employeeList.length < 2) {
                          toastification.show(
                            primaryColor: Colors.white,
                            context: context,
                            icon: Icon(Icons.error),
                            title: 'Error',
                            description: 'Sorry! No Employees Found',
                            backgroundColor: Colors.red[300],
                            foregroundColor: Colors.white,
                            autoCloseDuration: const Duration(seconds: 6),
                          );
                        } else {
                          selected.add(
                            Fortune.randomInt(
                                0, homecontroller.employeeList.length),
                          );
                        }
                      },
                      child: Text(
                        'Try my luck',
                        style: TextStyle(
                            fontSize: screenWidth * 0.02, color: Colors.white),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Expanded spinnerWidget(double screenWidth, double screenHeight, bool flag,
      BuildContext context) {
    return Expanded(
      flex: 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Container(
          //   child: Image.asset(
          //     'assets/images/spin_background.png',
          //     fit: BoxFit.contain,
          //     width: screenWidth * 0.40,
          //     height: screenWidth * 0.40,
          //   ),
          // ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 10, color: Color(0xffFEF88C)),
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  const Color(0xff1A69A5),
                  const Color(0xff17869E),
                  const Color(0xff36A097),
                  const Color(0xff3EAC93),
                  const Color(0xff61C08D),
                  const Color(0xff84C98B),
                  const Color(0xffA1D292)
                ])),
            width: screenWidth * 0.32,
            height: screenWidth * 0.32,
            child: FortuneWheel(
                duration: const Duration(seconds: 2),
                physics: CircularPanPhysics(),
                onFocusItemChanged: (value) {
                  if (flag == true) {
                    homecontroller.setValue(value);
                  } else {
                    flag = true;
                  }
                },
                animateFirst: false,
                onAnimationEnd: () async {
                  if (canSpin) {
                    flag = true;

                    _centerController.play();
                    _audioPlayer.open(
                      Audio("assets/audios/congratulations.mp3"),
                      autoStart: true,
                      showNotification: true,
                    );
                    await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return WinnerWidget(
                          centerController: _centerController,
                          homecontroller: homecontroller,
                          screenWidth: screenWidth,
                        );
                      },
                    ).then((valueFromDialog) async {
                      await _audioPlayer.stop();
                      homecontroller.deleteEmployee(
                          context, homecontroller.selectedEmpId.value);

                      print(valueFromDialog);
                    });
                  }
                },
                indicators: <FortuneIndicator>[
                  FortuneIndicator(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: screenWidth * 0.04,
                      height: screenWidth * 0.04,
                      child: CustomPaint(
                        painter: IndicatorPainterWidget(
                            color: const Color(0xffFEF88C)),
                      ),
                    ),
                  ),
                ],
                selected: selected.stream,
                items: [
                  for (int i = 0; i < homecontroller.employeeList.length; i++)
                    FortuneItem(
                        style: FortuneItemStyle(
                            borderColor: Colors.white,
                            color: Color(0xFF1A69A5).withOpacity(0.02)),
                        child: fortuneItemContainer(i, screenWidth,
                            homecontroller.employeeList.length)),
                ]
                // : [
                //     for (int i = 0;
                //         i < homecontroller.employeeList.length;
                //         i++)
                //       FortuneItem(
                //           style: FortuneItemStyle(
                //               borderColor: Colors.white,
                //               color: Color(0xFF1A69A5).withOpacity(0.02)),
                //           child: fortuneItemContainer(
                //               i, screenWidth, homecontroller.employeeList.length)),
                //   ],
                ),
          ),
          Positioned(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      gradient: RadialGradient(colors: [
                        Color(0xFF8BCB8D),
                        Color(0xFF38A296),
                        Color(0xFF2074A3),
                        Color(0xFFD9B84F)
                      ])),
                  height: screenWidth * 0.03,
                  width: screenWidth * 0.03,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Card departmentSelection(
      double screenWidth, double screenHeight, BuildContext context) {
    return Card(
      elevation: 5,
      margin:
          EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 20),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.01,
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Obx(() {
            return DropdownButton(
              onTap: () {
                homecontroller.fetchDepartments(context);
              },
              elevation: 0,
              dropdownColor: Colors.white,
              isDense: true,
              value: homecontroller.dropdownValue.value,
              focusColor: Colors.transparent,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: homecontroller.departmentOptions.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth *
                          0.50, // Adjust width based on screen size
                    ),
                    child: Text(
                      item,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null && newValue != "Choose Department") {
                  setState(() {
                    homecontroller.dropdownValue.value = newValue;
                  });

                  homecontroller.departmentCode.value =
                      newValue.split(' - ')[0];

                  homecontroller.fetchEmployees(
                      context, homecontroller.departmentCode.value);
                  print(homecontroller.employeeList.length);
                }
              },
            );
          }),
        ),
      ),
    );
  }

  Align appLogo(double screenWidth, double screenHeight) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: Image.asset(
          'assets/images/logo1.png',
          fit: BoxFit.cover,
          height: screenHeight * 0.07,
        ),
      ),
    );
  }

  Container fortuneItemContainer(i, double screenWidth, int dataLength) {
    return Container(
      decoration: BoxDecoration(
          // color: Colors.red,
          // gradient: LinearGradient(
          //   colors: i % 2 == 0
          //       ? [
          //           const Color(0xFF1A69A5),
          //           const Color(0xFF74C488),
          //         ]
          //       : [
          //           const Color(0xFFFCFCFC),
          //           const Color(0xFFFCFCFC),
          //         ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          ),
      alignment: dataLength < 20 ? Alignment.center : Alignment.centerRight,
      child: Text(
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        homecontroller.employeeList[i].empName ?? "Unknown",
        style: TextStyle(
            fontSize:
                dataLength < 20 ? screenWidth * 0.01 : screenWidth * 0.007,
            color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    selected.close();
    _centerController.dispose();

    super.dispose();
  }
}

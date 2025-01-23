import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:spin/controllers/homeControllers/homeController.dart';
import 'package:spin/screens/homeScreen/home_screen.dart';

class WinnerWidget extends StatelessWidget {
  const WinnerWidget({
    super.key,
    required ConfettiController centerController,
    required this.homecontroller,
    required this.screenWidth,
  }) : _centerController = centerController;

  final ConfettiController _centerController;
  final Homecontroller homecontroller;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    print(homecontroller.selectedEmpImg.value);
    return Center(
      child: PopScope(
        canPop: false,
        child: AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 40,
              ),
              GradientText(
                'Congratulations!',
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
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context, true);
                    },
                    child: Image.asset(
                      'assets/images/close.png',
                      height: 30,
                      width: 30,
                    )),
              ),
            ],
          ),
          content: Obx(() {
            return Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text("Today's winner is :-"),
                    SizedBox(height: 20),
                    Expanded(
                      child: Image.network(
                        homecontroller.selectedEmpImg.value,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return Image.asset('assets/images/employee.png');
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    GradientText(
                      homecontroller.selectedEmpName.value,
                      style: TextStyle(
                        fontSize: screenWidth * 0.02,
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
                    SizedBox(height: 20),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ConfettiWidget(
                        confettiController: _centerController,
                        blastDirection: pi / 2,
                        maxBlastForce: 10,
                        minBlastForce: 4,
                        emissionFrequency: 0.03,
                        numberOfParticles: 8,
                        gravity: 0),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

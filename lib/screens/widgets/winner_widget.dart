import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              Text("Congratulations! today's winner is ??"),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context, true);
                },
                child: CircleAvatar(
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
          content: Obx(() {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConfettiWidget(
                    confettiController: _centerController,
                    blastDirection: pi / 2,
                    maxBlastForce: 5,
                    minBlastForce: 2,
                    emissionFrequency: 0.03,
                    numberOfParticles: 10,
                    gravity: 0),
                SizedBox(height: 10),
                Text(
                  homecontroller.selectedEmpName.value,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Image.network(
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
                    return const Icon(Icons.person, size: 100);
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:confetti/confetti.dart';
import 'package:spin/controllers/homeControllers/homeController.dart';
import 'package:spin/models/homeModels/homeModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamController<int> selected = StreamController<int>();
  late ConfettiController _centerController;
  Homecontroller homecontroller = Get.put(Homecontroller());
  @override
  void initState() {
    super.initState();
    homecontroller.getLunchIdeas();
    _centerController =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    selected.close();
    _centerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var flag = false;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Weel of fortune'),
        ),
        body: Obx(() {
          return homecontroller.ideas.length > 2
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected.add(
                          Fortune.randomInt(0, homecontroller.ideas.length),
                        );
                      });
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularContainerWithSectors(),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.4,
                                height: MediaQuery.of(context).size.width / 1.4,
                                child: FortuneWheel(
                                  duration: Duration(seconds: 15),
                                  physics: CircularPanPhysics(),
                                  indicators: <FortuneIndicator>[
                                    FortuneIndicator(
                                      alignment: Alignment.topCenter,
                                      child: TriangleIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                  selected: selected.stream,
                                  items: [
                                    for (int i = 0;
                                        i < homecontroller.ideas.length;
                                        i++)
                                      // FortuneItem(
                                      //   child: Text(it.meal),
                                      // ),
                                      FortuneItem(
                                        style: FortuneItemStyle(
                                            textAlign: TextAlign.end,
                                            color: i % 2 == 0
                                                ? Colors.red
                                                : Colors.red.shade200,
                                            borderColor: (i % 2 == 0
                                                ? Colors.red
                                                : Colors.red.shade200),
                                            borderWidth: (10.0)),
                                        child: Transform(
                                          transform: Matrix4.identity()
                                            ..scale((1.0))
                                            ..setEntry(3, 2, 0.002)
                                            ..rotateX((0.1)),
                                          alignment: Alignment.center,
                                          child: _buildFortuneItem(
                                            homecontroller.ideas[i].img,
                                            homecontroller.ideas[i].meal,
                                            i % 2 == 0
                                                ? Colors.red
                                                : Colors.red.shade200,
                                            context,
                                          ),
                                        ),
                                      ),
                                  ],
                                  onAnimationEnd: () {
                                    _centerController.play();
                                    showDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: AlertDialog(
                                              scrollable: true,
                                              title: Text(
                                                  "Hurray! today's meal is????"),
                                              content: Column(
                                                children: [
                                                  ConfettiWidget(
                                                      confettiController:
                                                          _centerController,
                                                      blastDirection: pi / 2,
                                                      maxBlastForce: 5,
                                                      minBlastForce: 2,
                                                      emissionFrequency: 0.03,
                                                      numberOfParticles: 10,
                                                      gravity: 0),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    homecontroller
                                                        .selectedIdea.value,
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                  ),
                                                  SizedBox(height: 20),
                                                  Image.network(homecontroller
                                                      .selectedImg.value),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  onFocusItemChanged: (value) {
                                    if (flag == true) {
                                      homecontroller.setValue(value);
                                    } else {
                                      flag = true;
                                    }
                                  },
                                ),
                              ),
                              Container(
                                height: 110,
                                width: 110,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 1)),
                              ),
                              Positioned(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      child: Image.asset(
                                        'assets/colorWeelIcon.png',
                                        fit: BoxFit.contain,
                                        height: 100,
                                        width: 100,
                                      ),
                                    ),
                                    Text(
                                      'Color weel',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selected.add(
                                      Fortune.randomInt(
                                          0, homecontroller.ideas.length),
                                    );
                                  });
                                },
                                child: Text('Start to role')),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(color: Colors.green),
                );
        }));
  }

  Widget _buildFortuneItem(
      String emoji, String title, Color color, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.rectangle,
            ),
          ),
          Opacity(
            opacity: 0.3,
            child: Image.network(
              emoji, fit: BoxFit.cover,
              // width: 20,
              // height: 20,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 30, top: 4, bottom: 4, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Image.network(
                  //   emoji,
                  //   width: 20,
                  //   height: 20,
                  // ),
                  // Text(
                  //   emoji,
                  //   style: TextStyle(fontSize: 14),
                  // ),
                  SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircularContainerWithSectors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      height: MediaQuery.of(context).size.width / 1.2,
      child: CustomPaint(
        painter: CircleWithSectorsPainter(
          numSectors: 5,
          sectorColors: [
            Color(0xFF000000),
            Color(0xFF0C57E9),
            Color(0xFFDBC928),
            Color(0xFF972492),
            Color(0xFFF12222),
            Color(0xFF248E31),
          ],
        ),
        child: Center(
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class CircleWithSectorsPainter extends CustomPainter {
  final int numSectors;
  final List<Color> sectorColors;

  CircleWithSectorsPainter({
    required this.numSectors,
    required this.sectorColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double sweepAngle = 2 * pi / numSectors;
    double startAngle = -pi / 2;

    double spaceBetweenSectors = 4;
    double borderWidth = 8;

    double innerRadius = radius - borderWidth - spaceBetweenSectors;

    for (int i = 0; i < numSectors; i++) {
      Paint sectorPaint = Paint()
        ..color = sectorColors[i % sectorColors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;

      double angleStart =
          startAngle + i * sweepAngle + spaceBetweenSectors / innerRadius;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: innerRadius),
        angleStart,
        sweepAngle - 2 * spaceBetweenSectors / innerRadius,
        false,
        sectorPaint,
      );
    }

    Paint innerCirclePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(centerX, centerY),
        radius - borderWidth - spaceBetweenSectors - 5, innerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

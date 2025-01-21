 // FortuneItem(
                              //   style: FortuneItemStyle(
                              //       textAlign: TextAlign.end,
                              //       color: i % 2 == 0
                              //           ? Colors.red
                              //           : Colors.red.shade200,
                              //       borderColor: (i % 2 == 0
                              //           ? Colors.red
                              //           : Colors.red.shade200),
                              //       borderWidth: (10.0)),
                              //   child: Transform(
                              //     transform: Matrix4.identity()
                              //       ..scale((1.0))
                              //       ..setEntry(3, 2, 0.002)
                              //       ..rotateX((0.1)),
                              //     alignment: Alignment.center,
                              //     child: _buildFortuneItem(
                              //       homecontroller.ideas[i].img,
                              //       homecontroller.ideas[i].meal,
                              //       i % 2 == 0
                              //           ? Colors.red
                              //           : Colors.red.shade200,
                              //       context,
                              //     ),
                              //   ),
                              // ),




  // Widget _buildFortuneItem(
  //     String emoji, String title, Color color, BuildContext context) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width / 2,
  //     height: MediaQuery.of(context).size.height / 2,
  //     child: Stack(
  //       children: [
  //         Container(
  //           decoration: BoxDecoration(
  //             color: color,
  //             shape: BoxShape.rectangle,
  //           ),
  //         ),
  //         Opacity(
  //           opacity: 0.3,
  //           child: Image.network(
  //             emoji, fit: BoxFit.cover,
  //             // width: 20,
  //             // height: 20,
  //           ),
  //         ),
  //         Align(
  //           alignment: Alignment.topRight,
  //           child: Padding(
  //             padding:
  //                 const EdgeInsets.only(left: 30, top: 4, bottom: 4, right: 10),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 // Image.network(
  //                 //   emoji,
  //                 //   width: 20,
  //                 //   height: 20,
  //                 // ),
  //                 // Text(
  //                 //   emoji,
  //                 //   style: TextStyle(fontSize: 14),
  //                 // ),
  //                 SizedBox(height: 8),
  //                 Text(
  //                   title,
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 13,
  //                   ),
  //                   overflow: TextOverflow.ellipsis,
  //                   textAlign: TextAlign.center,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
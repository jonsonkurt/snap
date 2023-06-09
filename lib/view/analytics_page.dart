import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snap/model/database_helper.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  final StreamController<List<Map<String, dynamic>>>
      _recordingsStreamController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  List<Map<String, dynamic>> recordings = [];

  @override
  void initState() {
    super.initState();
    Stream<List<Map<String, dynamic>>> recordingsStream =
        _getLatestRecording('${DatabaseHelper.loggedInUserId}');
    recordingsStream.listen((List<Map<String, dynamic>> data) {
      _recordingsStreamController.add(data);
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _recordingsStreamController.close();
  // }

  Stream<List<Map<String, dynamic>>> _getLatestRecording(String userID) async* {
    final db = await DatabaseHelper.instance.database;
    while (true) {
      final allRows = await db.rawQuery('''
      SELECT r.*, u.name 
      FROM recordings r 
      INNER JOIN users u ON r.user_id = u.id
      WHERE r.user_id = ?
      ORDER BY r.id DESC
    ''', [userID]);
      yield allRows;
      await Future.delayed(const Duration(
          seconds: 1)); // wait for 1 second before querying again
    }
  }

  List<Map<String, dynamic>> recommendations = [
    {
      'image': 'assets/images/avocado.png',
      'title': 'Avocado',
      'date': '23-04-2023',
      'time': '14:30',
      'ph': '6.5',
      'npk': '10, 10, 10 (%)',
      'humidity': '70%',
      'temperature': '20°C',
      'plants': 'Avocado and Beetroot',
      'plant': 'Avocado',
      'crop': 'Beetroot',
    },
    // add more items here...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF518554),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _recordingsStreamController.stream,
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              recordings = snapshot.data!;
              return SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          bottom: 25,
                        ),
                        // decoration: BoxDecoration(
                        //   color: Colors.brown.withOpacity(0.6),
                        //   borderRadius: BorderRadius.circular(20),
                        // ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 5),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Analytics",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Your latest gathered soil qualities",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "All Values",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: 87, // Set the width of the divider here
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 1,
                                  height: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.45,
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xFFa5885e),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "pH",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          recordings.isNotEmpty
                                              ? recordings[0]['ph']
                                              : '-',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Align(
                                        alignment: Alignment.bottomRight,
                                        child: Icon(
                                          Icons.speed_rounded,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.45,
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xFFa5885e),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "NPK",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          recordings.isNotEmpty
                                              ? '${recordings[0]['n']}, ${recordings[0]['p']}, ${recordings[0]['k']} (%)'
                                              : '-',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Align(
                                        alignment: Alignment.bottomRight,
                                        child: Icon(
                                          Icons.eco_rounded,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.45,
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xFFfed269),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Humidity",
                                          style: TextStyle(
                                            //color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          recordings.isNotEmpty
                                              ? recordings[0]['humidity']
                                              : '-',
                                          style: const TextStyle(
                                            //color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Align(
                                        alignment: Alignment.bottomRight,
                                        child: Icon(
                                          Icons.wb_sunny_rounded,
                                          //color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.45,
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xFFfed269),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Temperature",
                                          style: TextStyle(
                                            //color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          recordings.isNotEmpty
                                              ? recordings[0]['temperature']
                                              : '-',
                                          style: const TextStyle(
                                            //color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Align(
                                        alignment: Alignment.bottomRight,
                                        child: Icon(
                                          Icons.opacity_rounded,
                                          //color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.15,
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xFFa5885e),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Recommended Plant and Crop",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Plant:   ",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                recordings.isNotEmpty
                                                    ? (recordings[0]['plant'] !=
                                                            "No recommended plants found"
                                                        ? recordings[0]['plant']
                                                        : 'No recommended plants found')
                                                    : '-',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: recordings
                                                              .isNotEmpty &&
                                                          recordings[0]
                                                                  ['plant'] ==
                                                              "No recommended plants found"
                                                      ? 14
                                                      : 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ]),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Suitable:   ",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              recordings.isNotEmpty
                                                  ? recordings[0]['crop']
                                                  : '-',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

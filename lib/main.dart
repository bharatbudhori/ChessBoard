import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List> board = [
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
  ];

  Map<String, int> bishop = {"row": 0, "col": 0};
  Map<String, int> rook = {"row": 1, "col": 1};

  _getRandomIndex() {
    return (Random().nextInt(8));
  }

  _resetPiecePosition() {
    bishop = {
      "row": _getRandomIndex(),
      "col": _getRandomIndex(),
    };
    rook = {
      "row": _getRandomIndex(),
      "col": _getRandomIndex(),
    };

    while (bishop["row"] == rook["row"] && bishop["col"] == rook["col"]) {
      bishop["row"] = _getRandomIndex();
      bishop["col"] = _getRandomIndex();
      rook["row"] = _getRandomIndex();
      rook["col"] = _getRandomIndex();
    }

    setState(() {});
  }

  List<List<int>> _getRookOccupiedBox() {
    int i = rook["row"]!;
    int j = rook["col"]!;

    List<List<int>> occupiedBox = [];

    for (int row = 0; row < 8; row++) {
      occupiedBox.add([row, j]);
    }

    for (int col = 0; col < 8; col++) {
      occupiedBox.add([i, col]);
    }

    return occupiedBox;
  }

  List<List<int>> _getBishopOccupiedBox() {
    int i = bishop["row"]!;
    int j = bishop["col"]!;

    List<List<int>> occupiedBox = [];

    int tempi = i;
    int tempj = j;

    while (i < 8 && j < 8) {
      occupiedBox.add([i, j]);
      i++;
      j++;
    }

    i = tempi;
    j = tempj;

    while (i >= 0 && j >= 0) {
      occupiedBox.add([i, j]);
      i--;
      j--;
    }

    i = tempi;
    j = tempj;

    while (i < 8 && j >= 0) {
      occupiedBox.add([i, j]);
      i++;
      j--;
    }

    i = tempi;
    j = tempj;

    while (i >= 0 && j < 8) {
      occupiedBox.add([i, j]);
      i--;
      j++;
    }

    return occupiedBox;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(8, (i) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(8, (j) {
                    int rowIndex = i;
                    int colIndex = j;

                    bool isBishop = (rowIndex == bishop["row"]) &&
                        (colIndex == bishop["col"]);
                    bool isRook =
                        (rowIndex == rook["row"]) && (colIndex == rook["col"]);

                    final rookBoxes = _getRookOccupiedBox();
                    final bishopBoxes = _getBishopOccupiedBox();

                    bool isOccByRook = false;
                    bool isOccByBishop = false;

                    for (var box in rookBoxes) {
                      if (box[0] == rowIndex && box[1] == colIndex) {
                        isOccByRook = true;
                      }
                    }

                    for (var box in bishopBoxes) {
                      if (box[0] == rowIndex && box[1] == colIndex) {
                        isOccByBishop = true;
                      }
                    }

                    Color boxColor = Colors.white;

                    if (isOccByRook) {
                      boxColor = Colors.yellow;
                    }

                    if (isOccByBishop) {
                      boxColor = Colors.blue;
                    }

                    if (isOccByRook && isOccByBishop) {
                      boxColor = Colors.red;
                    }

                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: boxColor,
                      ),
                      child: isBishop
                          ? const Center(child: Text("B"))
                          : isRook
                              ? const Center(child: Text("R"))
                              : const Text(""),
                    );
                  }),
                );
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _resetPiecePosition, child: const Text("RESET")),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tic Tac Toe'),
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
  int move = 0;

  List<List<String>> _board1 = <List<String>>[
    <String>['', '', ''],
    <String>['', '', ''],
    <String>['', '', '']
  ];

  String _checkDiagonals() {
    final List<String> diagonal1 = <String>[];

    int counter = 0;
    for (int i = 0; i < _board1.length; i++) {
      diagonal1.add(_board1[i][i]);
    }

    for (int i = 0; i < diagonal1.length - 1; i++) {
      if (diagonal1[i] == diagonal1[i + 1] && diagonal1[i] != '') {
        counter++;
      }
    }

    if (counter == 2) {
      return diagonal1[0];
    }

    final List<String> diagonal2 = <String>[];
    counter = 0;
    for (int i = 0; i < _board1.length; i++) {
      diagonal2.add(_board1[i][_board1.length - i - 1]);
    }

    for (int i = 0; i < diagonal2.length - 1; i++) {
      if (diagonal2[i] == diagonal2[i + 1] && diagonal2[i] != '') {
        counter++;
      }
    }

    if (counter == 2) {
      return diagonal2[0];
    }

    return '';
  }

  String _checkColumns() {
    for (int i = 0; i < _board1.length; i++) {
      int counter = 0;
      for (int j = 0; j < _board1[i].length - 1; j++) {
        if (_board1[j][i] == _board1[j + 1][i] && _board1[j][i] != '') {
          counter++;
        }
      }
      if (counter == 2) {
        return _board1[0][i];
      }
    }

    return '';
  }

  String _checkRows() {
    for (int i = 0; i < _board1.length; i++) {
      int counter = 0;
      for (int j = 0; j < _board1[i].length - 1; j++) {
        if (_board1[i][j] == _board1[i][j + 1] && _board1[i][j] != '') {
          counter++;
        }
      }
      if (counter == 2) {
        return _board1[i][0];
      }
    }

    return '';
  }

  String _checkWinner() {
    if (_checkRows() != '') {
      return _checkRows();
    }

    if (_checkColumns() != '') {
      return _checkColumns();
    }

    if (_checkDiagonals() != '') {
      return _checkDiagonals();
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 30),
          ),
        ),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 3,
          children: List<Widget>.generate(
            9,
            (int index) {
              final int row = index ~/ _board1[0].length;
              final int col = index % _board1[0].length;
              final String value = _board1[row][col];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (move.isEven) {
                      _board1[row][col] = 'X';
                      move++;
                    } else {
                      _board1[row][col] = '0';
                      move++;
                    }
                  });

                  final String winner = _checkWinner();

                  if (winner != '') {
                    showDialog<Widget>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Winner is $winner'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  _board1 = <List<String>>[
                                    <String>['', '', ''],
                                    <String>['', '', ''],
                                    <String>['', '', '']
                                  ];
                                  move = 0;
                                });
                              },
                              child: const Text('Play Again'),
                            )
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.w200),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

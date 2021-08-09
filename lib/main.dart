import 'package:flutter/material.dart';
import 'package:sweeper/sweeper/sweeper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SweeperGame _game = SweeperGame(7, 5, 5);
  double tileSize = 48.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox(
        width: tileSize * _game.cols,
        child: GridView.builder(
            // crossAxisCount: _game.cols,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _game.cols),
            // shrinkWrap: true,
            itemCount: _game.rows * _game.cols,
            itemBuilder: (context, position) {
              // for (int row = 0; row < _game.rows; row++) ...{
              // for (int col = 0; col < _game.cols; col++) ...{
              int row = position ~/ _game.cols;
              int col = position % _game.cols;
              Tile tile = _game.getTile(row, col)!;
              return Material(
                color: tile.isOpen
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).cardColor,
                child: InkWell(
                  onTap: tile.isOpen
                      ? null
                      : () {
                          setState(() {
                            _game.openTile(row, col);
                          });
                        },
                  child: SizedBox(
                    height: tileSize,
                    width: tileSize,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Ink(
                        color: tile.isOpen
                            ? Color.lerp(Theme.of(context).cardColor,
                                Theme.of(context).scaffoldBackgroundColor, 0.5)
                            : Colors.transparent,
                        child: Center(
                          child: Text(tile.isOpen ? tile.toDisplayString() : '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    color: getNumberColor(
                                        tile is FreeTile ? tile.mineCount : 0),
                                  )),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            // }
            // }
            // ],
            ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Color getNumberColor(int mineCount) {
  switch (mineCount) {
    case 1:
      return Colors.blue;
    case 2:
      return Colors.green;
    case 3:
      return Colors.red;
    case 4:
      return Colors.blueGrey;
    case 5:
      return Colors.brown;
    case 6:
      return Colors.cyan;
    case 7:
      return Colors.white;
    case 8:
      return Colors.grey;
    default:
      return Colors.white;
  }
}

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Game {
  int _endTime;
  int score;
  bool inGame;
  double x;
  double y;
  double _velX;
  double _velY;

  void incrementCounter() {
    score++;
    _resetBall();
  }

  void _resetBall() {
    final rand = Random.secure();
    x = rand.nextDouble();
    y = rand.nextDouble();
    _velX = rand.nextDouble() / 20;
    _velY = rand.nextDouble() / 20;
  }

  void start() {
    score = 0;
    inGame = true;
    _endTime = DateTime.now().millisecondsSinceEpoch + 30 * 1000;
    _resetBall();
  }

  int _currentTime() {
    final time = _endTime - DateTime.now().millisecondsSinceEpoch;
    return time < 0 ? 0 : time;
  }

  void update() {
    if (_currentTime() <= 0) {
      inGame = false;
      return;
    }
    x += _velX;
    if (x < 0.0) {
      x = 0.0;
      _velX *= -0.9;
    } else if (1.0 < x) {
      x = 1.0;
      _velX *= -0.9;
    }
    y += _velY;
    if (y < 0.0) {
      y = 0.0;
      _velY *= -0.9;
    } else if (1.0 < y) {
      y = 1.0;
      _velY *= -0.9;
    }
  }
}

class _MyHomePageState extends State<MyHomePage> {
  Timer _timer;
  final _game = Game();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Score: ${_game.score} Time: ${_game._currentTime()}'),
        actions: <Widget>[
          MaterialButton(
            child: Text("Restart"),
            onPressed: () {
              _game.start();
            },
          )
        ],
      ),
      body: _game.inGame
          ? Container(
              alignment: FractionalOffset(_game.x, _game.y),
              child: GestureDetector(
                  onTapDown: (_) {
                    _game.incrementCounter();
                  },
                  child: Icon(
                    Icons.star,
                    size: 100,
                  )))
          : Center(
              child: Row(children: [
              Text("Game Over"),
              MaterialButton(
                  child: Text("ツイート"),
                  onPressed: () {
                    launch("https://twitter.com/");
                  }),
            ])),
    );
  }

  @override
  void initState() {
    super.initState();
    _game.start();
    _timer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      _game.update();
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }
}

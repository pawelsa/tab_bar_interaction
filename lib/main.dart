import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final _duration = Duration(milliseconds: 500);
  bool _showHidden = false;
  AnimationController _controller;
  Animation _rotationAnimation;
  Animation<double> _fabHeightAnimation;
  Animation<Offset> _addIconOffsetAnimation;
  Animation<Offset> _columnOffsetAnimation;
  List<Animation<Offset>> _columnItemOffsetAnimation;

  // TODO dodać slider do kontroli animacji

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _rotationAnimation = Tween(begin: 0.0, end: 2 * pi).animate(_controller);
    _addIconOffsetAnimation =
        Tween(begin: Offset.zero, end: Offset(0.0, -2.0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );
    _columnOffsetAnimation = Tween(begin: Offset(0.0, 3.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _fabHeightAnimation = Tween(begin: 80.0, end: 220.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.64),
      ),
    );
    final cubic = Cubic(.53, .3, .72, 1.17);
    _columnItemOffsetAnimation = [
      Tween(begin: Offset(0.0, 3.0), end: Offset.zero).animate(CurvedAnimation(
          parent: _controller, curve: Interval(0.27, 0.78, curve: cubic))),
      Tween(begin: Offset(0.0, 3.0), end: Offset.zero).animate(CurvedAnimation(
          parent: _controller, curve: Interval(0.49, 0.93, curve: cubic))),
      Tween(begin: Offset(0.0, 3.0), end: Offset.zero).animate(CurvedAnimation(
          parent: _controller, curve: Interval(0.67, 1.0, curve: cubic))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () {
            setState(() {
              _showHidden = !_showHidden;
              if (_showHidden) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) =>
                  Container(
                    width: 80,
                    height: _fabHeightAnimation.value,
                    decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          SlideTransition(
                            position: _addIconOffsetAnimation,
                            child: Transform.rotate(
                              angle: _rotationAnimation.value,
                              child: Container(
                                width: 80,
                                height: 80,
                                color: Colors.deepOrangeAccent,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          /*SlideTransition(
                        position: _columnOffsetAnimation,
                        child:*/
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                SlideTransition(
                                  position: _columnItemOffsetAnimation[0],
                                  child: _buildIcon(Icons.photo_camera),
                                ),
                                SlideTransition(
                                  position: _columnItemOffsetAnimation[1],
                                  child: _buildIcon(Icons.play_circle_outline),
                                ),
                                SlideTransition(
                                  position: _columnItemOffsetAnimation[2],
                                  child: _buildIcon(Icons.font_download),
                                ),
                                /*_buildIcon(Icons.photo_camera),
                              _buildIcon(Icons.play_circle_outline),
                              _buildIcon(Icons.font_download),*/
                              ],
                            ),
                          ),
                          // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

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
  final _duration = Duration(milliseconds: 300);
  bool _showHidden = false;
  AnimationController _controller;
  Animation _rotationAnimation;
  Animation<Offset> _addIconOffsetAnimation;
  Animation<Offset> _columnOffsetAnimation;
  List<Animation<Offset>> _columnItemOffsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _rotationAnimation = Tween(begin: 0.0, end: 2 * pi).animate(_controller);
    _addIconOffsetAnimation = Tween(begin: Offset.zero, end: Offset(0.0, -6.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    _columnOffsetAnimation = Tween(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _columnItemOffsetAnimation = [
      Tween(begin: Offset(0.0, 1.0), end: Offset.zero).animate(CurvedAnimation(
          parent: _controller,
          curve: Interval(0.4, 0.5, curve: Curves.easeInOut))),
      Tween(begin: Offset(0.0, 1.0), end: Offset.zero).animate(CurvedAnimation(
          parent: _controller,
          curve: Interval(0.65, 0.75, curve: Curves.easeInOut))),
      Tween(begin: Offset(0.0, 1.0), end: Offset.zero).animate(CurvedAnimation(
          parent: _controller,
          curve: Interval(0.9, 1.0, curve: Curves.easeInOut))),
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
              builder: (context, _) => AnimatedContainer(
                width: 80,
                height: _showHidden ? 220 : 80,
                duration: _duration * 0.75,
                decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: BorderRadius.circular(40)),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SlideTransition(
                        position: _addIconOffsetAnimation,
                        child: Transform.rotate(
                          angle: _rotationAnimation.value,
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.deepOrangeAccent,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                      SlideTransition(
                        position: _columnOffsetAnimation,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SlideTransition(
                              position: _columnItemOffsetAnimation[0],
                              child: _buildIcon(Icons.photo_camera),
                            ),
                            Divider(
                              height: 10,
                            ),
                            SlideTransition(
                              position: _columnItemOffsetAnimation[1],
                              child: _buildIcon(Icons.play_circle_outline),
                            ),
                            Divider(
                              height: 10,
                            ),
                            SlideTransition(
                              position: _columnItemOffsetAnimation[2],
                              child: _buildIcon(Icons.font_download),
                            ),
                          ],
                        ),
                      ),
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
    return Container(
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
    );
  }
}

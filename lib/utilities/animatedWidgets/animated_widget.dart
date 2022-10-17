import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EasyAnimatedOffset extends StatefulWidget {
  EasyAnimatedOffset();

  @override
  _EasyAnimatedOffsetState createState() => _EasyAnimatedOffsetState();
}

class _EasyAnimatedOffsetState extends State<EasyAnimatedOffset>
    with SingleTickerProviderStateMixin {
  //Notice the "SingleTickerProviderStateMixin" above
  //Must add "AnimationController"
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      //change the animation duration for a slower or faster animation.
      //For example, replacing 1000 with 5000 will give you a 5x slower animation.
      duration: Duration(milliseconds: 1000),
    );
  }

  animateForward() {
    _animationController.forward();
    //this controller will move the animation forward
    //you can also create a reverse animation using "_animationController.reverse()"
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //the offset has a x value and y value.
    //changing the y axis value moves the animation vertically
    //changing the x axis value moves the animation horizantaly
    double xAxisValue = 0;
    double yAxisValue = 10;
    return AnimatedBuilder(
        animation: _animationController,
        // child: widget.child,
        builder: (context, child) {
          return Transform.translate(
              offset: Offset(_animationController.value * xAxisValue,
                  _animationController.value * yAxisValue),
              //add your button or widget here
              child: InkWell(
                  onTap: () {
                    animateForward();
                  },
                  child: Center(
                    child: Container(
                        height: 100,
                        width: 200,
                        color: Colors.amber,
                        child: Center(
                          child: Text(
                            "Animate Me",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        )),
                  )));
        });
  }
}

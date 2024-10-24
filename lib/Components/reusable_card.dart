// ignore_for_file: unused_field
import 'package:delivoo_stores/Themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReusableCard extends StatefulWidget {
  final Widget? cardChild;
  final Function? onPress;

  ReusableCard({this.cardChild, this.onPress});

  @override
  _ReusableCardState createState() => _ReusableCardState();
}

class _ReusableCardState extends State<ReusableCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller!);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller?.forward();
    return GestureDetector(
      onTap: widget.onPress as void Function(),
      child: Container(
        child: widget.cardChild,
//        margin: EdgeInsets.all(12.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: kCardBackgroundColor,
        ),
      ),
    );
  }
}

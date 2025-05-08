import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyButton extends StatelessWidget {
  String title;
  VoidCallback onTap;
  Color color;
  double width;
  double bordercircle;
  double fontSize;
  Color textColor;
  Color splashColor;
  VoidCallback onEdit;

  MyButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.onEdit,
    required this.color,
    required this.width,
    required this.bordercircle,
    required this.fontSize,
    required this.textColor,
    required this.splashColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 1),
            blurRadius: 2.0,
          ),
        ],
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: color,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          splashColor: splashColor,
          splashFactory: InkSplash.splashFactory,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(onPressed: onEdit, icon: Icon(Icons.edit))
                ],
              )),
        ),
      ),
    );
  }
}

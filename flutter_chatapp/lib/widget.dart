import 'package:flutter/material.dart';

//
// Widget appBarMain(BuildContext context) {
//   return AppBar(
//     title: Image.asset(
//       "asset/images/logo.png",
//       height: 40,
//     ),
//     elevation: 0.0,
//     backgroundColor: Colors.white70,
//     centerTitle: false,
//   );
// }

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // title: Image.asset(
      //   "asset/images/logo.png",
      //   height: 50,
      // ),
      title: Text(
        "Flutter Messanger",
      ),
      elevation: 0.0,
      backgroundColor: Color(0xff2c69e1),
      centerTitle: false,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

InputDecoration inputFieldDecoration( {String? hint}) {
  return InputDecoration(
    hintText: hint,
    contentPadding: EdgeInsets.only(left: 5,top: 10),
    hintStyle: TextStyle(color: Colors.white54),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white54,
      ),
    ),
  );
}

class longButton extends StatelessWidget {
  final Color bgColor;
  final Color textColor;
  final String text;

  const longButton({
    Key? key, required this.bgColor, required this.textColor, required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(

          color: bgColor,
          borderRadius: BorderRadius.circular(30.0)
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 17),
      ),
    );
  }
}
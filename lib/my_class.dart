import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

saveToPref(String key, dynamic value) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  if (value is String){
    pref.setString(key, value);
  }
}

showToast(String pesan) {
  Fluttertoast.showToast(
    msg: pesan.tr(),
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: Colors.purple[900], // Colors.black87,
    textColor: Colors.white,
    gravity: ToastGravity.BOTTOM,
    fontSize: 16.0
  );
}

class RaisedGradientButton extends StatelessWidget {
  final Widget? child;
  final Gradient? gradient;
  final double width;
  final double height;

  const RaisedGradientButton({
    @required this.child,
    this.gradient,
    this.width = double.infinity,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(gradient: gradient, boxShadow: [
        BoxShadow(
          color: Colors.grey[500]!,
          offset: Offset(0.0, 1.5),
          blurRadius: 1.5,
        ),
      ], borderRadius: BorderRadius.circular(5),),
      child: Material(
        color: Colors.transparent,
        child: Center(
              child: child,
        )
      ),
    );
  }
}

// showToastUp(String pesan) {
//   Fluttertoast.showToast(
//     msg: pesan,
//     toastLength: Toast.LENGTH_LONG,
//     backgroundColor: Colors.green[400], // Colors.black87,
//     textColor: Colors.white,
//     gravity: ToastGravity.TOP,
//     fontSize: 16.0
//   );
// }

dialogLoading(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom:10.0),
              child: CircularProgressIndicator(),
            ),
            Text("Loading ..."),
          ],
        ),
      );
  });
}

Widget buildNotif(IconData icon, Color badgeColor) {
  return Stack(
    children: [
      Icon(icon, size: 24.0, color: Colors.white),
      Positioned(
        top: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.all(1.0),
          decoration: BoxDecoration(
            color: badgeColor,
            shape: BoxShape.circle,
          ),
          constraints: BoxConstraints(
            minWidth: 10.0,
            minHeight: 10.0,
          ),
        )
      )
    ],
  );
}

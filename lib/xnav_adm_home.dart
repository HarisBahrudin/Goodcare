// import 'package:flutter/material.dart';
// import 'package:goodcare/adm_dokter_list.dart';
// import 'package:goodcare/adm_pasien_list.dart';
// import 'package:goodcare/adm_regist_list.dart';
// import 'package:goodcare/adm_tindakan_list.dart';
// import 'package:goodcare/adm_user_list.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HomeAdmin extends StatefulWidget {
//   // final VoidCallback xlogOut;
//   // const HomeAdmin({ Key? key, required this.xlogOut }) : super(key: key);

//   @override
//   _HomeAdminState createState() => _HomeAdminState();
// }

// class _HomeAdminState extends State<HomeAdmin> {
//   String xidus='', xnmus='', xrole='', xtkn='';
//   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

//   @override
//   void initState() {
//     super.initState();
//     getPref();
//   }

//   void getPref() async {
//     final SharedPreferences pref = await _prefs;
//     setState(() {
//       xidus = pref.getString("xidus") ?? '';
//       xnmus = pref.getString("xnmus") ?? '';
//       xrole = pref.getString("xrole") ?? '';
//       xtkn = pref.getString("xtkn") ?? '';
//     });

//     print(xidus+' - '+xnmus+' - '+xrole+' - '+xtkn);
//   }

//   void dialogLogout(BuildContext context) async {
//     return showDialog(
//       context: context,
//       builder: (context){
//         return AlertDialog(
//           title: Text('Anda yakin ingin logout ?'),
//           actions: <Widget> [
//             TextButton(
//               child: Text("Tidak"),
//               onPressed: (){
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text("Iya"),
//               onPressed: (){
//                 widget.xlogOut();
//                 Navigator.pop(context);
//               },
//             )
//           ],
//         );
//       }
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var mediaQuery = MediaQuery.of(context);
//     return Scaffold(
//       backgroundColor: Color(0xFFEEEEEE),
//       body: Stack(
//         children: <Widget>[
//           _widgetBgUp(mediaQuery),
//           _widgetMenu1(mediaQuery),
//           _widgetMenu2(mediaQuery),
//           _widgetMenu3(mediaQuery),
//         ],
//       )
//     );
//   }

//   Widget _widgetBgUp(MediaQueryData mediaQuery) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(10, 40, 10, 10), //(left, top, right, bottom)
//       child: Container(
//         width: mediaQuery.size.width,
//         height: 180.0,
//         decoration: BoxDecoration(
//           shape: BoxShape.rectangle,
//           borderRadius: BorderRadius.all(Radius.circular(20)),
//           // borderRadius: BorderRadius.only(
//           //   bottomLeft: Radius.circular(35.0),
//           //   bottomRight: Radius.circular(35.0),
//           // ),
//           border: Border.all(color: Colors.purple),
//           color: Colors.white,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 2.0, left: 30),
//               child: Row(
//                 children: [
//                   Image(image: AssetImage('assets/logo2.png'), width: 180, height: 100,)
//                 ],
//               ),
//             ),

//             Padding(
//               padding: const EdgeInsets.only(top: 2.0, left: 30),
//               child: Text('Welcome '+xrole, style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900)),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 2.0, left: 30),
//               child: Text(xnmus, style: TextStyle(fontSize: 20.0, color: Colors.purple.shade900, fontWeight: FontWeight.bold)),
//             ),

//           ],
//         ),
//       ),
//     );
//   }

//   Widget _widgetMenu1(MediaQueryData mediaQuery) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(10, 250, 10, 10),
//       child: Container(
//         width: mediaQuery.size.width,
//         height: 130.0,
//         decoration: BoxDecoration(
//           shape: BoxShape.rectangle,
//           // color: Colors.blue.shade100, // back
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Card(
//               elevation: 4,
//               color: Colors.white,
//               child: InkWell(
//                 splashColor: Colors.purple,
//                 child: Container(
//                   width: (mediaQuery.size.width / 3) - 20,
//                   height: 130.0,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.person_add_alt_rounded, color: Colors.purple.shade900, size: 50,),
//                       SizedBox(height: 10,),
//                       Text('Registrasi', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),),
//                       Text('Pasien', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),)
//                     ],
//                   ),
//                 ),
//                 onTap: (){
//                   Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => AdmRegistList(xtkn: xtkn)
//                   ));
//                 },
//               ),
//             ),
//             Card(
//               elevation: 4,
//               color: Colors.white,
//               child: InkWell(
//                 splashColor: Colors.purple,
//                 child: Container(
//                   width: (mediaQuery.size.width / 3) - 20,
//                   height: 200.0,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     // color: Colors.green.shade100,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.group, color: Colors.purple.shade900, size: 60,),
//                       SizedBox(height: 10,),
//                       Text('Data Pasien', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),)
//                     ],
//                   ),
//                 ),
//                 onTap: (){
//                   Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => AdmPasienList(xtkn: xtkn)
//                   ));
//                 },
//               ),
//             ),

//             Card(
//               elevation: 4,
//               color: Colors.white,
//               child: InkWell(
//                 splashColor: Colors.purple,
//                 child: Container(
//                   width: (mediaQuery.size.width / 3) - 20,
//                   height: 200.0,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     // color: Colors.green.shade100,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.verified_user_rounded, color: Colors.purple.shade900, size: 60,),
//                       SizedBox(height: 10,),
//                       Text('Data User', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),)
//                     ],
//                   ),
//                 ),
//                 onTap: (){
//                   Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => AdmPasienList(xtkn: xtkn)
//                   ));
//                 },
//               ),
//             )

//           ]
//         ),
//       ),
//     );
//   }

//   Widget _widgetMenu2(MediaQueryData mediaQuery) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 400, 20, 10),
//       child: Container(
//         width: mediaQuery.size.width,
//         height: 150.0,
//         decoration: BoxDecoration(
//           shape: BoxShape.rectangle,
//           // color: Colors.blue.shade100, // back
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Card(
//               elevation: 4,
//               color: Colors.blue.shade100,
//               child: InkWell(
//                 splashColor: Colors.blue,
//                 child: Container(
//                   width: (mediaQuery.size.width / 2) - 50,
//                   height: 150.0,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     // color: Colors.blue.shade100,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.verified_user_rounded, color: Colors.blue.shade700, size: 60,),
//                       SizedBox(height: 10,),
//                       Text('Data User', style: TextStyle(fontSize: 18.0, color: Colors.blue.shade700,),)
//                     ],
//                   ),
//                 ),
//                 onTap: (){
//                   Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => AdmUserList(xtkn: xtkn)
//                   ));
//                 },
//               ),
//             ),
//             Card(
//               elevation: 4,
//               color: Colors.purple.shade100,
//               child: InkWell(
//                 splashColor: Colors.purple,
//                 child: Container(
//                   width: (mediaQuery.size.width / 2) - 50,
//                   height: 200.0,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     // color: Colors.purple.shade100,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.medication, color: Colors.purple.shade700, size: 60,),
//                       SizedBox(height: 10,),
//                       Text('Data Dokter', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade700,),)
//                     ],
//                   ),
//                 ),
//                 onTap: (){
//                   Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => AdmDokterList(xtkn: xtkn)
//                   ));
//                 },
//               ),
//             )
//           ]
//         ),
//       ),
//     );
//   }

//   Widget _widgetMenu3(MediaQueryData mediaQuery) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 570, 20, 10),
//       child: Container(
//         width: mediaQuery.size.width,
//         height: 150.0,
//         decoration: BoxDecoration(
//           shape: BoxShape.rectangle,
//           // color: Colors.blue.shade100, // back
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Card(
//               elevation: 4,
//               color: Colors.cyan.shade100,
//               child: InkWell(
//                 splashColor: Colors.cyan,
//                 child: Container(
//                   width: (mediaQuery.size.width / 2) - 50,
//                   height: 150.0,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     // color: Colors.cyan.shade100,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.settings_accessibility_rounded, color: Colors.cyan.shade700, size: 60,),
//                       SizedBox(height: 10,),
//                       Text('Tindakan', style: TextStyle(fontSize: 18.0, color: Colors.cyan.shade700,),)
//                     ],
//                   ),
//                 ),
//                 onTap: (){
//                   Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => AdmTindakanList()
//                   ));
//                 },
//               ),
//             ),
//             Card(
//               elevation: 4,
//               color: Colors.red.shade100,
//               child: InkWell(
//                 splashColor: Colors.red,
//                 child: Container(
//                   width: (mediaQuery.size.width / 2) - 50,
//                   height: 200.0,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     // color: Colors.red.shade100,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.logout_rounded, color: Colors.red.shade700, size: 60,),
//                       SizedBox(height: 10,),
//                       Text('Logout', style: TextStyle(fontSize: 18.0, color: Colors.red.shade700,),)
//                     ],
//                   ),
//                 ),
//                 onTap: (){
//                   dialogLogout(context);
//                 },
//               ),
//             )
//           ]
//         ),
//       ),
//     );
//   }

// }
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/adm_dokter_list.dart';
import 'package:goodcare/adm_download.dart';
import 'package:goodcare/adm_jp.dart';
import 'package:goodcare/adm_kecamatan.dart';
import 'package:goodcare/adm_pasien_list.dart';
import 'package:goodcare/adm_profil.dart';
import 'package:goodcare/adm_regist_list.dart';
import 'package:goodcare/adm_user_list.dart';
import 'package:goodcare/my_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Admins extends StatefulWidget {
  final VoidCallback xlogOut;
  const Admins({ Key? key, required this.xlogOut }) : super(key: key);

  @override
  _AdminsState createState() => _AdminsState();
}

class _AdminsState extends State<Admins> {
  int _selectedIndexBNav = 0;
  // String xbhs="en_US", xnmBHS="EN";

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _widgetOption() => <Widget>[
    HomeAdmin(xlogOut: widget.xlogOut),
    AdmDownload(),
    AdmProfil(xsignOut: widget.xlogOut,),
  ];
  
  Widget _bottomNavigation(){
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndexBNav,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.purple.shade700,
      unselectedItemColor: Colors.purple.shade900,
      selectedFontSize: 16,
      unselectedFontSize: 14,
      onTap: (value){
        setState(() => _selectedIndexBNav = value);
      },
      elevation: 0,
      items: [
        BottomNavigationBarItem(
          label: "tabAdminHome".tr(),
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: "tabAdminLaporan".tr(),
          icon: Icon(Icons.description_sharp),
        ),
        BottomNavigationBarItem(
          label: "tabAdminProfil".tr(),
          icon: Icon(Icons.account_circle),
        ),
      ],
      
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = _widgetOption();
    return Scaffold(
      body: children[_selectedIndexBNav],
      bottomNavigationBar: _bottomNavigation(),
    );
  }
}

// ------------- Home

class HomeAdmin extends StatefulWidget {
  final VoidCallback xlogOut;
  const HomeAdmin({ Key? key, required this.xlogOut }) : super(key: key);

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  String xidus='', xnmus='', xrole='', xtkn='';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String xbhs="", xnmBHS="";
  // String xbhs="en_US", xnmBHS="EN";

  @override
  void initState() {
    super.initState();
    getPref();
  }

  void getPref() async {
    final SharedPreferences pref = await _prefs;
    setState(() {
      xidus = pref.getString("xidus") ?? '';
      xnmus = pref.getString("xnmus") ?? '';
      xrole = pref.getString("xrole") ?? '';
      xtkn = pref.getString("xtkn") ?? '';
      xbhs = pref.getString("xbhs") ?? 'en_US';
      xnmBHS = pref.getString("xnmbhs") ?? 'EN';
    });

    print(xidus+' - '+xnmus+' - '+xrole+' - '+xtkn+' - '+xbhs);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        toolbarHeight: 1,
      ),
      backgroundColor: Color(0xFFEEEEEE),
      body: ListView(
        children: <Widget>[
          Stack(
            children: [
              _widgetBgUp(mediaQuery),
              _widgetLogo(mediaQuery),
            ],
          ),
          _widgetMenu1(mediaQuery),
          _widgetMenu2(mediaQuery),
          _widgetMenu3(mediaQuery),
          // _widgetMenu4(mediaQuery),
        ],
      )
    );
  }

  Widget _widgetBgUp(MediaQueryData mediaQuery) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10), //(left, top, right, bottom)
      child: Container(
        width: mediaQuery.size.width,
        height: 180.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          // borderRadius: BorderRadius.all(Radius.circular(20)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(35.0),
            bottomRight: Radius.circular(35.0),
          ),
          // border: Border.all(color: Colors.purple),
          color: Colors.purple.shade900,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(top: 34.0, right: 24),
                child: Text(xnmBHS, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
              ),
              onTap: (){
                // context.setLocale(Locale('en_US'));
                // context.setLocale('en_US'.toLocale());
                if (xbhs=="en_US"){
                  xbhs = "id";
                  xnmBHS = "ID";
                  // context.resetLocale();
                  context.setLocale('id'.toLocale());
                  // context.setLocale(Locale('id'));
                  saveToPref("xbhs", "id");
                  saveToPref("xnmbhs", "ID");
                  print("Bahasa diubah ke "+xbhs+" - "+xnmBHS);
                  setState(() {});
                } else {
                  xbhs = "en_US";
                  xnmBHS = "EN";
                  // context.resetLocale();
                  context.setLocale('en_US'.toLocale());
                  // context.setLocale(Locale('en_US'));
                  saveToPref("xbhs", "en_US");
                  saveToPref("xnmbhs", "EN");
                  print("Bahasa diubah ke "+xbhs+" - "+xnmBHS);
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _widgetLogo(MediaQueryData mediaQuery) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10), //(left, top, right, bottom)
      child: Container(
        width: mediaQuery.size.width,
        height: 180.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          // borderRadius: BorderRadius.only(
          //   bottomLeft: Radius.circular(35.0),
          //   bottomRight: Radius.circular(35.0),
          // ),
          border: Border.all(color: Colors.purple),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 30),
              child: Row(
                children: [
                  Image(image: AssetImage('assets/logo2.png'), width: 180, height: 100,)
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 30),
              child: Text('welcome '+xrole, style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900)).tr(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 30),
              child: Text(xnmus, style: TextStyle(fontSize: 20.0, color: Colors.purple.shade900, fontWeight: FontWeight.bold)),
            ),

          ],
        ),
      ),
    );
  }

  // Widget _widgetMenu1(MediaQueryData mediaQuery) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(10, 250, 10, 10),
  //     child: Container(
  //       width: mediaQuery.size.width,
  //       height: 100.0,
  //       decoration: BoxDecoration(
  //         shape: BoxShape.rectangle,
  //         // color: Colors.blue.shade100, // back
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         children: [
  //           Card(
  //             elevation: 4,
  //             color: Colors.white,
  //             child: InkWell(
  //               splashColor: Colors.purple,
  //               child: Container(
  //                 width: 110,
  //                 height: 100.0,
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.rectangle,
  //                   // color: Colors.blue.shade100,
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(Icons.person_add_alt_rounded, color: Colors.purple.shade900, size: 40,),
  //                     SizedBox(height: 10,),
  //                     Text('mRegistrasi', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),).tr(),
  //                     Text('mPas', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),).tr()
  //                   ],
  //                 ),
  //               ),
  //               onTap: (){
  //                 Navigator.of(context).push(MaterialPageRoute(
  //                   builder: (context) => AdmRegistList(xtkn: xtkn)
  //                 ));
  //               },
  //             ),
  //           ),
  //           Card(
  //             elevation: 4,
  //             color: Colors.white,
  //             child: InkWell(
  //               splashColor: Colors.purple,
  //               child: Container(
  //                 width: 110,
  //                 height: 100.0,
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.rectangle,
  //                   // color: Colors.purple.shade100,
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(Icons.group, color: Colors.purple.shade900, size: 40,),
  //                     SizedBox(height: 10,),
  //                     Text('mKelolaPas', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),).tr()
  //                   ],
  //                 ),
  //               ),
  //               onTap: (){
  //                 Navigator.of(context).push(MaterialPageRoute(
  //                   builder: (context) => AdmPasienList(xtkn: xtkn)
  //                 ));
  //               },
  //             ),
  //           ),
  //           Card(
  //             elevation: 4,
  //             color: Colors.white,
  //             child: InkWell(
  //               splashColor: Colors.purple,
  //               child: Container(
  //                 width: 110,
  //                 height: 100.0,
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.rectangle,
  //                   // color: Colors.blue.shade100,
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(Icons.verified_user_rounded, color: Colors.purple.shade900, size: 40,),
  //                     SizedBox(height: 10,),
  //                     Text('mKelolaUser', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),).tr()
  //                   ],
  //                 ),
  //               ),
  //               onTap: (){
  //                 Navigator.of(context).push(MaterialPageRoute(
  //                   builder: (context) => AdmUserList(xtkn: xtkn)
  //                 ));
  //               },
  //             ),
  //           ),
  //         ]
  //       ),
  //     ),
  //   );
  // }

  Widget _widgetMenu1(MediaQueryData mediaQuery) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Container(
        width: mediaQuery.size.width,
        height: 150.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          // color: Colors.blue.shade100, // back
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Card(
              elevation: 4,
              color: Colors.white,
              child: InkWell(
                splashColor: Colors.purple,
                child: Container(
                  width: (mediaQuery.size.width / 2) - 50,
                  height: 150.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    // color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add_alt_rounded, color: Colors.purple.shade900, size: 60,),
                      SizedBox(height: 10,),
                      Text('mRegistrasiPas', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),).tr()
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdmRegistList(xtkn: xtkn)
                  ));
                },
              ),
            ),
            Card(
              elevation: 4,
              color: Colors.white,
              child: InkWell(
                splashColor: Colors.purple,
                child: Container(
                  width: (mediaQuery.size.width / 2) - 50,
                  height: 200.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    // color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.group, color: Colors.purple.shade900, size: 60,),
                      SizedBox(height: 10,),
                      Text('mKelolaPas', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),).tr()
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdmPasienList(xtkn: xtkn)
                  ));
                },
              ),
            )
          ]
        ),
      ),
    );
  }

  Widget _widgetMenu2(MediaQueryData mediaQuery) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Container(
        width: mediaQuery.size.width,
        height: 150.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          // color: Colors.blue.shade100, // back
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Card(
              elevation: 4,
              color: Colors.white,
              child: InkWell(
                splashColor: Colors.purple,
                child: Container(
                  width: (mediaQuery.size.width / 2) - 50,
                  height: 150.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    // color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified_user_rounded, color: Colors.purple.shade900, size: 60,),
                      SizedBox(height: 10,),
                      Text('mKelolaUser', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),).tr()
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdmUserList(xtkn: xtkn)
                  ));
                },
              ),
            ),
            Card(
              elevation: 4,
              color: Colors.white,
              child: InkWell(
                splashColor: Colors.purple,
                child: Container(
                  width: (mediaQuery.size.width / 2) - 50,
                  height: 200.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    // color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.medication, color: Colors.purple.shade900, size: 60,),
                      SizedBox(height: 10,),
                      Text('mKelolaDokter', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),).tr()
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdmDokterList(xtkn: xtkn)
                  ));
                },
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget _widgetMenu3(MediaQueryData mediaQuery) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Container(
        width: mediaQuery.size.width,
        height: 150.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          // color: Colors.blue.shade100, // back
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Card(
              elevation: 4,
              color: Colors.white,
              child: InkWell(
                splashColor: Colors.purple,
                child: Container(
                  width: (mediaQuery.size.width / 2) - 50,
                  height: 150.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    // color: Colors.cyan.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, color: Colors.purple.shade900, size: 60,),
                      SizedBox(height: 10,),
                      Text('kecamatan'.tr(), style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),)
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdmKecamatan(xtkn: xtkn)
                  ));
                },
              ),
            ),
            Card(
              elevation: 4,
              color: Colors.white,
              child: InkWell(
                splashColor: Colors.purple,
                child: Container(
                  width: (mediaQuery.size.width / 2) - 50,
                  height: 200.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    // color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.view_kanban_rounded, color: Colors.purple.shade900, size: 60,),
                      SizedBox(height: 10,),
                      Text('jp'.tr(), style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),)
                    ],
                  ),
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdmJP(xtkn: xtkn)
                  ));
                },
              ),
            )
          ]
        ),
      ),
    );
  }

  // Widget _widgetMenu4(MediaQueryData mediaQuery) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
  //     child: Container(
  //       width: mediaQuery.size.width,
  //       height: 150.0,
  //       decoration: BoxDecoration(
  //         shape: BoxShape.rectangle,
  //         // color: Colors.blue.shade100, // back
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         children: [
  //           Card(
  //             elevation: 4,
  //             color: Colors.white,
  //             child: InkWell(
  //               splashColor: Colors.purple,
  //               child: Container(
  //                 width: (mediaQuery.size.width) - 50,
  //                 height: 200.0,
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.rectangle,
  //                   // color: Colors.red.shade100,
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(Icons.list_alt, color: Colors.purple.shade900, size: 60,),
  //                     SizedBox(height: 10,),
  //                     Text('rekap'.tr(), style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),)
  //                   ],
  //                 ),
  //               ),
  //               onTap: (){
  //                 Navigator.of(context).push(MaterialPageRoute(
  //                   builder: (context) => AdmRekap(xtkn: xtkn)
  //                 ));
  //               },
  //             ),
  //           )
  //         ]
  //       ),
  //     ),
  //   );
  // }

}

// Menu Lama
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:goodcare/adm_dokter_list.dart';
// import 'package:goodcare/adm_download.dart';
// import 'package:goodcare/adm_kecamatan.dart';
// import 'package:goodcare/adm_pasien_list.dart';
// import 'package:goodcare/adm_profil.dart';
// import 'package:goodcare/adm_regist_list.dart';
// import 'package:goodcare/adm_rekap.dart';
// import 'package:goodcare/adm_user_list.dart';
// import 'package:goodcare/my_class.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Admins extends StatefulWidget {
//   final VoidCallback xlogOut;
//   const Admins({ Key? key, required this.xlogOut }) : super(key: key);

//   @override
//   _AdminsState createState() => _AdminsState();
// }

// class _AdminsState extends State<Admins> {
//   int _selectedIndexBNav = 0;
//   // String xbhs="en_US", xnmBHS="EN";

//   @override
//   void initState() {
//     super.initState();
//   }

//   // Future <void> getPref() async {
//   //   SharedPreferences pref = await SharedPreferences.getInstance();
//   //   xbhs = pref.getString("xbhs").toString();
//   // }

//   List<Widget> _widgetOption() => <Widget>[
//     HomeAdmin(xlogOut: widget.xlogOut),
//     AdmDownload(),
//     AdmProfil(xsignOut: widget.xlogOut,),
//   ];
  
//   Widget _bottomNavigation(){
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       currentIndex: _selectedIndexBNav,
//       backgroundColor: Colors.white,
//       selectedItemColor: Colors.purple.shade700,
//       unselectedItemColor: Colors.purple.shade900,
//       selectedFontSize: 16,
//       unselectedFontSize: 14,
//       onTap: (value){
//         setState(() => _selectedIndexBNav = value);
//       },
//       elevation: 0,
//       items: [
//         BottomNavigationBarItem(
//           label: "tabAdminHome".tr(),
//           icon: Icon(Icons.home),
//         ),
//         BottomNavigationBarItem(
//           label: "tabAdminLaporan".tr(),
//           icon: Icon(Icons.description_sharp),
//         ),
//         BottomNavigationBarItem(
//           label: "tabAdminProfil".tr(),
//           icon: Icon(Icons.account_circle),
//         ),
//       ],
      
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> children = _widgetOption();
//     return Scaffold(
//       body: children[_selectedIndexBNav],
//       bottomNavigationBar: _bottomNavigation(),
//     );
//   }
// }

// // ------------- Home

// class HomeAdmin extends StatefulWidget {
//   final VoidCallback xlogOut;
//   const HomeAdmin({ Key? key, required this.xlogOut }) : super(key: key);

//   @override
//   _HomeAdminState createState() => _HomeAdminState();
// }

// class _HomeAdminState extends State<HomeAdmin> {
//   String xidus='', xnmus='', xrole='', xtkn='';
//   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//   String xbhs="", xnmBHS="";
//   // String xbhs="en_US", xnmBHS="EN";

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
//       xbhs = pref.getString("xbhs") ?? 'en_US';
//       xnmBHS = pref.getString("xnmbhs") ?? 'EN';
//     });

//     print(xidus+' - '+xnmus+' - '+xrole+' - '+xtkn+' - '+xbhs);
//   }

//   @override
//   Widget build(BuildContext context) {
//     var mediaQuery = MediaQuery.of(context);
//     return Scaffold(
//       backgroundColor: Color(0xFFEEEEEE),
//       body: Stack(
//         children: <Widget>[
//           _widgetBgUp(mediaQuery),
//           _widgetLogo(mediaQuery),
//           _widgetMenu1(mediaQuery),
//           _widgetMenu2(mediaQuery),
//           _widgetMenu3(mediaQuery),
//         ],
//       )
//     );
//   }

//   Widget _widgetBgUp(MediaQueryData mediaQuery) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0, 0, 0, 10), //(left, top, right, bottom)
//       child: Container(
//         width: mediaQuery.size.width,
//         height: 180.0,
//         decoration: BoxDecoration(
//           shape: BoxShape.rectangle,
//           // borderRadius: BorderRadius.all(Radius.circular(20)),
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(35.0),
//             bottomRight: Radius.circular(35.0),
//           ),
//           // border: Border.all(color: Colors.purple),
//           color: Colors.purple.shade900,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             InkWell(
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 34.0, right: 24),
//                 child: Text(xnmBHS, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
//               ),
//               onTap: (){
//                 // context.setLocale(Locale('en_US'));
//                 // context.setLocale('en_US'.toLocale());
//                 if (xbhs=="en_US"){
//                   xbhs = "id";
//                   xnmBHS = "ID";
//                   // context.resetLocale();
//                   context.setLocale('id'.toLocale());
//                   // context.setLocale(Locale('id'));
//                   saveToPref("xbhs", "id");
//                   saveToPref("xnmbhs", "ID");
//                   print("Bahasa diubah ke "+xbhs+" - "+xnmBHS);
//                   setState(() {});
//                 } else {
//                   xbhs = "en_US";
//                   xnmBHS = "EN";
//                   // context.resetLocale();
//                   context.setLocale('en_US'.toLocale());
//                   // context.setLocale(Locale('en_US'));
//                   saveToPref("xbhs", "en_US");
//                   saveToPref("xnmbhs", "EN");
//                   print("Bahasa diubah ke "+xbhs+" - "+xnmBHS);
//                   setState(() {});
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _widgetLogo(MediaQueryData mediaQuery) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 60, 20, 10), //(left, top, right, bottom)
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
//               child: Text('welcome '+xrole, style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900)).tr(),
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
//       padding: const EdgeInsets.fromLTRB(20, 250, 20, 10),
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
//               color: Colors.white,
//               child: InkWell(
//                 splashColor: Colors.purple,
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
//                       Icon(Icons.person_add_alt_rounded, color: Colors.purple.shade900, size: 60,),
//                       SizedBox(height: 10,),
//                       Text('mRegistrasiPas', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),).tr()
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
//                       Icon(Icons.group, color: Colors.purple.shade900, size: 60,),
//                       SizedBox(height: 10,),
//                       Text('mKelolaPas', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),).tr()
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
//       padding: const EdgeInsets.fromLTRB(20, 404, 20, 10),
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
//               color: Colors.white,
//               child: InkWell(
//                 splashColor: Colors.purple,
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
//                       Icon(Icons.verified_user_rounded, color: Colors.purple.shade900, size: 60,),
//                       SizedBox(height: 10,),
//                       Text('mKelolaUser', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),).tr()
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
//               color: Colors.white,
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
//                       Icon(Icons.medication, color: Colors.purple.shade900, size: 60,),
//                       SizedBox(height: 10,),
//                       Text('mKelolaDokter', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),).tr()
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
//       padding: const EdgeInsets.fromLTRB(20, 560, 20, 10),
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
//               color: Colors.white,
//               child: InkWell(
//                 splashColor: Colors.purple,
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
//                       Icon(Icons.map, color: Colors.purple.shade900, size: 60,),
//                       SizedBox(height: 10,),
//                       Text('kecamatan'.tr(), style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),)
//                     ],
//                   ),
//                 ),
//                 onTap: (){
//                   Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => AdmKecamatan(xtkn: xtkn)
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
//                       Icon(Icons.list_alt, color: Colors.purple.shade900, size: 60,),
//                       SizedBox(height: 10,),
//                       Text('rekap'.tr(), style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900,),)
//                     ],
//                   ),
//                 ),
//                 onTap: (){
//                   Navigator.of(context).push(MaterialPageRoute(
//                     builder: (context) => AdmRekap(xtkn: xtkn)
//                   ));
//                 },
//               ),
//             )
//           ]
//         ),
//       ),
//     );
//   }

// }

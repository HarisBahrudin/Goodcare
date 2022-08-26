import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/adm_profil.dart';
import 'package:goodcare/ksr_history.dart';
import 'package:goodcare/ksr_obat_list.dart';
import 'package:goodcare/ksr_trans_add.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class Kasirs extends StatefulWidget {
  final VoidCallback xlogOut;
  const Kasirs({ Key? key, required this.xlogOut }) : super(key: key);

  @override
  _KasirsState createState() => _KasirsState();
}

class _KasirsState extends State<Kasirs> {
  int _selectedIndexBNav = 0;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _widgetOption() => <Widget>[
    HomeKasir(),
    KsrHistory(),
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
          label: "tabHistory".tr(),
          icon: Icon(Icons.history),
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

// --------- Home

class HomeKasir extends StatefulWidget {
  const HomeKasir({ Key? key,}) : super(key: key);

  @override
  _HomeKasirState createState() => _HomeKasirState();
}

class ModelRM{
  final String idrm, noreg, tgl, keluhan, idpas, nmpas, by, iddok, nmdok, diag, tdkn, norm;
  ModelRM(this.idrm, this.noreg, this.tgl, this.keluhan, this.idpas, this.nmpas, this.by, this.iddok, this.nmdok, this.diag, this.tdkn, this.norm);
}

class _HomeKasirState extends State<HomeKasir> {
  String xidus='', xnmus='', xrole='', xtkn='';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String xbhs="en_US", xnmBHS="EN";

  bool loading = false;
  List <ModelRM> list = [];

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
    });
    getRegList();
  }

  Future<void> getRegList() async {
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiRMListKsr), headers: {'Authorization':xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data.forEach((a) {
            final mp =ModelRM(a['idrm'], a['noreg'], a['tgl'], a['keluhan'], a['idpas'], a['nmpas'], a['by'], a['iddok'], a['nmdok'], a['diag'], a['tdkn'], a['norm']);
            list.add(mp);
          });
          // showToast(data['pesan']);
          // print(data['pesan']);
      } else {
        // showToast('Error. (code: '+respon.statusCode.toString()+')');
        print('Error. (code: '+respon.statusCode.toString()+')');
      }
    } on TimeoutException catch (_){
        showToast('Error. (connection timeout)');
    } on Error catch (e){
        // showToast('Error. ($e)');
        print(e);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      // backgroundColor: Colors.purple.shade50, // Color(0xFFEEEEEE),
      body: Stack(
        children: <Widget>[
          _widgetBgUp(mediaQuery),
          _widgetLogo(mediaQuery),
          _widgetMenu1a(mediaQuery),
          _widgetList(mediaQuery),
          // _widgetMenu3(mediaQuery),
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
                  context.setLocale('id'.toLocale());
                  saveToPref("xbhs", "id");
                } else {
                  xbhs = "en_US";
                  xnmBHS = "EN";
                  context.setLocale('en_US'.toLocale());
                  saveToPref("xbhs", "en_US");
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
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 10), //(left, top, right, bottom)
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

  Widget _widgetMenu1a(MediaQueryData mediaQuery) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 230, 20, 10),
      child: Container(
        width: mediaQuery.size.width,
        height: 100.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          // color: Colors.blue.shade100, // back
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 40,
                // width: (MediaQuery.of(context).size.width / 2) - 30,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.medication_outlined, color: Colors.purple.shade900, size: 26,),
                    SizedBox(width: 10,),
                    Text('kelolaobat'.tr(), style: TextStyle(color: Colors.purple.shade900)),
                  ],
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                  border: Border.all(color: Colors.purple),
                ),
              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => KsrObatList(xtkn: xtkn)
                ));
              },
            ),
          ]
        ),
      ),
    );
  }

  Widget _widgetList(MediaQueryData mediaQuery) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 300, 20, 0),
      child: loading ?
        Center(child: CircularProgressIndicator()) :
        list.length == 0 ? 
        Center(child: Text('nodata').tr()) :
        ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final x = list[i];
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: loading ?
                Center(child: CircularProgressIndicator()) :
                  Card(
                    child: Container(
                      height: 110,
                      child: ListTile(
                        leading: Icon(Icons.person_add_alt_rounded, color: Colors.purple.shade800, size: 40,),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(x.nmpas, style: TextStyle(fontSize: 18.0)),
                              Text(x.by=="Umum" ? "umum".tr() : x.by, style: TextStyle(fontSize: 16.0)),
                            ],
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('norm2'.tr()+': '+x.noreg, style: TextStyle(fontSize: 16.0)),
                                    Text('keluhan'.tr()+': '+x.keluhan, style: TextStyle(fontSize: 16.0)),
                                    Text('tindakan'.tr()+': '+x.tdkn, style: TextStyle(fontSize: 16.0)),
                                  ],
                                ),
                                InkWell(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Icon(Icons.keyboard_arrow_right_rounded),
                                      SizedBox(height: 22),
                                      Text('transaksi'.tr()+' >', style: TextStyle(fontSize: 16.0, color: Colors.purple.shade900)),
                                    ],
                                  ),
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => KsrTransAdd(xreload: getRegList, xtkn: xtkn, xidrm: x.idrm, xnoreg: x.noreg, xnorm: x.norm, xtgl: x.tgl, xnmpas: x.nmpas, xkeluhan: x.keluhan, xdiag: x.diag, xtindakan: x.tdkn)
                                    ));
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   border: Border(bottom: BorderSide(width: .5, color: Colors.black38)
                  // )
                // ),
              // ),
            );
          },
        ),
    );
  }
  /*
  Widget _widgetBgUp(MediaQueryData mediaQuery) {
    return Container(
      width: mediaQuery.size.width,
      height: 200.0,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35.0),
          bottomRight: Radius.circular(35.0),
        ),
        color: Colors.purple.shade800,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 30),
            child: Row(
              children: [
                Text('Good', style: TextStyle(fontSize: 34.0, color: Colors.blue.shade50)),
                Text('Care', style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold, color: Colors.red[200])),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 30),
            child: Text('Welcome '+xrole, style: TextStyle(fontSize: 18.0, color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2.0, left: 30),
            child: Text(xnmus, style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold)),
          ),

        ],
      ),
    );
  }

  Widget _widgetMenu1(MediaQueryData mediaQuery) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 230, 20, 10),
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
            InkWell(
              child: Container(
                width: (mediaQuery.size.width / 2) - 50,
                height: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.medication_outlined, color: Colors.orange.shade700, size: 60,),
                    SizedBox(height: 10,),
                    Text('Obat', style: TextStyle(fontSize: 18.0, color: Colors.orange.shade700,),)
                  ],
                ),
              ),
              onTap: (){
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => AdmPasienReg(xtkn: xtkn)
                // ));
              },
            ),
            InkWell(
              child: Container(
                width: (mediaQuery.size.width / 2) - 50,
                height: 200.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.medical_services_rounded, color: Colors.green.shade700, size: 60,),
                    SizedBox(height: 10,),
                    Text('Kategori Obat', style: TextStyle(fontSize: 18.0, color: Colors.green.shade700,),)
                  ],
                ),
              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AdmPasienList(xtkn: xtkn)
                ));
              },
            )
          ]
        ),
      ),
    );
  }

  Widget _widgetMenu2(MediaQueryData mediaQuery) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 400, 20, 10),
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
            InkWell(
              child: Container(
                width: (mediaQuery.size.width / 2) - 50,
                height: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.my_library_books_outlined, color: Colors.blue.shade700, size: 60,),
                    SizedBox(height: 10,),
                    Text('Transaksi Rawat Jalan', style: TextStyle(fontSize: 18.0, color: Colors.blue.shade700,),)
                  ],
                ),
              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AdmUserList(xtkn: xtkn)
                ));
              },
            ),
            Container(
              width: (mediaQuery.size.width / 2) - 50,
              height: 150.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.cyan.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.manage_accounts_rounded, color: Colors.cyan.shade700, size: 60,),
                  SizedBox(height: 10,),
                  Text('Profil Saya', style: TextStyle(fontSize: 18.0, color: Colors.cyan.shade700,),)
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget _widgetMenu3(MediaQueryData mediaQuery) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 570, 20, 10),
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
            
            InkWell(
              child: Container(
                width: (mediaQuery.size.width / 2) - 50,
                height: 200.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.red.shade700, size: 60,),
                    SizedBox(height: 10,),
                    Text('Logout', style: TextStyle(fontSize: 18.0, color: Colors.red.shade700,),)
                  ],
                ),
              ),
              onTap: (){
                dialogLogout(context);
              },
            )
          ]
        ),
      ),
    );
  }
  */


}
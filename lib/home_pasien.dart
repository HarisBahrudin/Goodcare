import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/ksr_history_view.dart';
import 'package:goodcare/pasien_profil.dart';
import 'package:goodcare/pasien_reg_rm_add.dart';
import 'package:goodcare/pasien_reg_rm_edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class Pasiens extends StatefulWidget {
  final VoidCallback xlogOut;
  const Pasiens({ Key? key, required this.xlogOut }) : super(key: key);

  @override
  _PasiensState createState() => _PasiensState();
}

class _PasiensState extends State<Pasiens> {
  int _selectedIndexBNav = 0;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _widgetOption() => <Widget>[
    HomePasien(),
    PasienProfil(xsignOut: widget.xlogOut,),
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

class HomePasien extends StatefulWidget {
  const HomePasien({ Key? key,}) : super(key: key);

  @override
  _HomePasienState createState() => _HomePasienState();
}

class ModelRMPas{
  final String idrm, noreg, norm, tgl, keluhan, jp, iddok, nmdok, diag, tdkn, bytdkn;
  ModelRMPas(this.idrm, this.noreg, this.norm, this.tgl, this.keluhan, this.jp, this.iddok, this.nmdok, this.diag, this.tdkn, this.bytdkn);
}

class _HomePasienState extends State<HomePasien> {
  String xidus='', xnmus='', xby='', xrole='', xtkn='';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String xbhs="en_US", xnmBHS="EN";

  bool loading = false;
  List <ModelRMPas> list = [];

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
      xby = pref.getString("xby") ?? ''; // asuransi
      xrole = pref.getString("xrole") ?? '';
      xtkn = pref.getString("xtkn") ?? '';
    });
    getRegList();
  }

  Future<void> getRegList() async {
    // print(MyApi.apiRMListPas+xidus);
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiRMHistPas+xidus));
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data.forEach((a) {
            final mp =ModelRMPas(a['idrm'], a['noreg'], a['norm'], a['tgl'], a['keluhan'], "", a['iddok'], a['nmdok'], a['diag'], a['tdkn'], a['bytdkn']);
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
              child: Text('welcome ', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900)).tr(),
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
                    Icon(Icons.app_registration, color: Colors.purple.shade900, size: 26,),
                    SizedBox(width: 10,),
                    Text('reg'.tr(), style: TextStyle(color: Colors.purple.shade900)),
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
                  builder: (context) => PasRegistRM(xreloadrm: getRegList, xidus: xidus)
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
        Center(child: Text('-nohistory-').tr()) :
        ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final x = list[i];
            return Card(
              child: Container(
                height: x.norm=="" ? 100 : 110,
                child: ListTile(
                  leading: x.norm=="" ? Icon(Icons.hourglass_bottom_outlined, color: Colors.indigo.shade800, size: 40,) : Icon(Icons.list_alt, color: Colors.purple.shade800, size: 40,),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(x.noreg),
                        Text(x.tgl), //, style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  subtitle: x.norm=="" ? 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('keluhan'.tr()+': '+x.keluhan, style: TextStyle(fontSize: 16.0)),
                              Text("menunggu", style: TextStyle(color: Colors.indigo)).tr(),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.purple.shade800, size: 20,),
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PasRegistRMEdit(xreloadrm: getRegList, xidrm: x.idrm, xidpas: xidus, xiddok: x.iddok, xnmdok: x.nmdok, xtgl: x.tgl, xkeluhan: x.keluhan, xnoreg: x.noreg)
                              ));
                            },
                          )
                        ],
                      ),
                    ],
                  ) :
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('norm2'.tr()+': '+x.norm, style: TextStyle(fontSize: 16.0)),
                              Text('keluhan'.tr()+': '+x.keluhan, style: TextStyle(fontSize: 16.0)),
                              Text('tindakan'.tr()+': '+x.tdkn, style: TextStyle(fontSize: 16.0)),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.keyboard_double_arrow_right_rounded, color: Colors.purple.shade800,),
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => KsrHIstoryView(xtkn: xtkn, xidrm: x.idrm, xnoreg: x.noreg, xnorm: x.norm, xtgl: x.tgl, xnmpas: xnmus, xkeluhan: x.keluhan, xjp: x.jp, xdiag: x.diag, xtindakan: x.tdkn, xby: "", xnmdok: x.nmdok, xbytdkn: x.bytdkn,)
                              ));
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
    );
  }

}
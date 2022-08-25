import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/adm_profil.dart';
import 'package:goodcare/adm_tindakan_list.dart';
import 'package:goodcare/dok_history.dart';
import 'package:goodcare/dok_rekam.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class Dokters extends StatefulWidget {
  final VoidCallback xlogOut;
  const Dokters({ Key? key, required this.xlogOut }) : super(key: key);

  @override
  _DoktersState createState() => _DoktersState();
}

class _DoktersState extends State<Dokters> {
  int _selectedIndexBNav = 0;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _widgetOption() => <Widget>[
    HomeDokter(),
    DokHistory(),
    AdmTindakanList(),
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
          label: "tabTindakan".tr(),
          icon: Icon(Icons.settings_accessibility_rounded),
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

// --- Home

class HomeDokter extends StatefulWidget {
  const HomeDokter({ Key? key}) : super(key: key);

  @override
  _HomeDokterState createState() => _HomeDokterState();
}

class ModelRM{
  final String idrm, noreg, tgl, keluhan, idpas, nmpas, by, iddok, nmdok;

  ModelRM(this.idrm, this.noreg, this.tgl, this.keluhan, this.idpas, this.nmpas, this.by, this.iddok, this.nmdok);
}

class _HomeDokterState extends State<HomeDokter> {
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

    print(xidus+' - '+xnmus+' - '+xrole+' - '+xtkn);
    getRegList();
  }

  Future<void> getRegList() async {
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiRMListDok+xidus), headers: {'Authorization':xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data.forEach((a) {
            final mp =ModelRM(a['idrm'], a['noreg'], a['tgl'], a['keluhan'], a['idpas'], a['nmpas'], a['by'], a['iddok'], a['nmdok']);
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
          _widgetList(mediaQuery),
          // _widgetMenu1a(mediaQuery),

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

  Widget _widgetList(MediaQueryData mediaQuery) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 250, 20, 0),
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
                      height: 100,
                      child: ListTile(
                        leading: Icon(Icons.person_add_alt_rounded, color: Colors.purple.shade800, size: 40,),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(x.nmpas, style: TextStyle(fontSize: 18.0)),
                              Text(x.by, style: TextStyle(fontSize: 16.0)),
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
                                    Text('noreg2'.tr()+': '+x.noreg, style: TextStyle(fontSize: 16.0)),
                                    Text('keluhan'.tr()+': '+x.keluhan, style: TextStyle(fontSize: 16.0)),
                                  ],
                                ),
                                // Icon(Icons.keyboard_arrow_right_rounded)
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Icon(Icons.keyboard_arrow_right_rounded),
                                    SizedBox(height: 20),
                                    Text('konsul'.tr()+' >', style: TextStyle(fontSize: 16.0, color: Colors.purple.shade900)),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DokRekam(xreload: getRegList, xtkn: xtkn, xidrm: x.idrm, xnoreg: x.noreg, xtgl: x.tgl, xnmpas: x.nmpas, xkeluhan: x.keluhan)
                          ));
                        },
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

}
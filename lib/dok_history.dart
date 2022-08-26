import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/ksr_history_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class DokHistory extends StatefulWidget {
  const DokHistory({ Key? key}) : super(key: key);

  @override
  _DokHistoryState createState() => _DokHistoryState();
}

class ModelRM{
  final String idrm, noreg, tgl, keluhan, jp, idpas, nmpas, by, iddok, nmdok, norm, tdkn, diag, bytdkn;
  ModelRM(this.idrm, this.noreg, this.tgl, this.keluhan, this.jp, this.idpas, this.nmpas, this.by, this.iddok, this.nmdok, this.norm, this.tdkn, this.diag, this.bytdkn);
}

// class ModelRM{
//   final String idrm, noreg, tgl, keluhan, idpas, nmpas, by, iddok, nmdok;
//   ModelRM(this.idrm, this.noreg, this.tgl, this.keluhan, this.idpas, this.nmpas, this.by, this.iddok, this.nmdok);
// }

class _DokHistoryState extends State<DokHistory> {
  bool loading = false;
  List <ModelRM> list = [];

  String xidus='', xnmus='', xrole='', xtkn='';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  
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
      final respon = await http.get(Uri.parse(MyApi.apiRMHistDok+xidus), headers: {'Authorization':xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data.forEach((a) {
            // final mp =ModelRM(a['idrm'], a['noreg'], a['tgl'], a['keluhan'], a['idpas'], a['nmpas'], a['by'], a['iddok'], a['nmdok']);
            final mp = ModelRM(a['idrm'], a['noreg'], a['tgl'], a['keluhan'], a['jp'], a['idpas'], a['nmpas'], a['by'], a['iddok'], a['nmdok'], a['norm'], a['tdkn'], a['diag'], a['bytdkn']);
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
    // var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: Text('riwayat'.tr(), style: TextStyle(color: Colors.white),),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                                      Text('noreg2'.tr()+': '+x.noreg, style: TextStyle(fontSize: 16.0)),
                                      Text('keluhan'.tr()+': '+x.keluhan, style: TextStyle(fontSize: 16.0)),
                                    ],
                                  ),
                                  InkWell(
                                    child: Icon(Icons.keyboard_arrow_right_rounded),
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => KsrHIstoryView(xtkn: xtkn, xidrm: x.idrm, xnoreg: x.noreg, xnorm: x.norm, xtgl: x.tgl, xnmpas: x.nmpas, xkeluhan: x.keluhan, xjp: x.jp, xdiag: x.diag, xtindakan: x.tdkn, xby: x.by, xnmdok: x.nmdok, xbytdkn: x.bytdkn,)
                                      ));
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => KsrHIstoryView(xtkn: xtkn, xidrm: x.idrm, xnoreg: x.noreg, xnorm: x.norm, xtgl: x.tgl, xnmpas: x.nmpas, xkeluhan: x.keluhan, xjp: x.jp, xdiag: x.diag, xtindakan: x.tdkn, xby: x.by, xnmdok: x.nmdok, xbytdkn: x.bytdkn,)
                            ));
                          },
                          // onTap: (){
                          //   Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => DokRekam(xreload: getRegList, xtkn: xtkn, xidrm: x.idrm, xnoreg: x.noreg, xtgl: x.tgl, xnmpas: x.nmpas, xkeluhan: x.keluhan)
                          //   ));
                          // },
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
      ),
    );
  }

  
}
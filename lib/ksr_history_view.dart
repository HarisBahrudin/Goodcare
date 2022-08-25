import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class KsrHIstoryView extends StatefulWidget {
  final String xtkn, xidrm, xnoreg, xnorm, xtgl, xnmpas, xkeluhan, xjp, xdiag, xtindakan, xby, xnmdok, xbytdkn;
  const KsrHIstoryView({ Key? key, required this.xtkn, required this.xidrm, required this.xnoreg, required this.xnorm, required this.xtgl, required this.xnmpas, required this.xkeluhan, required this.xjp, required this.xdiag, required this.xtindakan, required this.xby, required this.xnmdok, required this.xbytdkn}) : super(key: key);

  @override
  _KsrHIstoryViewState createState() => _KsrHIstoryViewState();
}

class ModelResep{
  final String idresep, nmobat, dosis, cttn, cek, hrg, hrgRp;
  ModelResep(this.idresep, this.nmobat, this.dosis, this.cttn, this.cek, this.hrg, this.hrgRp);
}

class _KsrHIstoryViewState extends State<KsrHIstoryView> {
  bool loading = false;
  List <ModelResep> list = [];
  int ttlby=0; //, by=0, bytdkn=0;

  @override
  void initState() {
    super.initState();
    getResepList();
  }

    void getResepList() async {
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiResepListKsr+widget.xidrm), headers: {'Authorization': widget.xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data['obat'].forEach((a) {
            final mp = ModelResep(a['idresep'], a['nmobat'], a['dosis'], a['cttn'], a['cek'], a['hrg'], a['hrgRp']);
            list.add(mp);
          });
          setState(() {
            ttlby = data['total'] + int.parse(widget.xbytdkn);
          });
          // print('total 1 ----------'+ttlby.toString());
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
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: Text('riwayat').tr(),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('noreg2'.tr(), style: TextStyle(fontSize: 18.0)),
                        Text(widget.xnoreg, style: TextStyle(fontSize: 16.0, color: Colors.purple.shade900)),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('norm'.tr(), style: TextStyle(fontSize: 18.0)),
                        Text(widget.xnorm, style: TextStyle(fontSize: 16.0, color: Colors.purple.shade900)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('tgl'.tr(), style: TextStyle(fontSize: 18.0)),
                        Text(widget.xtgl, style: TextStyle(fontSize: 16.0, color: Colors.purple.shade900)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('nmpas'.tr(), style: TextStyle(fontSize: 18.0)),
                        Text(widget.xnmpas, style: TextStyle(fontSize: 16.0, color: Colors.purple.shade900)),
                      ],
                    ),
                  ),
                  Divider(),
                  widget.xby=="" ? SizedBox() :
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('biaya'.tr(), style: TextStyle(fontSize: 18.0)),
                        Text(widget.xby=="Umum" ? "umum".tr() : widget.xby, style: TextStyle(fontSize: 16.0, color: Colors.purple.shade900)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('keluhan'.tr(), style: TextStyle(fontSize: 18.0)),
                        Text(widget.xkeluhan, style: TextStyle(fontSize: 16.0, color: Colors.purple.shade900)),
                      ],
                    ),
                  ),
                  widget.xjp=="" ?
                  SizedBox() :
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('jp'.tr(), style: TextStyle(fontSize: 18.0)),
                        Text(widget.xjp, style: TextStyle(fontSize: 16.0, color: Colors.purple.shade900)),
                      ],
                    ),
                  ),
                  
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('dokter'.tr(), style: TextStyle(fontSize: 18.0)),
                        Text(widget.xnmdok, style: TextStyle(fontSize: 16.0, color: Colors.purple.shade900)),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('hasildiagnosa'.tr(), style: TextStyle(fontSize: 18.0)),
                        Text(widget.xdiag, style: TextStyle(fontSize: 16.0, color: Colors.purple.shade900)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('tindakan'.tr(), style: TextStyle(fontSize: 18.0)),
                            Text(widget.xtindakan, style: TextStyle(fontSize: 16.0)),
                          ],
                        ),
                        // Text(, style: TextStyle(fontSize: 16.0)),
                        Text('Rp. '+NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(int.parse(widget.xbytdkn)), style: TextStyle(fontSize: 16.0, color: Colors.purple.shade900)),
                      ],
                    ),
                    // child: ListTile(
                    //   title: Text('Tindakan', style: TextStyle(fontSize: 18.0)),
                    //   subtitle: Text(widget.xtindakan, style: TextStyle(fontSize: 16.0)),
                    //   trailing: Text(widget.xbytdkn, style: TextStyle(fontSize: 16.0)),
                    // ),
                  ),
                  
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                    child: Text('resep'.tr(), style: TextStyle(fontSize: 18.0)),
                  ),
                  Divider(),
                  loading==true ?
                  Center(child: LinearProgressIndicator()) :
                  Column(
                    children: [
                      for (var i in list)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Container(
                          child: ListTile(
                            title: Text(i.nmobat+' ('+i.dosis+')', style: TextStyle(fontSize: 18.0)),
                            subtitle: Text('catatan'.tr()+': '+i.cttn, style: TextStyle(fontSize: 16.0)),
                            trailing: Text(i.hrgRp, style: TextStyle(fontSize: 16.0, color: Colors.purple.shade900)),
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            // border: Border(bottom: BorderSide(color: Colors.grey))
                          ),
                        )
                      )
                    ]
                  )
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 100),
            child: 
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('totalbiaya'.tr(), style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900)),
                    Text('Rp. '+NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0).format(ttlby), style: TextStyle(fontSize: 16.0, color: Colors.purple.shade900)),

                  ],
                ),
              ),
            ),
          ),



        ],
      ),
    );
  }

  // void childs(){
  //   final children = <Widget>[];
  //   for (var i=0; i<listResep.length; i++){
  //     children.add(
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(listResep[i].nmobat, style: TextStyle(fontSize: 18.0)),
  //             Text(listResep[i].dosis, style: TextStyle(fontSize: 16.0)),
  //           ],
  //         ),
  //       )
  //     );
  //   }

  // }

}
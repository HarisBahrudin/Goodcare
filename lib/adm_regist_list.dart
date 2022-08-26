import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/adm_regist_add.dart';
import 'package:goodcare/adm_regist_edit.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class AdmRegistList extends StatefulWidget {
  final String xtkn;
  const AdmRegistList({ Key? key, required this.xtkn }) : super(key: key);

  @override
  _AdmRegistListState createState() => _AdmRegistListState();
}

class ModelRM{
  final String idrm, noreg, tgl, keluhan, idpas, nmpas, by, iddok, nmdok;

  ModelRM(this.idrm, this.noreg, this.tgl, this.keluhan, this.idpas, this.nmpas, this.by, this.iddok, this.nmdok);
}

class _AdmRegistListState extends State<AdmRegistList> {
  bool loading = false;
  List <ModelRM> list = [];

  @override
  void initState() {
    super.initState();
    getRegList();
  }

  Future<void> getRegList() async {
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiRMListAdm), headers: {'Authorization':widget.xtkn});
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
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: Text('pasRegList').tr(),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: loading ?
        Center(child: CircularProgressIndicator()) :
        list.length == 0 ? 
        Center(child: Text('nodata').tr()) :
        ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final x = list[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              // child: 
              // Container(
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
                            Text('nomor'.tr()+": "+x.noreg, style: TextStyle(fontSize: 16.0)),
                            Text('dokter'.tr()+": "+x.nmdok, style: TextStyle(fontSize: 16.0)),
                            Text('keluhan'.tr()+": "+x.keluhan, style: TextStyle(fontSize: 16.0)),
                          ],
                        ),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AdmRegistEdit(xreloadrm: getRegList, xtkn: widget.xtkn, xidrm: x.idrm, xnoreg: x.noreg, xtgl: x.tgl, xidpas: x.idpas, xnmpas: x.nmpas, xby: x.by, xiddok: x.iddok, xnmdok: x.nmdok, xkeluhan: x.keluhan)
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
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom:30.0),
        child: FloatingActionButton(
          child: Icon(Icons.add, size: 30.0),
          backgroundColor: Colors.purple.shade900,
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AdmRegistAdd(xreloadrm: getRegList, xtkn: widget.xtkn)
            ));
          }
        ),
      ),
    );
  }
}
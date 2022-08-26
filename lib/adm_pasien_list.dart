
import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/adm_pasien_add.dart';
import 'package:goodcare/adm_pasien_edit.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class AdmPasienList extends StatefulWidget {
  final String xtkn;
  const AdmPasienList({ Key? key, required this.xtkn }) : super(key: key);

  @override
  _AdmPasienListState createState() => _AdmPasienListState();
}

class ModelPasien{
  final String id, nik, nm, jk, alamat, idkec, kec, tlp, umur, gd, by;
  ModelPasien(this.id, this.nik, this.nm, this.jk, this.alamat, this.idkec, this.kec, this.tlp, this.umur, this.gd, this.by);
}

class _AdmPasienListState extends State<AdmPasienList> {
  bool loading = false;
  List <ModelPasien> list = [];

  @override
  void initState() {
    super.initState();
    getPasien();
  }

  Future<void> getPasien() async {
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiPasienList), headers: {'Authorization':widget.xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data.forEach((a) {
            final mp = ModelPasien(a['id'], a['nik'], a['nm'], a['jk'], a['alamat'], a['idkec'], a['kec'], a['tlp'], a['umur'], a['gd'], a['by']);
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
        title: Text('datapas').tr(),
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
                    child: ListTile(
                      leading: Icon(Icons.account_circle, color: Colors.purple.shade900, size: 50,),
                      title: Text(x.nm, style: TextStyle(fontSize: 18.0)),
                      subtitle: Text(x.alamat, style: TextStyle(fontSize: 18.0)),
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AdmPasienEdit(xid: x.id, xreload: getPasien, xtkn: widget.xtkn, xnik: x.nik, xnm: x.nm, xjk: x.jk, xalamat: x.alamat, xidkec: x.idkec, xkec: x.kec, xtlp: x.tlp, xumur: x.umur, xgd: x.gd, xby: x.by,)
                        ));
                      },
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
              builder: (context) => AdmPasienAdd(xreload: getPasien, xtkn: widget.xtkn)
            ));
          }
        ),
      ),
    );
  }
}
import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/adm_dokter_add.dart';
import 'package:goodcare/adm_dokter_edit.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class AdmDokterList extends StatefulWidget {
  final String xtkn;
  const AdmDokterList({ Key? key, required this.xtkn }) : super(key: key);

  @override
  _AdmDokterListState createState() => _AdmDokterListState();
}

class ModelDokter{
  final String id, nm, jk, alamat, tlp, email;
  ModelDokter(this.id, this.nm, this.jk, this.alamat, this.tlp, this.email);
}

class _AdmDokterListState extends State<AdmDokterList> {
  bool loading = false;
  List <ModelDokter> list = [];

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiDokterList), headers: {'Authorization':widget.xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data.forEach((a) {
            final mp = ModelDokter(a['id'], a['nm'], a['jk'], a['alamat'], a['tlp'], a['email']);
            list.add(mp);
          });
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
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: Text('datadokter').tr(),
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
              child: Container(
                child: loading ?
                Center(child: CircularProgressIndicator()) :
                  ListTile(
                    leading: Icon(Icons.account_circle_outlined, color: Colors.purple.shade900, size: 50,),
                    title: Text(x.nm, style: TextStyle(fontSize: 18.0)),
                    subtitle: Text(x.tlp, style: TextStyle(fontSize: 18.0)),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdmDokterEdit(xid: x.id, xreload: getUser, xtkn: widget.xtkn, xnm: x.nm, xjk: x.jk, xalamat: x.alamat, xtlp: x.tlp, xemail: x.email)
                      ));
                    },
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(width: .5, color: Colors.black38)
                  )
                ),
              ),
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
              builder: (context) => AdmDokterAdd(xreload: getUser, xtkn: widget.xtkn)
            ));
          }
        ),
      ),
    );
  }
}
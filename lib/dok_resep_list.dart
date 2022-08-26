import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/dok_resep_cari_obat.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class DokResepList extends StatefulWidget {
  final VoidCallback xreloadjml;
  final String xtkn, xidrm;
  const DokResepList({ Key? key, required this.xreloadjml, required this.xtkn, required this.xidrm }) : super(key: key);

  @override
  _DokResepListState createState() => _DokResepListState();
}

class ModelResep{
  final String idres, idobat, nmobat, dosis, jml, sat; //, ktg;
  ModelResep(this.idres, this.idobat, this.nmobat, this.dosis, this.jml, this.sat); //, this.ktg);
}

class _DokResepListState extends State<DokResepList> {
  bool loading = false;
  List <ModelResep> list = [];
  String noresep = ''; // --------------------- array belum

  @override
  void initState() {
    super.initState();
    getResep();
  }

  Future<void> getResep() async {
    print('Get List Res ------------');
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiResepList+widget.xidrm), headers: {'Authorization':widget.xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data['resep'].forEach((a) {
            final mp = ModelResep(a['idresep'], a['idobat'], a['nmobat'], a['dosis'], a['jml'], a['sat']); //, a['ktg']);
            list.add(mp);
          });
          setState(() {
            noresep = data['noresep'];
          });
          widget.xreloadjml();
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
    print('noresep --------'+noresep);
  }

  void dialogHapus(BuildContext context, String id) async {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('andayakin?').tr(),
          actions: <Widget> [
            TextButton(
              child: Text("tidak").tr(),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("hapus").tr(),
              onPressed: (){
                Navigator.pop(context);
                goHapus(id);
              },
            )
          ],
        );
      }
    );
  }

  void goHapus(id) async {
    dialogLoading(context);
    try {
      final respon = await http.get(Uri.parse(MyApi.apiResepDel+id), headers: {'Authorization':widget.xtkn});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          showToast(data['pesan']);
          print(data['pesan']);
          getResep();
        } else {
          showToast(data['pesan']);
        }
      } else {
        showToast('Error. (code: '+respon.statusCode.toString()+')');
        print('Error. (code: '+respon.statusCode.toString()+')');
      }
    } on TimeoutException catch (_){
        showToast('Error. (connection timeout)');
    } on Error catch (e){
        showToast('Error. ($e)');
        print(e);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: Text('resep'.tr()+noresep),
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
                    leading: Icon(Icons.medication_outlined, color: Colors.purple.shade900, size: 50,),
                    title: Text(x.nmobat, style: TextStyle(fontSize: 18.0)),
                    subtitle: Text(x.dosis, style: TextStyle(fontSize: 18.0)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color:  Colors.purple.shade900,),
                      onPressed: (){
                        dialogHapus(context, x.idres);
                      }, 
                    ),
                    onTap: (){
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => AdmUserEdit(xid: x.id, xreload: getUser, xtkn: widget.xtkn, xnm: x.nm, xjk: x.jk, xalamat: x.alamat, xtlp: x.tlp, xemail: x.email, xrole: x.role,)
                      // ));
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
              builder: (context) => DokCariObat(xreloadresep: getResep, xtkn: widget.xtkn, xidrm: widget.xidrm, xnoresep: noresep,)
            ));
          }
        ),
      ),
    );
  }
}
import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class KsrResepList extends StatefulWidget {
  final String xtkn, xidrm;
  const KsrResepList({ Key? key, required this.xtkn, required this.xidrm }) : super(key: key);

  @override
  _KsrResepListState createState() => _KsrResepListState();
}

class ModelResep{
  final String idres, idobat, nmobat, dosis, jml, sat, cttn, cek;
  ModelResep(this.idres, this.idobat, this.nmobat, this.dosis, this.jml, this.sat, this.cttn, this.cek);
}

class _KsrResepListState extends State<KsrResepList> {
  bool loading = false;
  List <ModelResep> list = [];
  String cttn='';
  TextEditingController ctrCttn = TextEditingController();
  final _key = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getResep();
  }

  void getResep() async {
    print('Get List Res ------------');
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiResepListKsr+widget.xidrm), headers: {'Authorization':widget.xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data['obat'].forEach((a) {
            final mp = ModelResep(a['idresep'], a['idobat'], a['nmobat'], a['dosis'], a['jml'], a['sat'], a['cttn'], a['cek']);
            list.add(mp);
          });
          print(data);
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

  void dialogCatatan(BuildContext context, String id) async {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Catatan').tr(),
          content: Container(
            height: 80,
            child: Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (e) => cttn = e!,
                    controller: ctrCttn,
                    decoration: InputDecoration(
                      hintText: ""
                    ),
                  ),

                ],
              ),
            ),
          ),
          actions: <Widget> [
            TextButton(
              child: Text("batal").tr(),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("simpan").tr(),
              onPressed: (){
                Navigator.pop(context);
                goCheck(id);
              },
            )
          ],
        );
      }
    );
  }

  void goCheck(id) async {
    dialogLoading(context);
    try {
      final respon = await http.post(Uri.parse(MyApi.apiResepCheck), body: {'idres':id, 'cttn': ctrCttn.text}, headers: {'Authorization':widget.xtkn});
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
        title: Text('resep').tr(),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: loading ?
        Center(child: CircularProgressIndicator()) :
        list.length == 0 ? 
        Center(child: Text('-nodata-')) :
        ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final x = list[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Container(
                child: loading ?
                Center(child: CircularProgressIndicator()) :
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.medication_outlined, color: Colors.purple.shade900, size: 50,),
                      title: Text(x.nmobat, style: TextStyle(fontSize: 18.0)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          Text('sosis'.tr()+': '+x.dosis, style: TextStyle(fontSize: 18.0)),
                          Text('Catatan'.tr()+': '+x.cttn, style: TextStyle(fontSize: 18.0)),
                        ],
                      ),
                      trailing: IconButton(
                        icon: x.cek=='N' ? Icon(Icons.minimize, color: Colors.grey): Icon(Icons.check, color: Colors.purple.shade900, size: 30,),
                        onPressed: (){
                          dialogCatatan(context, x.idres);
                        }, 
                      ),
                      onTap: (){
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => AdmUserEdit(xid: x.id, xreload: getUser, xtkn: widget.xtkn, xnm: x.nm, xjk: x.jk, xalamat: x.alamat, xtlp: x.tlp, xemail: x.email, xrole: x.role,)
                        // ));
                      },
                    ),
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

    );
  }
}
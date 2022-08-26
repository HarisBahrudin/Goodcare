
import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class AdmJP extends StatefulWidget {
  final String xtkn;
  const AdmJP({ Key? key, required this.xtkn }) : super(key: key);

  @override
  _AdmJPState createState() => _AdmJPState();
}

class ModelJP{
  final String id, jp;
  ModelJP(this.id, this.jp);
}

class _AdmJPState extends State<AdmJP> {
  bool loading = false;
  List <ModelJP> list = [];

  final _key = new GlobalKey<FormState>();
  String jp='';
  TextEditingController ctrJP = TextEditingController();

  @override
  void initState() {
    super.initState();
    getJP();
  }

  Future<void> getJP() async {
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiJPList), headers: {'Authorization':widget.xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data.forEach((a) {
            final mp = ModelJP(a['id'], a['jp']);
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

  void dialogTambah(BuildContext context, String tipe, String id) async {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: tipe=='Tambah' ? Text('jpAdd'.tr()) : Text('jpEdit'.tr()),
          content: Container(
            height: 80,
            child: Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (e) => jp = e!,
                    controller: ctrJP,
                    decoration: InputDecoration(
                      hintText: "jp".tr()
                    ),
                    validator: (e){
                      if (e!.isEmpty){
                        return "required".tr();
                      }
                      return null;
                    },
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
                cekForm(tipe, id);
              },
            )
          ],
        );
      }
    );
  }
  
  void cekForm(String tipe, String id){
    final form = _key.currentState;
    if (form!.validate()){
      form.save();
      saveTdkn(tipe, id);
    }
  }

  void saveTdkn(String tipe, String id) async {
    dialogLoading(context);
    try {
      final respon = await http.post(Uri.parse(tipe=='Tambah' ? MyApi.apiJPAdd : MyApi.apiJPUpp), body: {'id': id, 'jp':jp}, headers: {'Authorization':widget.xtkn});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          showToast(data['pesan']);
          print(data['pesan']);
          getJP();
          Navigator.pop(context);
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
      final respon = await http.get(Uri.parse(MyApi.apiJPDel+id), headers: {'Authorization':widget.xtkn});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          showToast(data['pesan']);
          print(data['pesan']);
          getJP();
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
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: Text('jp').tr(),
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
              // child: 
              // Container(
                child: Card(
                    child: ListTile(
                      leading: Icon(Icons.view_kanban_rounded, color: Colors.purple.shade900, size: 30,),
                      title: Text(x.jp, style: TextStyle(fontSize: 18.0)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color:  Colors.purple.shade900,),
                        onPressed: (){
                          dialogHapus(context, x.id);
                        }, 
                      ),
                      onTap: (){
                        ctrJP.text = x.jp;
                        dialogTambah(context, 'Edit', x.id);
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
            ctrJP.text = '';
            dialogTambah(context, 'Tambah', '');
          }
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class AdmKecamatan extends StatefulWidget {
  final String xtkn;
  const AdmKecamatan({ Key? key, required this.xtkn }) : super(key: key);

  @override
  _AdmKecamatanState createState() => _AdmKecamatanState();
}

class ModelKec{
  final String id, kec;
  ModelKec(this.id, this.kec);
}

class _AdmKecamatanState extends State<AdmKecamatan> {
  bool loading = false;
  List <ModelKec> list = [];

  final _key = new GlobalKey<FormState>();
  String kec='';
  TextEditingController ctrKec = TextEditingController();

  @override
  void initState() {
    super.initState();
    getKec();
  }

  Future<void> getKec() async {
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiKecList), headers: {'Authorization':widget.xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data.forEach((a) {
            final mp = ModelKec(a['id'], a['kec']);
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
          title: tipe=='Tambah' ? Text('kecamatanAdd'.tr()) : Text('kecamatanEdit'.tr()),
          content: Container(
            height: 80,
            child: Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (e) => kec = e!,
                    controller: ctrKec,
                    decoration: InputDecoration(
                      hintText: "kecamatan".tr()
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
      final respon = await http.post(Uri.parse(tipe=='Tambah' ? MyApi.apiKecAdd : MyApi.apiKecUpp), body: {'id': id, 'kec':kec}, headers: {'Authorization':widget.xtkn});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          showToast(data['pesan']);
          print(data['pesan']);
          getKec();
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
      final respon = await http.get(Uri.parse(MyApi.apiKecDel+id), headers: {'Authorization':widget.xtkn});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          showToast(data['pesan']);
          print(data['pesan']);
          getKec();
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
        title: Text('kecamatan').tr(),
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
                      leading: Icon(Icons.map, color: Colors.purple.shade900, size: 30,),
                      title: Text(x.kec, style: TextStyle(fontSize: 18.0)),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color:  Colors.purple.shade900,),
                        onPressed: (){
                          dialogHapus(context, x.id);
                        }, 
                      ),
                      onTap: (){
                        ctrKec.text = x.kec;
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
            ctrKec.text = '';
            dialogTambah(context, 'Tambah', '');
          }
        ),
      ),
    );
  }
}
import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdmTindakanList extends StatefulWidget {
  // final String xtkn;
  const AdmTindakanList({ Key? key}) : super(key: key);

  @override
  _AdmTindakanListState createState() => _AdmTindakanListState();
}

class ModelTdkn{
  final String id, tdkn, by, byRp;
  ModelTdkn(this.id, this.tdkn, this.by, this.byRp);
}

// class ModelTdk{
//   final String id, tdkn;
//   ModelTdk(this.id, this.tdkn);
// }

class _AdmTindakanListState extends State<AdmTindakanList> {
  bool loading = false;
  List <ModelTdkn> list = [];

  final _key = new GlobalKey<FormState>();
  String by='', tdkn='';
  TextEditingController ctrTdkn = TextEditingController();
  TextEditingController ctrBy = TextEditingController();

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
      xrole = pref.getString("xrole") ?? '';
      xtkn = pref.getString("xtkn") ?? '';
    });
    getTdkn();
  }

  Future<void> getTdkn() async {
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiTindakanList), headers: {'Authorization':xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data.forEach((a) {
            final mp = ModelTdkn(a['id'], a['tindakan'], a['by'], a['byRp']);
            // final mp = ModelTdk(a['id'], a['tindakan']);
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
          title: tipe=='Tambah' ? Text('tambahTindakan').tr() : Text('ubahTindakan').tr(),
          content: Container(
            height: 140,
            child: Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (e) => tdkn = e!,
                    controller: ctrTdkn,
                    decoration: InputDecoration(
                      hintText: "tindakan".tr()
                    ),
                    validator: (e){
                      if (e!.isEmpty){
                        return "required".tr();
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onSaved: (e) => by = e!,
                    controller: ctrBy,
                    decoration: InputDecoration(
                      hintText: "biaya2".tr()
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
      final respon = await http.post(Uri.parse(tipe=='Tambah' ? MyApi.apiTindakanAdd : MyApi.apiTindakanUpp), body: {'id': id,'tindakan':tdkn, 'by':by}, headers: {'Authorization':xtkn});
      // final respon = await http.post(Uri.parse(tipe=='Tambah' ? MyApi.apiTindakanAdd : MyApi.apiTindakanUpp), body: {'id': id,'tindakan':tdkn}, headers: {'Authorization':xtkn});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          showToast(data['pesan']);
          print(data['pesan']);
          getTdkn();
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
      final respon = await http.get(Uri.parse(MyApi.apiTindakanDel+id), headers: {'Authorization':xtkn});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          showToast(data['pesan']);
          print(data['pesan']);
          getTdkn();
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
        title: Text('tindakan').tr(),
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
              child: loading ?
                Center(child: CircularProgressIndicator()) :
                Card(
                  child: ListTile(
                    // leading: Icon(Icons.account_circle_outlined, color: Colors.blue.shade800, size: 50,),
                    title: Text(x.tdkn, style: TextStyle(fontSize: 18.0)),
                    subtitle: Text(x.byRp, style: TextStyle(fontSize: 18.0)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, size: 20, color: Colors.purple.shade900,),
                      onPressed: (){
                        dialogHapus(context, x.id);
                      } 
                    ),
                    onTap: (){
                      setState(() {
                        ctrTdkn.text = x.tdkn; //ctrBy.text = x.by;
                      });
                      dialogTambah(context, 'Edit', x.id);
                    },
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
            ctrTdkn.text = ''; ctrBy.text = '';
            dialogTambah(context, 'Tambah', '');
          }
        ),
      ),
    );
  }
}
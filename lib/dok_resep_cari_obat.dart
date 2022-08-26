
import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class DokCariObat extends StatefulWidget {
  final VoidCallback xreloadresep;
  final String xtkn, xidrm, xnoresep;
  const DokCariObat({ Key? key, required this.xreloadresep, required this.xtkn, required this.xidrm, required this.xnoresep }) : super(key: key);

  @override
  _DokCariObatState createState() => _DokCariObatState();
}

class ModelObat{
  final String idobat, nm;
  ModelObat(this.idobat, this.nm);
}

class _DokCariObatState extends State<DokCariObat> {
  bool loading = false;
  List <ModelObat> list = [];

  final _key = new GlobalKey<FormState>();
  String dosis='';
  TextEditingController ctrDosis = TextEditingController();

  @override
  void initState() {
    super.initState();
    getObat();
  }

  void getObat() async {
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiObatList), headers: {'Authorization':widget.xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data.forEach((a) {
            // final mp = ModelObat(a['idobat'], a['nm'], a['sat'], a['hrg'], a['hrgRp'], a['idkat'], a['kat']);
            final mp = ModelObat(a['idobat'], a['nm']);
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

  void dialogDosis(BuildContext context, String id) async {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('dosis').tr(),
          content: Container(
            height: 80,
            child: Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (e) => dosis = e!,
                    controller: ctrDosis,
                    decoration: InputDecoration(
                      hintText: "3 x 1"
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
                cekForm(id);
              },
            )
          ],
        );
      }
    );
  }

  void cekForm(String id){
    final form = _key.currentState;
    if (form!.validate()){
      form.save();
      print('cek form -----------');
      Navigator.pop(context);
      saveResep(id);
    }
  }

  void saveResep(String id) async {
    print('Data ----------'+dosis+id+widget.xidrm+' no res :'+widget.xnoresep);
    dialogLoading(context);
    try {
      final respon = await http.post(Uri.parse(MyApi.apiResepAdd), body: {'idrm': widget.xidrm,'noresep':widget.xnoresep, 'idobat':id, 'dosis':dosis}, headers: {'Authorization':widget.xtkn});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          showToast(data['pesan']);
          print(data);
          widget.xreloadresep();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: Text('cariobat').tr(),
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
                      leading: Icon(Icons.medication_outlined, color: Colors.purple.shade900, size: 30,),
                      title: Text(x.nm, style: TextStyle(fontSize: 18.0)),
                      // subtitle: Text(x.nmkat, style: TextStyle(fontSize: 18.0)),
                      trailing: IconButton(
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                        onPressed: (){
                          print('dial dos');
                          dialogDosis(context, x.idobat);
                        },
                      ),
                    ),
                  ),
            );
          },
        ),
      ),
    );
  }
}
import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class KsrObatEdit extends StatefulWidget {
  final VoidCallback xreload;
  final String xtkn, xidobt, xnm, xhrg;
  const KsrObatEdit({ Key? key, required this.xreload, required this.xtkn, required this.xidobt, required this.xnm, required this.xhrg}) : super(key: key);
  // final String xtkn, xidobt, xnm, xhrg, xsat, xidkat, xnmkat;
  // const KsrObatEdit({ Key? key, required this.xreload, required this.xtkn, required this.xidobt, required this.xnm, required this.xhrg, required this.xsat, required this.xidkat, required this.xnmkat }) : super(key: key);

  @override
  _KsrObatEditState createState() => _KsrObatEditState();
}

class ModelKtg{
  final String id, ktg;
  ModelKtg(this.id, this.ktg);
}

class _KsrObatEditState extends State<KsrObatEdit> {
  bool loading = false;
  List <ModelKtg> list = [];

  final _key = new GlobalKey<FormState>();
  String nm='', sat='', hrg='', idktg='';
  TextEditingController ctrNm = TextEditingController();
  // TextEditingController ctrSat = TextEditingController();
  TextEditingController ctrHarga = TextEditingController();
  // TextEditingController ctrKtg = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ctrKtg.text = widget.xnmkat;
    ctrNm.text = widget.xnm;
    // ctrSat.text = widget.xsat;
    ctrHarga.text = widget.xhrg;
    // idktg = widget.xidkat;
    // getKtg();
  }

  void cekForm(){
    final form = _key.currentState;
    if (form!.validate()){
      form.save();
      saveObat();
    }
  }

  void saveObat() async {
    dialogLoading(context);
    try {
      // final respon = await http.post(Uri.parse(MyApi.apiObatUpp), body: {'id':widget.xidobt, 'nm':nm, 'sat':sat, 'hrg':hrg, 'idkat':idktg}, headers: {'Authorization':widget.xtkn});
      final respon = await http.post(Uri.parse(MyApi.apiObatUpp), body: {'id':widget.xidobt, 'nm':nm, 'hrg':hrg}, headers: {'Authorization':widget.xtkn});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          showToast(data['pesan']);
          print(data['pesan']);
          widget.xreload();
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

  void getKtg() async {
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiKtgList), headers: {'Authorization':widget.xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data.forEach((a) {
            final mp = ModelKtg(a['id'], a['ktg']);
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


  void dialogKtg(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Kategori"),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Container(
                    child: loading ?
                    Center(child: CircularProgressIndicator()) :
                      ListTile(
                        title: Text(x.ktg, style: TextStyle(fontSize: 18.0)),
                        onTap: (){
                          setState(() {
                            // idktg = x.id; ctrKtg.text = x.ktg;
                            idktg=='' ? showToast('Silahkan pilih kategori') :
                            Navigator.pop(context);
                          });
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
            )
          ),
        );
      }
    );
  }

  void dialogHapus(BuildContext context) async {
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
                goHapus(widget.xidobt);
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
      final respon = await http.get(Uri.parse(MyApi.apiObatDel+id), headers: {'Authorization':widget.xtkn});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          showToast(data['pesan']);
          print(data['pesan']);
          widget.xreload();
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
        title: Text('ubahObat').tr(),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: ctrNm,
                            onSaved: (e) => nm = e!,
                            decoration: InputDecoration(
                              labelText: "nmObat".tr(),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple.shade900),),
                              labelStyle: TextStyle(color: Colors.purple.shade900, fontSize: 18),
                              hintText: "",
                            ),
                            validator: (e){
                              if (e!.isEmpty){
                                return "required".tr();
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: ctrHarga,
                            onSaved: (e) => hrg = e!,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "harga".tr(),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple.shade900),),
                              labelStyle: TextStyle(color: Colors.purple.shade900, fontSize: 18),
                              hintText: "",
                            ),
                            validator: (e){
                              if (e!.isEmpty){
                                return "required".tr();
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height:10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 150,
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save, color: Colors.white),
                              SizedBox(width: 10.0),
                              Text('simpan'.tr(), style: TextStyle(color: Colors.white)),
                            ],
                          )),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.purple.shade900,
                          ),
                        ),
                        onTap: (){
                          cekForm();
                        },
                      ),

                      InkWell(
                        child: Container(
                          height: 50,
                          width: 120,
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              SizedBox(width: 10.0),
                              Text('hapus'.tr(), style: TextStyle(color: Colors.white)),
                            ],
                          )),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.red.shade900,
                          ),
                        ),
                        onTap: (){
                          dialogHapus(context);
                        },
                      ),
                    ],
                  ),

                ],
              ),
            ),

          )
        ],
      ),
    );
  }

}
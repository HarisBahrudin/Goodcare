import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/adm_jp.dart';
// import 'package:goodcare/adm_kecamatan.dart';
import 'package:goodcare/dok_resep_list.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class DokRekam extends StatefulWidget {
  final VoidCallback xreload;
  final String xtkn, xidrm, xnoreg, xtgl, xnmpas, xkeluhan;
  const DokRekam({ Key? key, required this.xreload, required this.xtkn, required this.xidrm, required this.xnoreg, required this.xtgl, required this.xnmpas, required this.xkeluhan }) : super(key: key);

  @override
  _DokRekamState createState() => _DokRekamState();
}

class ModelTindakan{
  final String id, tdkn;
  ModelTindakan(this.id, this.tdkn);
}

class _DokRekamState extends State<DokRekam> {
  bool loading = false;
  List <ModelTindakan> listTdkn = [];
  List <ModelJP> listJP = [];

  final _key = new GlobalKey<FormState>();
  String noreg='', norm='', nm='', keluhan='', diagnosa='', tindakan='', idtindakan='', idJP='', jmlresep='Loading..';
  TextEditingController ctrNoReg = TextEditingController();
  TextEditingController ctrNoRm = TextEditingController();
  TextEditingController ctrNm = TextEditingController();
  TextEditingController ctrKeluhan = TextEditingController();
  TextEditingController ctrJP = TextEditingController();
  TextEditingController ctrDiagnosa = TextEditingController();
  TextEditingController ctrTindakan = TextEditingController();
  // TextEditingController ctrGD = TextEditingController();

  @override
  void initState() {
    super.initState();
    ctrNoReg.text = widget.xnoreg;
    ctrNoRm.text = 'Loading..';
    ctrNm.text = widget.xnmpas;
    ctrKeluhan.text = widget.xkeluhan;
    getNoRM();
    getTindakan();
    getJmlResep();
    getJP();
  }

  void getTindakan() async {
    setState(() {
      loading = true;
    });
    listTdkn.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiTindakanList), headers: {'Authorization':widget.xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data.forEach((a) {
            final mp = ModelTindakan(a['id'], a['tindakan']);
            listTdkn.add(mp);
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

  Future <void> getJmlResep() async {
    setState(() {
      loading = true;
    });
    listTdkn.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiResepJml+widget.xidrm), headers: {'Authorization':widget.xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          setState(() {
            jmlresep = data['jml'];
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

  void dialogTindakan(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("pilihtindakan").tr(),
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: loading==true ?
              Center(child: CircularProgressIndicator()) : 
              ListView.builder(
              itemCount: listTdkn.length,
              itemBuilder: (context, i) {
                final x = listTdkn[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Container(
                    child: loading ?
                    Center(child: CircularProgressIndicator()) :
                      ListTile(
                        title: Text(x.tdkn, style: TextStyle(fontSize: 18.0)),
                        onTap: (){
                          setState(() {
                            idtindakan = x.id; ctrTindakan.text = x.tdkn;
                            idtindakan=='' ? showToast('pilihtindakan'.tr()) :
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

  void getNoRM() async {
    setState(() {
      loading = true;
    });
    try {
      final respon = await http.get(Uri.parse(MyApi.apiRMNmr+widget.xidrm), headers: {'Authorization':widget.xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          setState(() {
            norm = data['noreg'];
            ctrNoRm.text = data['noreg'];
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

  void cekForm(){
    final form = _key.currentState;
    if (form!.validate()){
      form.save();
      saveRM();
    }
  }

  void saveRM() async {
    print('Save RM ---------------------------');
    dialogLoading(context);
    try {
      final respon = await http.post(Uri.parse(MyApi.apiRMAdd), body: {'idrm':widget.xidrm, 'idjp':idJP, 'diag':diagnosa, 'idtind':idtindakan}, headers: {'Authorization':widget.xtkn});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          // showToast(data['pesan']);
          widget.xreload();
          Navigator.pop(context);

        } else {
          // showToast(data['pesan']);
        }
        print(data);
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
  
  void getJP() async {
    setState(() {
      loading = true;
    });
    listTdkn.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiJPList), headers: {'Authorization':widget.xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data.forEach((a) {
            final mp = ModelJP(a['id'], a['jp']);
            listJP.add(mp);
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

  void dialogJP(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("pilihjp").tr(),
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: loading==true ?
              Center(child: CircularProgressIndicator()) : 
              ListView.builder(
              itemCount: listJP.length,
              itemBuilder: (context, i) {
                final x = listJP[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Container(
                    child: loading ?
                    Center(child: CircularProgressIndicator()) :
                      ListTile(
                        title: Text(x.jp, style: TextStyle(fontSize: 18.0)),
                        onTap: (){
                          setState(() {
                            idJP = x.id; ctrJP.text = x.jp;
                            idJP=='' ? showToast('pilihjp'.tr()) :
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: Text('rm').tr(),
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
                    height: 240,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: ctrNoReg,
                            onSaved: (e) => noreg = e!,
                            decoration: InputDecoration(
                              labelText: "noreg".tr(),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple.shade900),),
                              labelStyle: TextStyle(color: Colors.purple.shade900, fontSize: 18),
                              hintText: "",
                            ),
                            enabled: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: ctrNoRm,
                            onSaved: (e) => norm= e!,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "norm".tr(),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple.shade900),),
                              labelStyle: TextStyle(color: Colors.purple.shade900, fontSize: 18),
                              hintText: "",
                            ),
                            enabled: false,
                            validator: (e){
                              if (e!.isEmpty){
                                return "loading...";
                              }
                              return null;
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: ctrNm,
                            onSaved: (e) => nm = e!,
                            decoration: InputDecoration(
                              labelText: "nmpas".tr(),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple.shade900),),
                              labelStyle: TextStyle(color: Colors.purple.shade900, fontSize: 18),
                              hintText: "",
                            ),
                            enabled: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: ctrKeluhan,
                            decoration: InputDecoration(
                              labelText: "keluhan".tr(),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple.shade900),),
                              labelStyle: TextStyle(color: Colors.purple.shade900, fontSize: 18),
                              hintText: "",
                            ),
                            enabled: false,
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
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 10),
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: ctrJP,
                            onSaved: (e) => diagnosa = e!,
                            decoration: InputDecoration(
                              labelText: "jp".tr(),
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
                            onTap: (){
                              FocusScope.of(context).requestFocus(FocusNode());
                              dialogJP(context);
                            }
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
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: ctrDiagnosa,
                            onSaved: (e) => diagnosa = e!,
                            decoration: InputDecoration(
                              labelText: "hasildiagnosa".tr(),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple.shade900),),
                              labelStyle: TextStyle(color: Colors.purple.shade900, fontSize: 18),
                              hintText: "",
                            ),
                            maxLines: 2,
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
                            controller: ctrTindakan,
                            onSaved: (e) => tindakan = e!,
                            decoration: InputDecoration(
                              labelText: "tindakan".tr(),
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
                            onTap: (){
                              FocusScope.of(context).requestFocus(FocusNode());
                              dialogTindakan(context);
                            }
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
                  InkWell(
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Icon(Icons.save, color: Colors.white),
                          // SizedBox(width: 10.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text('resep'.tr(), style: TextStyle(color: Colors.purple.shade900)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Text(jmlresep, style: TextStyle(color: Colors.purple.shade900)),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                        border: Border.all(color: Colors.purple),
                      ),
                    ),
                    onTap: (){
                      print(widget.xidrm);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DokResepList(xtkn: widget.xtkn, xidrm: widget.xidrm, xreloadjml: getJmlResep,)
                      ));
                    },
                  ),

                  SizedBox(height: 10,),
                  InkWell(
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save, color: Colors.white),
                          SizedBox(width: 10.0),
                          Text('Simpan', style: TextStyle(color: Colors.white)),
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

                ],
              ),
            ),

          )
        ],
      ),
    );
  }

}
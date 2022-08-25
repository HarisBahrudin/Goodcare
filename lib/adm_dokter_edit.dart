import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class AdmDokterEdit extends StatefulWidget {
  final VoidCallback xreload;
  final String xid, xnm, xjk, xalamat, xtlp, xemail, xtkn;
  const AdmDokterEdit({ Key? key, required this.xid, required this.xreload, required this.xtkn, required this.xnm, required this.xjk, required this.xalamat, required this.xtlp, required this.xemail}) : super(key: key);

  @override
  _AdmDokterEditState createState() => _AdmDokterEditState();
}

class _AdmDokterEditState extends State<AdmDokterEdit> {

  final _key = new GlobalKey<FormState>();
  String nm='', alamat='', tlp='', email='', jk='L';
  TextEditingController ctrNm = TextEditingController();
  TextEditingController ctrAlamat = TextEditingController();
  TextEditingController ctrTlp = TextEditingController();
  TextEditingController ctrEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    ctrNm.text = widget.xnm;
    ctrAlamat.text = widget.xalamat;
    ctrTlp.text = widget.xtlp;
    ctrEmail.text = widget.xemail;
    jk = widget.xjk;
  }

  void cekForm(){
    final form = _key.currentState;
    if (form!.validate()){
      form.save();
      savePasien();
    }
  }

  void savePasien() async {
    dialogLoading(context);
    try {
      final respon = await http.post(Uri.parse(MyApi.apiUserUpp), body: {'id':widget.xid, 'nm':nm, 'jk':jk, 'alamat':alamat, 'tlp':tlp, 'email':email, 'role':'Dokter'}, headers: {'Authorization':widget.xtkn});
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

  void dialogReset(BuildContext context, String id) async {
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
              child: Text("Reset"),
              onPressed: (){
                Navigator.pop(context);
                goReset(id);
              },
            )
          ],
        );
      }
    );
  }

  void goReset(id) async {
    dialogLoading(context);
    try {
      final respon = await http.get(Uri.parse(MyApi.apiUserReset+id), headers: {'Authorization':widget.xtkn});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          showToast(data['pesan']);
          print(data['pesan']);
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
              child: Text("iya").tr(),
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
      final respon = await http.get(Uri.parse(MyApi.apiUserDel+id), headers: {'Authorization':widget.xtkn});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          showToast(data['pesan']);
          print(data['pesan']);
          Navigator.pop(context);
          widget.xreload();
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
        title: Text('datadokterEdit').tr(),
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
                  TextFormField(
                    controller: ctrNm,
                    onSaved: (e) => nm = e!,
                    decoration: InputDecoration(
                      labelText: "nm".tr(),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple.shade900)),
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
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('jk'.tr(), style: TextStyle(color: Colors.purple.shade900)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Radio(value: 'L', groupValue: jk, onChanged: (value){
                            setState(() {
                              jk = value.toString();
                            });
                          }),
                          Text('lk').tr(),
                        ],
                      ),
                      
                      // SizedBox(width: 20,),
                      Row(
                        children: [
                          Radio(value: 'P', groupValue: jk, onChanged: (value){
                            setState(() {
                              jk = value.toString();
                            });
                          }),
                          Text('pr').tr(),
                        ],
                      ),
                      
                    ],
                  ),
                  TextFormField(
                    controller: ctrAlamat,
                    onSaved: (e) => alamat = e!,
                    decoration: InputDecoration(
                      labelText: "alamat".tr(),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple.shade900)),
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
                  TextFormField(
                    controller: ctrTlp,
                    onSaved: (e) => tlp = e!,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "tlp".tr(),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple.shade900)),
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
                  TextFormField(
                    controller: ctrEmail,
                    onSaved: (e) => email = e!,
                    decoration: InputDecoration(
                      labelText: "Username",
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple.shade900)),
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

                  SizedBox(height:10),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width-8,
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.purple.shade900)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save, color: Colors.white),
                          SizedBox(width: 10.0),
                          Text('simpan'.tr(), style: TextStyle(fontSize: 18.0, color: Colors.white)),
                        ],
                      ),
                      onPressed: (){
                        cekForm();
                      }
                    ),
                  ),
                  SizedBox(height:10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        width: (MediaQuery.of(context).size.width / 2) - 20,
                        child: ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.purple.shade900)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh, color: Colors.white),
                              SizedBox(width: 10.0),
                              Text('Reset Password', style: TextStyle(fontSize: 18.0, color: Colors.white)),
                            ],
                          ),
                          onPressed: (){
                            dialogReset(context, widget.xid);
                          }
                        ),
                      ),
                      Container(
                        height: 40,
                        width: (MediaQuery.of(context).size.width / 2) - 20,
                        child: ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red.shade900)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              SizedBox(width: 10.0),
                              Text('hapus'.tr(), style: TextStyle(fontSize: 18.0, color: Colors.white)),
                            ],
                          ),
                          onPressed: (){
                            dialogHapus(context, widget.xid);
                          }
                        ),
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
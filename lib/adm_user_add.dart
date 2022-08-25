import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class AdmUserAdd extends StatefulWidget {
  final VoidCallback xreload;
  final String xtkn;
  const AdmUserAdd({ Key? key, required this.xreload, required this.xtkn }) : super(key: key);

  @override
  _AdmUserAddState createState() => _AdmUserAddState();
}

class _AdmUserAddState extends State<AdmUserAdd> {

  final _key = new GlobalKey<FormState>();
  String nm='', alamat='', tlp='', email='', pwd='12345', role='Admin', jk='L';
  TextEditingController ctrNm = TextEditingController();
  TextEditingController ctrAlamat = TextEditingController();
  TextEditingController ctrTlp = TextEditingController();
  TextEditingController ctrEmail = TextEditingController();
  TextEditingController ctrPwd = TextEditingController();

  void cekForm(){
    final form = _key.currentState;
    if (form!.validate()){
      form.save();
      saveUser();
    }
  }

  void saveUser() async {
    dialogLoading(context);
    try {
      final respon = await http.post(Uri.parse(MyApi.apiUserAdd), body: {'nm':nm, 'jk':jk, 'alamat':alamat, 'tlp':tlp, 'email':email, 'pwd':pwd, 'role':role}, headers: {'Authorization':widget.xtkn});
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
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: Text('dataUsAdd').tr(),
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
                          Text('lk'.tr(), style: TextStyle(color: Colors.purple.shade900)),
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
                          Text('pr'.tr(), style: TextStyle(color: Colors.purple.shade900)),
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
                  TextFormField(
                    controller: ctrPwd,
                    onSaved: (e) => pwd = e!,
                    decoration: InputDecoration(
                      labelText: "Password",
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
                      Text('Role', style: TextStyle(color: Colors.purple.shade900)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Radio(value: 'Admin', groupValue: role, onChanged: (value){
                            setState(() {
                              role = value.toString();
                            });
                          }),
                          Text('Admin'),
                        ],
                      ),
                      
                      // SizedBox(width: 20,),
                      Row(
                        children: [
                          Radio(value: 'Kasir', groupValue: role, onChanged: (value){
                            setState(() {
                              role = value.toString();
                            });
                          }),
                          Text('kasir').tr(),
                        ],
                      ),
                      
                    ],
                  ),

                  SizedBox(height:10),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width - 8,
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

                ],
              ),
            ),

          )
        ],
      ),
    );
  }

}
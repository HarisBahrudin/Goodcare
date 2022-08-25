import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdmProfil extends StatefulWidget {
  final VoidCallback xsignOut;
  const AdmProfil({ Key? key, required this.xsignOut}) : super(key: key);

  @override
  _AdmProfilState createState() => _AdmProfilState();
}

class _AdmProfilState extends State<AdmProfil> {
  String xidus='', xnmus='', xrole='', xtkn='', xalamat='', xtlp='', xusnm='';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final _key = new GlobalKey<FormState>();
  String textVal='', pwdl='', pwdb='';
  TextEditingController ctrVal = TextEditingController();
  TextEditingController ctrPwdL = TextEditingController();
  TextEditingController ctrPwdB = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    getPref();
  }

  void getPref() async {
    final SharedPreferences pref = await _prefs;
    setState(() {
      xidus = pref.getString("xidus") ?? '';
      xnmus = pref.getString("xnmus") ?? '';
      xalamat = pref.getString("xalamat") ?? '';
      xtlp = pref.getString("xtlp") ?? '';
      xusnm = pref.getString("xemail") ?? '';
      xrole = pref.getString("xrole") ?? '';
      xtkn = pref.getString("xtkn") ?? '';
    });
  }

  void dialogLogout(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('andayakin?').tr(),
          actions: <Widget> [
            TextButton(
              child: Text("tidak", style: TextStyle(color: Colors.purple.shade900),).tr(),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("iya", style: TextStyle(color: Colors.purple.shade900),).tr(),
              onPressed: (){
                widget.xsignOut();
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );
  }

  void dialogInput(BuildContext context, String tipe) async {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text(tipe=="Nama" ? "nm" : tipe=="Alamat" ? "alamat" : tipe=="Tlp" ? "tlp" : tipe).tr(),
          content: Container(
            height: 80,
            child: Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (e) => textVal = e!,
                    controller: ctrVal,
                    decoration: InputDecoration(
                      hintText: ""
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
                cekForm(tipe);
              },
            )
          ],
        );
      }
    );
  }
  
  void cekForm(String tipe){
    final form = _key.currentState;
    if (form!.validate()){
      form.save();
      upProfil(tipe);
    }
  }

  void upProfil(String tipe) async {
    dialogLoading(context);
    try {
      final respon = await http.post(Uri.parse(tipe=='Username' ? MyApi.apiProfilUpEmail : MyApi.apiProfilUp), body: {'idus': xidus,'val':textVal, 'jenis': tipe}, headers: {'Authorization':xtkn});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          showToast(data['pesan']);
          print(data['pesan']);
          if (tipe=='Nama'){
            saveToPref('xnmus', textVal);
            setState(() {
              xnmus = textVal;
            });
          } else if (tipe=='Alamat'){
            saveToPref('xalamat', textVal);
            setState(() {
              xalamat = textVal;
            });
          } else if (tipe=='Tlp'){
            saveToPref('xtlp', textVal);
            setState(() {
              xtlp = textVal;
            });
          } else if (tipe=='Username'){
            saveToPref('xemail', textVal);
            setState(() {
              xusnm = textVal;
            });
          }
          // getPref();
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

  // ------- PWD
  void dialogPwd(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('ubahPwd').tr(),
          content: Container(
            height: 120,
            child: Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (e) => pwdl = e!,
                    controller: ctrPwdL,
                    decoration: InputDecoration(
                      hintText: ""
                    ),
                    validator: (e){
                      if (e!.isEmpty){
                        return "required".tr();
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    onSaved: (e) => pwdb = e!,
                    controller: ctrPwdB,
                    decoration: InputDecoration(
                      hintText: ""
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
                cekFormPwd();
              },
            )
          ],
        );
      }
    );
  }
  
  void cekFormPwd(){
    final form = _key.currentState;
    if (form!.validate()){
      form.save();
      upPwd();
    }
  }

  void upPwd() async {
    dialogLoading(context);
    try {
      final respon = await http.post(Uri.parse(MyApi.apiProfilUpPwd), body: {'idus': xidus,'pwdl':pwdl, 'pwdb': pwdb}, headers: {'Authorization':xtkn});
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

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: Text('tabAdminProfil', style: TextStyle(color: Colors.white),).tr(),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          _widgetBgUp(mediaQuery),
          _widgetFoto(),
          _widgetList(),

        ],
      )
    );
  }

  Widget _widgetBgUp(MediaQueryData mediaQuery) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10), //(left, top, right, bottom)
      child: Container(
        width: mediaQuery.size.width,
        height: 90.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          // borderRadius: BorderRadius.all(Radius.circular(20)),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(35.0),
            bottomRight: Radius.circular(35.0),
          ),
          // border: Border.all(color: Colors.purple),
          color: Colors.purple.shade900,
        ),
      ),
    );
  }

  Widget _widgetFoto() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 10), //(left, top, right, bottom)
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 140.0,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          // borderRadius: BorderRadius.all(Radius.circular(20)),
          // borderRadius: BorderRadius.only(
          //   bottomLeft: Radius.circular(35.0),
          //   bottomRight: Radius.circular(35.0),
          // ),
          // border: Border.all(color: Colors.purple),
          // color: Colors.purple.shade900,
        ),
        child: Column(
          children: [
            Container(
              width: 200,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                // border: Border.all(color: Colors.purple),
              ),
              child: Icon(Icons.account_circle, size: 120, color: Colors.purple.shade900,),
            ),
          ],
        ),
      ),
    );
  }

  Widget _widgetList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 160, 12, 0), //(left, top, right, bottom)
      child: Container(
        height: 700.0,
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.purple),
        ),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Text('nm', style: TextStyle(color: Colors.grey.shade700),).tr(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                        child: Text(xnmus, style: TextStyle(fontSize: 16, color: Colors.purple.shade900),),
                      )
                    ],
                  ),
                  InkWell(
                    child: Icon(Icons.edit, size: 16, color: Colors.purple.shade900,),
                    onTap: (){
                      setState(() {
                        ctrVal.text = xnmus;
                      });
                      dialogInput(context, 'Nama');
                    },
                  )
                ],
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Text('alamat').tr(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                        child: Text(xalamat, style: TextStyle(fontSize: 16, color: Colors.purple.shade900),),
                      )
                    ],
                  ),
                  InkWell(
                    child: Icon(Icons.edit, size: 16, color: Colors.purple.shade900,),
                    onTap: (){
                      setState(() {
                        ctrVal.text = xalamat;
                      });
                      dialogInput(context, 'Alamat');
                    },
                  )
                ],
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
            ),

            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Text('tlp', style: TextStyle(color: Colors.grey.shade700),).tr(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                        child: Text(xtlp, style: TextStyle(fontSize: 16, color: Colors.purple.shade900),),
                      )
                    ],
                  ),
                  InkWell(
                    child: Icon(Icons.edit, size: 16, color: Colors.purple.shade900,),
                    onTap: (){
                      setState(() {
                        ctrVal.text = xtlp;
                      });
                      dialogInput(context, 'Tlp');
                    },
                  )
                ],
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
            ),

            SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Text('Username', style: TextStyle(color: Colors.grey.shade700),),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                        child: Text(xusnm, style: TextStyle(fontSize: 16, color: Colors.purple.shade900),),
                      )
                    ],
                  ),
                  InkWell(
                    child: Icon(Icons.edit, size: 16, color: Colors.purple.shade900,),
                    onTap: (){
                      setState(() {
                        ctrVal.text = xusnm;
                      });
                      dialogInput(context, 'Username');
                    },
                  )
                ],
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
            ),
            
            SizedBox(height: 10,),
            InkWell(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('ubahPwd', style: TextStyle(color: Colors.purple.shade900)).tr()),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  // color: Colors.purple.shade900,
                  color: Colors.white,
                  border: Border.all(color: Colors.purple),
                ),
              ),
              onTap: (){
                dialogPwd(context);
              },
            ),

            SizedBox(height: 10,),
            InkWell(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('logout'.tr(), style: TextStyle(color: Colors.red.shade900))),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  // color: Colors.purple.shade900,
                  color: Colors.white,
                  border: Border.all(color: Colors.purple),
                ),
              ),
              onTap: (){
                dialogLogout(context);
              },
            ),

            // InkWell(
            //   child: RaisedGradientButton(
            //     child: Text('Sign Out', style: TextStyle(color: Colors.white),
            //     ),
            //     gradient: LinearGradient(
            //       colors: <Color>[Colors.red.shade900, Colors.red.shade600],
            //     ),
            //   ),
            //   onTap: (){

            //   },
            // ),

          ],
        ),
      ),
    );
  }


}

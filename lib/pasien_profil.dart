import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/adm_kecamatan.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PasienProfil extends StatefulWidget {
  final VoidCallback xsignOut;
  const PasienProfil({ Key? key, required this.xsignOut}) : super(key: key);

  @override
  _PasienProfilState createState() => _PasienProfilState();
}

class _PasienProfilState extends State<PasienProfil> {
  bool loading=false;
  String xidus='', xnmus='', xrole='', xtkn='', xalamat='', xkec='', xtlp='', xumur='', xgold='', xusnm='';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final _key = new GlobalKey<FormState>();
  String textVal='', pwdl='', pwdb='', xnmkec='';
  TextEditingController ctrVal = TextEditingController();
  TextEditingController ctrPwdL = TextEditingController();
  TextEditingController ctrPwdB = TextEditingController();
  List <ModelKec> list = [];
  
  @override
  void initState() {
    super.initState();
    getPref();
  }

  void getPref() async {
    final SharedPreferences pref = await _prefs;
    setState(() {
      xidus = pref.getString("xidus") ?? '';
    });
    getData();
    getKec();
  }

  void getData() async {
    setState(() {
      loading=true;
    });
    try {
      final respon = await http.get(Uri.parse(MyApi.apiPasienProfil+xidus));
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          xnmus = data['nm'];
          xalamat = data['alamat'];
          xkec = data['kec'];
          xtlp = data['tlp'];
          xumur = data['umur'];
          xgold = data['gold'];
          xusnm = data['email'];
          print(data['pesan']);

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
    setState(() {
      loading=false;
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
          title: Text(tipe=="Nama" ? "nm" : tipe=="Alamat" ? "alamat" : tipe=="Kota" ? "kota" : tipe=="Tlp" ? "tlp" : tipe=="Umur" ? "umur" : tipe=="Golongan Darah" ? "golDr" : tipe).tr(),
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
      final respon = await http.post(Uri.parse(tipe=='Username' ? MyApi.apiPasienProfilUppEmail : MyApi.apiPasienProfilUppData), body: {'idus': xidus,'val':textVal, 'jenis': tipe});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          showToast(data['pesan']);
          print(data);
          if (tipe=='Nama'){
            setState(() {
              xnmus = textVal;
            });
          } else if (tipe=='Alamat'){
            setState(() {
              xalamat = textVal;
            });
          } else if (tipe=='Kecamatan'){
            setState(() {
              xkec = xnmkec;
            });
          } else if (tipe=='Tlp'){
            setState(() {
              xtlp = textVal;
            });
          } else if (tipe=='Umur'){
            setState(() {
              xumur = textVal;
            });
          } else if (tipe=='Golongan Darah'){
            setState(() {
              xgold = textVal;
            });
          } else if (tipe=='Username'){
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
      final respon = await http.post(Uri.parse(MyApi.apiPasienProfilUppPwd), body: {'idus': xidus,'pwdl':pwdl, 'pwdb': pwdb});
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

  void getKec() async {
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiKecList));
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

  void dialogKec(BuildContext context, String tipe) async {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("kecamatan").tr(),
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
                        title: Text(x.kec, style: TextStyle(fontSize: 18.0)),
                        onTap: (){
                          setState(() {
                            textVal = x.id;
                            xnmkec = x.kec;
                            textVal=='' ? showToast('pilihkecamatan'.tr()) :
                            // Navigator.pop(context);
                            upProfil(tipe);
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
        child: loading==true ?
          Center(child: CircularProgressIndicator()) :
          ListView(
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
                        child: Text('kecamatan').tr(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                        child: Text(xkec, style: TextStyle(fontSize: 16, color: Colors.purple.shade900),),
                      )
                    ],
                  ),
                  InkWell(
                    child: Icon(Icons.edit, size: 16, color: Colors.purple.shade900,),
                    onTap: (){
                      // setState(() {
                      //   ctrVal.text = xkec;
                      // });
                      // dialogInput(context, 'Kota');
                      dialogKec(context, "Kecamatan");
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
                        child: Text('umur').tr(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                        child: Text(xumur, style: TextStyle(fontSize: 16, color: Colors.purple.shade900),),
                      )
                    ],
                  ),
                  InkWell(
                    child: Icon(Icons.edit, size: 16, color: Colors.purple.shade900,),
                    onTap: (){
                      setState(() {
                        ctrVal.text = xumur;
                      });
                      dialogInput(context, 'Umur');
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
                        child: Text('golDr').tr(),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 2, 8, 0),
                        child: Text(xgold, style: TextStyle(fontSize: 16, color: Colors.purple.shade900),),
                      )
                    ],
                  ),
                  InkWell(
                    child: Icon(Icons.edit, size: 16, color: Colors.purple.shade900,),
                    onTap: (){
                      setState(() {
                        ctrVal.text = xgold;
                      });
                      dialogInput(context, 'Golongan Darah');
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


          ],
        ),
      ),
    );
  }


}

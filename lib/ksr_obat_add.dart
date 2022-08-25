import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class KsrObatAdd extends StatefulWidget {
  final VoidCallback xreload;
  final String xtkn;
  const KsrObatAdd({ Key? key, required this.xreload, required this.xtkn }) : super(key: key);

  @override
  _KsrObatAddState createState() => _KsrObatAddState();
}

// class ModelKtg{
//   final String id, ktg;
//   ModelKtg(this.id, this.ktg);
// }

class _KsrObatAddState extends State<KsrObatAdd> {
  bool loading = false;
  // List <ModelKtg> list = [];

  final _key = new GlobalKey<FormState>();
  String nm='', sat='', hrg='', idktg='';
  TextEditingController ctrNm = TextEditingController();
  // TextEditingController ctrSat = TextEditingController();
  TextEditingController ctrHarga = TextEditingController();
  // TextEditingController ctrKtg = TextEditingController();

  @override
  void initState() {
    super.initState();
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
      // final respon = await http.post(Uri.parse(MyApi.apiObatAdd), body: {'nm':nm, 'sat':sat, 'hrg':hrg, 'idkat':idktg}, headers: {'Authorization':widget.xtkn});
      final respon = await http.post(Uri.parse(MyApi.apiObatAdd), body: {'nm':nm, 'hrg':hrg}, headers: {'Authorization':widget.xtkn});
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
        title: Text('tambahObat').tr(),
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

                ],
              ),
            ),

          )
        ],
      ),
    );
  }

}
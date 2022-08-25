import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/adm_regist_add.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class PasRegistRM extends StatefulWidget {
  final VoidCallback xreloadrm;
  final String xidus; //, xnm, xasuransi;
  const PasRegistRM({ Key? key, required this.xreloadrm, required this.xidus}) : super(key: key);
  // const PasRegistRM({ Key? key, required this.xreloadrm, required this.xidus, required this.xnm, required this.xasuransi }) : super(key: key);

  @override
  _PasRegistRMState createState() => _PasRegistRMState();
}

class _PasRegistRMState extends State<PasRegistRM> {
  bool loading = false;
  List <ModelDokter> listDokter = [];

  final _key = new GlobalKey<FormState>();
  String idpas='', nmpas='', iddok='', nmdok='', keluhan='', by='';
  String xtgl='', xbln='', xthn='';
  TextEditingController ctrNoReg = TextEditingController();
  TextEditingController ctrBy = TextEditingController();
  TextEditingController ctrNmPas = TextEditingController();
  TextEditingController ctrTgl = TextEditingController();
  TextEditingController ctrNmDok = TextEditingController();
  TextEditingController ctrKeluhan = TextEditingController();

  @override
  void initState() {
    super.initState();
    ctrNoReg.text = 'Loading..';
    idpas = widget.xidus;
    // ctrNmPas.text = widget.xnm;
    // ctrBy.text = widget.xasuransi;
    ctrNmDok.text = 'pilih'.tr();
    ctrKeluhan.text = ' ';
    xtgl = DateFormat('dd').format(DateTime.now());
    xbln = DateFormat('MM').format(DateTime.now());
    xthn = DateFormat.y().format(DateTime.now());
    ctrTgl.text = xtgl+'-'+xbln+'-'+xthn;
    getNoReg();
    getDokter();
  }

  void getNoReg() async {
    setState(() {
      loading = true;
    });
    try {
      final respon = await http.get(Uri.parse(MyApi.apiRMRegNmr));
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          setState(() {
            ctrNoReg.text = data['noreg'];
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

  void getDokter() async {
    setState(() {
      loading = true;
    });
    listDokter.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiDokterList));
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data.forEach((a) {
            final mp = ModelDokter(a['id'], a['nm']);
            listDokter.add(mp);
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

  void cekForm(){
    final form = _key.currentState;
    if (form!.validate()){
      form.save();
      saveReg();
    }
  }

  void saveReg() async {
    print(ctrTgl.text);
    dialogLoading(context);
    try {
      final respon = await http.post(Uri.parse(MyApi.apiRMRegAdd), body: {'noreg':ctrNoReg.text, 'tgl':ctrTgl.text, 'idpas':idpas, 'iddok':iddok, 'keluhan':keluhan});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          showToast(data['pesan']);
          print(data['pesan']);
          widget.xreloadrm();
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

  void dialogDokter(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("dokter").tr(),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: listDokter.length,
              itemBuilder: (context, i) {
                final x = listDokter[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Container(
                    child: loading ?
                    Center(child: CircularProgressIndicator()) :
                      ListTile(
                        title: Text(x.nm, style: TextStyle(fontSize: 18.0)),
                        onTap: (){
                          setState(() {
                            iddok = x.id; ctrNmDok.text = x.nm;
                            iddok=='' ? showToast('pilihdokter'.tr()) :
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
          // actions: <Widget> [
          //   TextButton(
          //     child: Text("Batal"),
          //     onPressed: (){
          //       Navigator.of(context).pop();
          //     },
          //   ),
          //   TextButton(
          //     child: Text("Ok"),
          //     onPressed: (){
          //       iddok=='' ? showToast('Silahkan pilih dokter') :
          //       Navigator.pop(context);
          //     },
          //   )
          // ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: Text('pasReg').tr(),
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
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: ctrNoReg,
                            decoration: InputDecoration(
                              labelText: "noreg".tr(),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple.shade900)),
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
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: ctrTgl,
                            decoration: InputDecoration(
                              labelText: "tgl".tr(),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              labelStyle: TextStyle(color: Colors.purple, fontSize: 18),
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

                  // Container(
                  //   padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                  //   height: 80,
                  //   width: MediaQuery.of(context).size.width,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  //         child: TextFormField(
                  //           controller: ctrNmPas,
                  //           decoration: InputDecoration(
                  //             labelText: "nmpas".tr(),
                  //             focusedBorder: UnderlineInputBorder(
                  //                 borderSide: BorderSide(color: Colors.purple)),
                  //             labelStyle: TextStyle(color: Colors.purple, fontSize: 18),
                  //             hintText: "",
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.rectangle,
                  //     borderRadius: BorderRadius.all(Radius.circular(10)),
                  //     color: Colors.white,
                  //   ),
                  // ),
                  // SizedBox(height: 10,),

                  // Container(
                  //   padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                  //   height: 70,
                  //   width: MediaQuery.of(context).size.width,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  //         child: TextFormField(
                  //           controller: ctrBy,
                  //           decoration: InputDecoration(
                  //             labelText: "biaya".tr(),
                  //             focusedBorder: UnderlineInputBorder(
                  //                 borderSide: BorderSide(color: Colors.purple)),
                  //             labelStyle: TextStyle(color: Colors.purple, fontSize: 18),
                  //             hintText: "",
                  //             enabled: false,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.rectangle,
                  //     borderRadius: BorderRadius.all(Radius.circular(10)),
                  //     color: Colors.white,
                  //   ),
                  // ),
                  // SizedBox(height: 10,),

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
                            controller: ctrNmDok,
                            decoration: InputDecoration(
                              labelText: "dokter".tr(),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              labelStyle: TextStyle(color: Colors.purple, fontSize: 18),
                              // hintText: "Belum dipilih",
                            ),
                            validator: (e){
                              if (e!.isEmpty || e=="pilih".tr()){
                                return "pilihdokter".tr();
                              }
                              return null;
                            },
                            onTap: (){
                              FocusScope.of(context).requestFocus(FocusNode());
                              dialogDokter(context);
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
                    height: 110,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: ctrKeluhan,
                            onSaved: (e) => keluhan = e!,
                            decoration: InputDecoration(
                              labelText: "keluhan".tr(),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              labelStyle: TextStyle(color: Colors.purple, fontSize: 18),
                              // hintText: "Keluhan",
                            ),
                            maxLines: 3,
                            validator: (e){
                              if (e!.isEmpty || e==' '){
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
                          Text('simpan', style: TextStyle(color: Colors.white)).tr(),
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
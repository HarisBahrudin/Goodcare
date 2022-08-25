import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/adm_kecamatan.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class AdmPasienEdit extends StatefulWidget {
  final VoidCallback xreload;
  final String xid, xnik, xnm, xjk, xalamat, xidkec, xkec, xtlp, xumur, xgd, xtkn, xby;
  const AdmPasienEdit({ Key? key, required this.xid, required this.xreload, required this.xtkn, required this.xnik, required this.xnm, required this.xjk, required this.xalamat, required this.xidkec, required this.xkec, required this.xtlp, required this.xumur,  required this.xgd, required this.xby}) : super(key: key);

  @override
  _AdmPasienEditState createState() => _AdmPasienEditState();
}

class _AdmPasienEditState extends State<AdmPasienEdit> {
  bool loading = false;
  List <ModelKec> list = [];
  
  final _key = new GlobalKey<FormState>();
  String by='', nik='', nm='', alamat='', tlp='', umur='', gd='', jk='L';
  TextEditingController ctrBy = TextEditingController();
  TextEditingController ctrNik = TextEditingController();
  TextEditingController ctrNm = TextEditingController();
  TextEditingController ctrAlamat = TextEditingController();
  TextEditingController ctrKec = TextEditingController();
  TextEditingController ctrTlp = TextEditingController();
  TextEditingController ctrUmur = TextEditingController();
  TextEditingController ctrGD = TextEditingController();
  String xidkec="";

  @override
  void initState() {
    super.initState();
    ctrNik.text = widget.xnik;
    ctrNm.text = widget.xnm;
    ctrAlamat.text = widget.xalamat;
    xidkec = widget.xidkec;
    ctrKec.text = widget.xkec;
    ctrTlp.text = widget.xtlp;
    ctrUmur.text = widget.xumur;
    ctrGD.text = widget.xgd;
    ctrBy.text = widget.xby == "Umum" ? "umum".tr() : widget.xby;
    jk = widget.xjk;
    getKec();
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
    by == "General" ? by="Umum" : by=by;
    try {
      final respon = await http.post(Uri.parse(MyApi.apiPasienUpp), body: {'id':widget.xid, 'by':by, 'nik':nik, 'nm':nm, 'jk':jk, 'alamat':alamat, 'kec':xidkec, 'tlp':tlp, 'umur':umur, 'gd':gd}, headers: {'Authorization':widget.xtkn});
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
  
  void dialogBy(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("biaya").tr(),
          content: Container(
            width: double.maxFinite,
            height: 120,
            child: Column(
              children: [
                ListTile(
                  title: Text('umum').tr(),
                  onTap: (){
                    ctrBy.text = 'Umum';
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('PBJS'),
                  onTap: (){
                    ctrBy.text = 'BPJS';
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ),
        );
      }
    );
  }

  void dialogHapus(BuildContext context, String id) async {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('andayakin?'.tr()),
          actions: <Widget> [
            TextButton(
              child: Text("tidak".tr()),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("hapus".tr()),
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
      final respon = await http.get(Uri.parse(MyApi.apiPasienDel+id), headers: {'Authorization':widget.xtkn});
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

  void getKec() async {
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiKecList), headers: {'Authorization':widget.xtkn});
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

  void dialogKec(BuildContext context) async {
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
                            xidkec = x.id;
                            ctrKec.text = x.kec;
                            ctrKec.text=='' ? showToast('pilihkecamatan'.tr()) :
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
        title: Text('datapasEdit').tr(),
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
                            controller: ctrBy,
                            onSaved: (e) => by = e!,
                            decoration: InputDecoration(
                              labelText: "biaya".tr(),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple.shade900),),
                              labelStyle: TextStyle(color: Colors.purple.shade900, fontSize: 18),
                              hintText: "",
                            ),
                            onTap: (){
                              FocusScope.of(context).requestFocus(FocusNode());
                              dialogBy(context);
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
                            controller: ctrNik,
                            onSaved: (e) => nik = e!,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "nik".tr(),
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
                            controller: ctrNm,
                            onSaved: (e) => nm = e!,
                            decoration: InputDecoration(
                              labelText: "nm".tr(),
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
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('jk'.tr(), style: TextStyle(color: Colors.purple.shade900, fontSize: 18)),
                            ],
                          ),
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
                                Text('lk'.tr(), style: TextStyle(color: Colors.purple.shade900, fontSize: 18)),
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
                                Text('pr'.tr(), style: TextStyle(color: Colors.purple.shade900, fontSize: 18)),
                              ],
                            ),
                            
                          ],
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
                            controller: ctrAlamat,
                            onSaved: (e) => alamat = e!,
                            decoration: InputDecoration(
                              labelText: "alamat".tr(),
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
                            controller: ctrKec,
                            decoration: InputDecoration(
                              labelText: "kecamatan".tr(),
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
                              dialogKec(context);
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
                            controller: ctrTlp,
                            onSaved: (e) => tlp = e!,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "tlp".tr(),
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
                            controller: ctrUmur,
                            onSaved: (e) => umur = e!,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "umur".tr(),
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
                            controller: ctrGD,
                            onSaved: (e) => gd = e!,
                            decoration: InputDecoration(
                              labelText: "golDr".tr(),
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
                          height: 40,
                          // width: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width - 140,
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
                          height: 40,
                          // width: MediaQuery.of(context).size.width,
                          width: 100,
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
                           dialogHapus(context, widget.xid);
                        },
                      ),

                      // Container(
                      //   height: 40,
                      //   width: (MediaQuery.of(context).size.width / 2) - 20,
                      //   child: ElevatedButton(
                      //     style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red.shade900)),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Icon(Icons.delete, color: Colors.white),
                      //         SizedBox(width: 10.0),
                      //         Text('Hapus', style: TextStyle(fontSize: 18.0, color: Colors.white)),
                      //       ],
                      //     ),
                      //     onPressed: (){
                      //       dialogHapus(context, widget.xid);
                      //     }
                      //   ),
                      // ),

                    ],
                  ),

                ],
              ),
            ),

          )
          // Form(
          //   key: _key,
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: ListView(
          //       children: [
          //         TextFormField(
          //           controller: ctrBy,
          //           onSaved: (e) => by = e!,
          //           decoration: InputDecoration(
          //             labelText: "Pembiayaan",
          //             focusedBorder: UnderlineInputBorder(
          //                 borderSide: BorderSide(color: Colors.blue)),
          //             labelStyle: TextStyle(color: Colors.blue, fontSize: 18),
          //             hintText: "",
          //           ),
          //           onTap: (){
          //             FocusScope.of(context).requestFocus(FocusNode());
          //             dialogBy(context);
          //           },
          //         ),
          //         TextFormField(
          //           controller: ctrNik,
          //           onSaved: (e) => nik = e!,
          //           keyboardType: TextInputType.number,
          //           decoration: InputDecoration(
          //             labelText: "NIK",
          //             focusedBorder: UnderlineInputBorder(
          //                 borderSide: BorderSide(color: Colors.blue)),
          //             labelStyle: TextStyle(color: Colors.blue, fontSize: 18),
          //             hintText: "",
          //           ),
          //           validator: (e){
          //             if (e!.isEmpty){
          //               return "required".tr();
          //             }
          //           },
          //         ),
          //         TextFormField(
          //           controller: ctrNm,
          //           onSaved: (e) => nm = e!,
          //           decoration: InputDecoration(
          //             labelText: "Nama",
          //             focusedBorder: UnderlineInputBorder(
          //                 borderSide: BorderSide(color: Colors.blue)),
          //             labelStyle: TextStyle(color: Colors.blue, fontSize: 18),
          //             hintText: "",
          //           ),
          //           validator: (e){
          //             if (e!.isEmpty){
          //               return "required".tr();
          //             }
          //           },
          //         ),
          //         SizedBox(height: 10,),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             Text('Jenis Kelamin', style: TextStyle(color: Colors.blue)),
          //           ],
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceAround,
          //           children: [
          //             Row(
          //               children: [
          //                 Radio(value: 'L', groupValue: jk, onChanged: (value){
          //                   setState(() {
          //                     jk = value.toString();
          //                   });
          //                 }),
          //                 Text('Laki-Laki'),
          //               ],
          //             ),
                      
          //             // SizedBox(width: 20,),
          //             Row(
          //               children: [
          //                 Radio(value: 'P', groupValue: jk, onChanged: (value){
          //                   setState(() {
          //                     jk = value.toString();
          //                   });
          //                 }),
          //                 Text('Perempuan'),
          //               ],
          //             ),
                      
          //           ],
          //         ),
          //         TextFormField(
          //           controller: ctrAlamat,
          //           onSaved: (e) => alamat = e!,
          //           decoration: InputDecoration(
          //             labelText: "Alamat",
          //             focusedBorder: UnderlineInputBorder(
          //                 borderSide: BorderSide(color: Colors.blue)),
          //             labelStyle: TextStyle(color: Colors.blue, fontSize: 18),
          //             hintText: "",
          //           ),
          //           validator: (e){
          //             if (e!.isEmpty){
          //               return "required".tr();
          //             }
          //           },
          //         ),
          //         TextFormField(
          //           controller: ctrTlp,
          //           onSaved: (e) => tlp = e!,
          //           keyboardType: TextInputType.number,
          //           decoration: InputDecoration(
          //             labelText: "Tlp",
          //             focusedBorder: UnderlineInputBorder(
          //                 borderSide: BorderSide(color: Colors.blue)),
          //             labelStyle: TextStyle(color: Colors.blue, fontSize: 18),
          //             hintText: "",
          //           ),
          //           validator: (e){
          //             if (e!.isEmpty){
          //               return "required".tr();
          //             }
          //           },
          //         ),
          //         TextFormField(
          //           controller: ctrUmur,
          //           onSaved: (e) => umur = e!,
          //           keyboardType: TextInputType.number,
          //           decoration: InputDecoration(
          //             labelText: "Umur",
          //             focusedBorder: UnderlineInputBorder(
          //                 borderSide: BorderSide(color: Colors.blue)),
          //             labelStyle: TextStyle(color: Colors.blue, fontSize: 18),
          //             hintText: "",
          //           ),
          //           validator: (e){
          //             if (e!.isEmpty){
          //               return "required".tr();
          //             }
          //           },
          //         ),
          //         TextFormField(
          //           controller: ctrGD,
          //           onSaved: (e) => gd = e!,
          //           decoration: InputDecoration(
          //             labelText: "Golongan Darah",
          //             focusedBorder: UnderlineInputBorder(
          //                 borderSide: BorderSide(color: Colors.blue)),
          //             labelStyle: TextStyle(color: Colors.blue, fontSize: 18),
          //             hintText: "",
          //           ),
          //           validator: (e){
          //             if (e!.isEmpty){
          //               return "required".tr();
          //             }
          //           },
          //         ),

          //         SizedBox(height:10),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Container(
          //               height: 40,
          //               width: MediaQuery.of(context).size.width-160,
          //               child: ElevatedButton(
          //                 style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue.shade800)),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     Icon(Icons.save, color: Colors.white),
          //                     SizedBox(width: 10.0),
          //                     Text('Simpan', style: TextStyle(fontSize: 18.0, color: Colors.white)),
          //                   ],
          //                 ),
          //                 onPressed: (){
          //                   cekForm();
          //                 }
          //               ),
          //             ),
          //             Container(
          //               height: 40,
          //               width: 120,
          //               child: ElevatedButton(
          //                 style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red.shade800)),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     Icon(Icons.delete, color: Colors.white),
          //                     SizedBox(width: 10.0),
          //                     Text('Hapus', style: TextStyle(fontSize: 18.0, color: Colors.white)),
          //                   ],
          //                 ),
          //                 onPressed: (){
          //                   dialogHapus(context, widget.xid);
          //                 }
          //               ),
          //             ),
          //           ],
          //         ),

          //       ],
          //     ),
          //   ),

          // )
        ],
      ),
    );
  }

}
import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:goodcare/ksr_resep_list.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class KsrTransAdd extends StatefulWidget {
  final VoidCallback xreload;
  final String xtkn, xidrm, xnoreg, xnorm, xtgl, xnmpas, xkeluhan, xdiag, xtindakan;
  const KsrTransAdd({ Key? key, required this.xreload, required this.xtkn, required this.xidrm, required this.xnoreg, required this.xnorm, required this.xtgl, required this.xnmpas, required this.xkeluhan, required this.xdiag, required this.xtindakan }) : super(key: key);

  @override
  _KsrTransAddState createState() => _KsrTransAddState();
}

class ModelResep{
  final String idresep, nmobat, dosis, cttn, cek, hrg, hrgRp;
  ModelResep(this.idresep, this.nmobat, this.dosis, this.cttn, this.cek, this.hrg, this.hrgRp);
}

class _KsrTransAddState extends State<KsrTransAdd> {
  bool loading = false;
  List <ModelResep> list = [];
  int ttlby=0; 

  String cttn='';
  TextEditingController ctrCttn = TextEditingController();
  final _key = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getResepList();
  }

  void getResepList() async {
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiResepListKsr+widget.xidrm), headers: {'Authorization': widget.xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data['obat'].forEach((a) {
            final mp = ModelResep(a['idresep'], a['nmobat'], a['dosis'], a['cttn'], a['cek'], a['hrg'], a['hrgRp']);
            list.add(mp);
          });
          setState(() {
            // ttlby = data['total'] + int.parse(widget.xbytdkn);
          });
          // print('total 1 ----------'+ttlby.toString());
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

  void dialogEnd(BuildContext context) async {
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
                upRMxEnd();
              },
            )
          ],
        );
      }
    );
  }

  void upRMxEnd() async {
    print('Get List Res ------------');
    setState(() {
      loading = true;
    });
    try {
      final respon = await http.get(Uri.parse(MyApi.apiRMEnd+widget.xidrm), headers: {'Authorization':widget.xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          if (data['code']=='200'){
            showToast(data['pesan']);
            Navigator.pop(context);
            widget.xreload();
          } else {
            showToast(data['pesan']);
          }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: Text('transaksi').tr(),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('noreg'.tr(), style: TextStyle(fontSize: 18.0)),
                        Text(widget.xnoreg, style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('norm'.tr(), style: TextStyle(fontSize: 18.0)),
                        Text(widget.xnorm, style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('nmpas'.tr(), style: TextStyle(fontSize: 18.0)),
                        Text(widget.xnmpas, style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('keluhan'.tr(), style: TextStyle(fontSize: 18.0)),
                        Text(widget.xkeluhan, style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('hasildiagnosa'.tr(), style: TextStyle(fontSize: 18.0)),
                        Text(widget.xdiag, style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('tindakan'.tr(), style: TextStyle(fontSize: 18.0)),
                        Text(widget.xtindakan, style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                  
                ],
              ),
            ),
          ),

          
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                    child: Text('resep'.tr(), style: TextStyle(fontSize: 18.0)),
                  ),
                  Divider(),
                  loading==true ?
                  Center(child: LinearProgressIndicator()) :
                  list.length == 0 ?
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('nodata').tr()),
                  ) :
                  Column(
                    children: [
                      for (var x in list)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(Icons.medication_outlined, color: Colors.purple.shade900, size: 50,),
                          title: Text(x.nmobat, style: TextStyle(fontSize: 18.0)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(),
                              Text('dosis'.tr()+': '+x.dosis, style: TextStyle(fontSize: 18.0)),
                              Text('catatan'.tr()+': '+x.cttn, style: TextStyle(fontSize: 18.0)),
                            ],
                          ),
                          trailing: IconButton(
                            icon: x.cek=='N' ? Icon(Icons.minimize, color: Colors.grey): Icon(Icons.check, color: Colors.purple.shade900, size: 30,),
                            onPressed: (){
                              dialogCatatan(context, x.idresep);
                            }, 
                          ),
                          onTap: (){
                            // Navigator.of(context).push(MaterialPageRoute(
                            //   builder: (context) => AdmUserEdit(xid: x.id, xreload: getUser, xtkn: widget.xtkn, xnm: x.nm, xjk: x.jk, xalamat: x.alamat, xtlp: x.tlp, xemail: x.email, xrole: x.role,)
                            // ));
                          },
                        ),
                      ),
                      // decoration: BoxDecoration(
                      //   color: Colors.white,
                      //   border: Border(bottom: BorderSide(width: .5, color: Colors.black38)
                      // )
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      //   child: Container(
                      //     child: ListTile(
                      //       title: Text(i.nmobat+' ('+i.dosis+')', style: TextStyle(fontSize: 18.0)),
                      //       subtitle: Text('Catatan: '+i.cttn, style: TextStyle(fontSize: 16.0)),
                      //       trailing: Text(i.hrgRp, style: TextStyle(fontSize: 16.0, color: Colors.purple.shade900)),
                      //     ),
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.rectangle,
                      //       // border: Border(bottom: BorderSide(color: Colors.grey))
                      //     ),
                      //   )
                      // )
                    ]
                  )
                ],
              ),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: InkWell(
          //     child: Container(
          //       height: 50,
          //       width: MediaQuery.of(context).size.width,
          //       padding: const EdgeInsets.all(8.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           // Icon(Icons.save, color: Colors.white),
          //           // SizedBox(width: 10.0),
          //           Padding(
          //             padding: const EdgeInsets.only(left: 20.0),
          //             child: Text('Resep Obat', style: TextStyle(color: Colors.purple.shade900)),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.only(right: 20.0),
          //             child: Text('Lihat Resep', style: TextStyle(color: Colors.purple.shade900)),
          //           ),
          //         ],
          //       ),
          //       decoration: BoxDecoration(
          //         shape: BoxShape.rectangle,
          //         borderRadius: BorderRadius.all(Radius.circular(20)),
          //         color: Colors.white,
          //         border: Border.all(color: Colors.purple),
          //       ),
          //     ),
          //     onTap: (){
          //       Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => KsrResepList(xtkn: widget.xtkn, xidrm: widget.xidrm)
          //       ));
          //     },
          //   ),
          // ),

          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save, color: Colors.white),
                    SizedBox(width: 10.0),
                    Text('selesai'.tr(), style: TextStyle(color: Colors.white)),
                  ],
                )),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.purple.shade900,
                ),
              ),
              onTap: (){
                dialogEnd(context);
              },
            ),
          ),

        ],
      ),
    );
  }

  void dialogCatatan(BuildContext context, String id) async {
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('catatan').tr(),
          content: Container(
            height: 80,
            child: Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (e) => cttn = e!,
                    controller: ctrCttn,
                    decoration: InputDecoration(
                      hintText: ""
                    ),
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
                Navigator.pop(context);
                goCheck(id);
              },
            )
          ],
        );
      }
    );
  }

  void goCheck(id) async {
    dialogLoading(context);
    try {
      final respon = await http.post(Uri.parse(MyApi.apiResepCheck), body: {'idres':id, 'cttn': ctrCttn.text}, headers: {'Authorization':widget.xtkn});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          showToast(data['pesan']);
          print(data['pesan']);
          getResepList();
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

}
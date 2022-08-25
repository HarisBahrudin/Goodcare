
import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class AdmRekapWilayah extends StatefulWidget {
  final String xtkn;
  const AdmRekapWilayah({ Key? key, required this.xtkn }) : super(key: key);

  @override
  _AdmRekapWilayahState createState() => _AdmRekapWilayahState();
}

class ModelRekap{
  final String kec, jml;
  ModelRekap(this.kec, this.jml);
}

class _AdmRekapWilayahState extends State<AdmRekapWilayah> {
  bool loading = false;
  List <ModelRekap> list = [];

  @override
  void initState() {
    super.initState();
    getRekap();
  }

  void getRekap() async {
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiRMRekap1), headers: {'Authorization':widget.xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data.forEach((a) {
            final mp = ModelRekap(a['kec'], a['jml']);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: Text('perkecamatan').tr(),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: loading ?
        Center(child: CircularProgressIndicator()) :
        list.length == 0 ? 
        Center(child: Text('-nodata-')) :
        ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final x = list[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.map, color: Colors.purple.shade900, size: 30,),
                  title: Text(x.kec, style: TextStyle(fontSize: 18.0)),
                  trailing: Text(x.jml, style: TextStyle(fontSize: 18.0)),
                ),
              ),
            );
          },
        ),
      ),
      
    );
  }
}
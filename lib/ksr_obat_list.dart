
import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/ksr_obat_add.dart';
import 'package:goodcare/ksr_obat_edit.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:http/http.dart' as http;

class KsrObatList extends StatefulWidget {
  final String xtkn;
  const KsrObatList({ Key? key, required this.xtkn }) : super(key: key);

  @override
  _KsrObatListState createState() => _KsrObatListState();
}

class ModelObat{
  final String idobat, nm, hrg, hrgRp;
  ModelObat(this.idobat, this.nm, this.hrg, this.hrgRp);
}

class _KsrObatListState extends State<KsrObatList> {
  bool loading = false;
  List <ModelObat> list = [];

  @override
  void initState() {
    super.initState();
    getObat();
  }

  Future<void> getObat() async {
    setState(() {
      loading = true;
    });
    list.clear();
    try {
      final respon = await http.get(Uri.parse(MyApi.apiObatList), headers: {'Authorization':widget.xtkn});
      if (respon.statusCode==200){
          final data = jsonDecode(respon.body);
          data.forEach((a) {
            // final mp = ModelObat(a['idobat'], a['nm'], a['sat'], a['hrg'], a['hrgRp'], a['idkat'], a['kat']);
            final mp = ModelObat(a['idobat'], a['nm'], a['hrg'], a['hrgRp']);
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
        title: Text('kelolaobat').tr(),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: loading ?
        Center(child: CircularProgressIndicator()) :
        list.length == 0 ? 
        Center(child: Text('nodata').tr()) :
        ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final x = list[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              // child: 
              // Container(
                child: loading ?
                Center(child: CircularProgressIndicator()) :
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.medication_outlined, color: Colors.purple.shade900, size: 30,),
                      title: Text(x.nm, style: TextStyle(fontSize: 18.0)),
                      subtitle: Text('harga'.tr()+': '+x.hrgRp, style: TextStyle(fontSize: 18.0)),
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => KsrObatEdit(xreload: getObat, xtkn: widget.xtkn, xidobt: x.idobat, xnm: x.nm, xhrg: x.hrg,)
                        ));
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => KsrObatEdit(xreload: getObat, xtkn: widget.xtkn, xidobt: x.idobat, xnm: x.nm, xhrg: x.hrg, xsat: x.sat, xidkat: x.idkat, xnmkat: x.nmkat)
                        // ));
                      },
                    ),
                  ),
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   border: Border(bottom: BorderSide(width: .5, color: Colors.black38)
                  // )
                // ),
              // ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom:30.0),
        child: FloatingActionButton(
          child: Icon(Icons.add, size: 30.0),
          backgroundColor: Colors.purple.shade900,
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => KsrObatAdd(xreload: getObat, xtkn: widget.xtkn)
            ));
          }
        ),
      ),
    );
  }
}
import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goodcare/home_admin.dart';
import 'package:goodcare/home_dokter.dart';
import 'package:goodcare/home_kasir.dart';
import 'package:goodcare/home_pasien.dart';
import 'package:goodcare/my_api.dart';
import 'package:goodcare/my_class.dart';
import 'package:goodcare/pasien_reg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({ Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus {
  signInAdmin,
  signInDokter,
  signInKasir,
  signInPasien,
  notSignIn
}

class _LoginState extends State<Login> {
  final _key = new GlobalKey<FormState>();
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String username='', password='';
  int listenfcm=0;
  bool _secureText = true;

  @override
  void initState() {
    super.initState();
    getPref();
  }

  Future <void> getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var role = pref.getString("xrole");
    setState(() {
      _loginStatus = role == 'Admin' ? LoginStatus.signInAdmin : 
          role == 'Dokter' ? LoginStatus.signInDokter :  
          role == 'Kasir' ? LoginStatus.signInKasir :  
          role == 'Pasien' ? LoginStatus.signInPasien :  LoginStatus.notSignIn;
    });
  }

  signOut() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences pref = await _prefs;
    setState(() {
      pref.setString("xidus", '');
      pref.setString("xrole", '');
      pref.setString("xtkn", '');
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  showHide(){
    setState(() {
      _secureText = !_secureText;
    });
  }

  _cekForm(){
    final form = _key.currentState;
    if (form!.validate()){
      form.save();
      login();
    }
  }

  void login() async {
    dialogLoading(context);
    try {
      final respon = await http.post(Uri.parse(MyApi.apiLogin), body: {"email": username, "pwd": password});
      final data = jsonDecode(respon.body);
      if (respon.statusCode==200){
        if (data['code']=='200'){
          saveToPref('xidus', data['idus']); //id
          saveToPref('xemail', data['email']); //email
          saveToPref('xnmus', data['nmus']); //nm user
          saveToPref('xalamat', data['alamat']);
          saveToPref('xtlp', data['tlp']);
          saveToPref('xtkn', data['tkn']);
          // saveToPref('xfoto', data['foto']);
          saveToPref('xrole', data['role']);
          
          showToast(data['pesan']);
          print(data);
          print('Token baru -------------------> '+data['tkn']);
          
          setState(() {
            _loginStatus = data['role'] == 'Admin' ? LoginStatus.signInAdmin : 
              data['role'] == 'Dokter' ? LoginStatus.signInDokter :  
              data['role'] == 'Kasir' ? LoginStatus.signInKasir : 
              data['role'] == 'Pasien' ? LoginStatus.signInPasien :  LoginStatus.notSignIn;
          });
        } else {
          showToast(data['pesan']);
        }
      } else {
        showToast('Error. (code: '+respon.statusCode.toString()+')');
      }
    } on TimeoutException catch (_){
        showToast('Error. (connection timeout)');
    } on Error catch (e){
        showToast('Error. ($e)');
        print(e);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    switch (_loginStatus){
      case LoginStatus.notSignIn:
        return Scaffold(
          backgroundColor: Color(0xFFEEEEEE),
          body: Stack(
            children: <Widget>[
              _widgetLogo(mediaQuery),
              _widgetLogin()
            ],
          )
        );
      case LoginStatus.signInAdmin:
        return Admins(xlogOut: signOut);
      case LoginStatus.signInDokter:
        return Dokters(xlogOut: signOut);
      case LoginStatus.signInKasir:
        return Kasirs(xlogOut: signOut);
      case LoginStatus.signInPasien:
        return Pasiens(xlogOut: signOut);
        // return HomeKasir(xlogOut: signOut,);
    }
  }

  Widget _widgetLogo(MediaQueryData mediaQuery) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: Container(
        width: mediaQuery.size.width,
        height: 100.0,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/logo2.png'), width: 240, height: 120,)
            ],
          )
        ),
      ),
    );
  }

  Widget _widgetLogin(){
    return  Align(
      alignment: Alignment.bottomCenter,
      child: Form(
        key: _key,
        child: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(color: Colors.purple),
                  borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.fromLTRB(20, 180, 20, 10),
              padding: EdgeInsets.fromLTRB(20, 40, 20, 30),
              child: Column(
                children: [
                  Text('signin'.tr(), style: TextStyle(fontSize: 22.0, color: Colors.purple.shade900, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Username', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900)),
                      SizedBox(height: 4,),
                      TextFormField(
                        validator: (e){
                          if (e!.isEmpty){
                            return "required".tr();
                          }
                          return null;
                        },
                        onSaved: (e) => username = e!,
                        decoration: InputDecoration(
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: Icon(Icons.account_circle_rounded, color: Colors.grey.shade600,),
                        ),
                      ),

                      SizedBox(height: 10,),
                      Text('Password', style: TextStyle(fontSize: 18.0, color: Colors.purple.shade900)),
                      TextFormField(
                        obscureText: _secureText,
                        validator: (e){
                          if (e!.isEmpty){
                            return "required".tr();
                          }
                          return null;
                        },
                        onSaved: (e) => password = e!,
                        decoration: InputDecoration(
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            onPressed: showHide,
                            icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade600,),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),

                      InkWell(
                        child: RaisedGradientButton(
                          child: Text('signin', style: TextStyle(color: Colors.white)).tr(),
                          gradient: LinearGradient(
                            colors: <Color>[Colors.purple.shade900, Colors.purple.shade600],
                          ),
                        ),
                        onTap: (){
                          _cekForm();
                        },
                      ),
                      SizedBox(height: 30,),
                      InkWell(
                        // child: ElevatedButton(
                          child: Center(child: Text('regpas', style: TextStyle(color: Colors.purple.shade900)).tr()),
                          // gradient: LinearGradient(
                          //   colors: <Color>[Colors.purple.shade900, Colors.purple.shade600],
                          // ),
                        // ),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegPas()
                          ));
                        },
                      ),
                      SizedBox(height: 20,),

                    ],
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }


}
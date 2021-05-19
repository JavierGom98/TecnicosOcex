import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tecnicos_cm/cusicon_icons.dart';
import 'package:tecnicos_cm/main.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({this.codigoTecnico, this.nombreTecnico, this.cargoTecnico});
  final int codigoTecnico;
  final String nombreTecnico;
  final String cargoTecnico;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String nombre = '';
  String id_empleado = '';
  String cargo = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      id_empleado = codigoTecnico.toString();
      nombre = nombreTecnico;
      cargo = cargoTecnico;
    });
  }

  Future<bool> _onBackPressed() {
    Navigator.pushReplacementNamed(context, '/tab_page');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: new AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/tab_page');
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: AutoSizeText("Perfil"),
          backgroundColor: Color(0xFF0277bc),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.white],
              )
          ),
          child: Container(
            margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 40),
                  margin: EdgeInsets.only(bottom: 20),
                  child: ClipOval(
                      child: Image.asset(
                        'assets/images/img.jpg',
                        width: 135,
                        //height: 135,
                        fit: BoxFit.fill,
                      )
                  ),
                  width: 135.0,
                  //height: 170.0,
                ),


                ListTile(
                  leading: Container(
                    width: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[ Icon(Icons.account_circle /* perm_identity */, color: Color(0xFF0277bc)), ],
                    ),
                  ),
                  title: AutoSizeText(
                    "Nombre",
                    style: TextStyle( color: Color(0xFF606060), fontSize: 13 ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText(
                    nombre,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: (){ },
                ),
                Container(
                  padding: EdgeInsets.only(top: 0),
                  margin: EdgeInsets.only(left: 70, top: 0),
                  width: MediaQuery.of(context).size.width,
                  child: Divider( height: 0.5, color: Colors.black, ),
                ),

                ListTile(
                  leading: Container(
                    width: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[ Icon(Cusicon.id_card_solid, color: Color(0xFF0277bc)), ],
                    ),
                  ),
                  title: AutoSizeText(
                    "Identificación",
                    style: TextStyle( color: Color(0xFF606060), fontSize: 13 ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText(
                    id_empleado,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: (){ },
                ),
                Container(
                  padding: EdgeInsets.only(top: 0),
                  margin: EdgeInsets.only(left: 70, top: 0),
                  width: MediaQuery.of(context).size.width,
                  child: Divider( height: 0.5, color: Colors.black, ),
                ),

                ListTile(
                  leading: Container(
                    width: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[ Icon(Cusicon.briefcase_solid, color: Color(0xFF0277bc)), ],
                    ),
                  ),
                  title: AutoSizeText(
                    "Cargo",
                    style: TextStyle( color: Color(0xFF606060), fontSize: 13 ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText(
                    cargo,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: (){ },
                ),
                Container(
                  padding: EdgeInsets.only(top: 0),
                  margin: EdgeInsets.only(left: 70, top: 0),
                  width: MediaQuery.of(context).size.width,
                  child: Divider( height: 0.5, color: Colors.black, ),
                ),

                ListTile(
                  leading: Container(
                    width: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[ Icon(Cusicon.compass_solid, color: Color(0xFF0277bc)), ],
                    ),
                  ),
                  title: AutoSizeText(
                    "Zona",
                    style: TextStyle( color: Color(0xFF606060), fontSize: 13 ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText(
                    "Occidental",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: (){ },
                ),
                Container(
                  padding: EdgeInsets.only(top: 0),
                  margin: EdgeInsets.only(left: 70, top: 0),
                  width: MediaQuery.of(context).size.width,
                  child: Divider( height: 0.5, color: Colors.black, ),
                ),

                ListTile(
                  leading: Container(
                    width: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[ Icon(Cusicon.business_time_solid, color: Color(0xFF0277bc)), ],
                    ),
                  ),
                  title: AutoSizeText(
                    "Horas Laborales",
                    style: TextStyle( color: Color(0xFF606060), fontSize: 13 ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText(
                    "8 Horas",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: (){ },
                ),



                /*Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: new RaisedButton(
                    child: new Text(
                      'Cerrar Sesion',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    color: Colors.blue,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    onPressed: () {
                      cerrarSesion();
                    },
                  ),
                ),*/

              ],
            ),
          ),
        ),
      ),
    );
  }
}

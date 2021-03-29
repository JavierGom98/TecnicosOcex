import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
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
      id_empleado = "Identificacion: "+codigoTecnico.toString();
      nombre = nombreTecnico;
      cargo = "Cargo: "+cargoTecnico;
    });
  }

  void cerrarSesion(){
    FlutterSession().set('token', '');
    Navigator.pushReplacementNamed(context, '/login_page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height/1.3,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black26, Colors.white60],
              )
          ),
          child:

            Container(
                height: MediaQuery.of(context).size.height / 1.5,
               // width: MediaQuery.of(context).size.width /1.1,
                margin: EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 40),
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
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 30
                        ),
                        child: Text(
                          nombre,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20
                      ),
                      child: Text(
                        id_empleado,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15
                      ),
                      child: Text(
                        cargo,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15
                      ),
                      child: Text(
                        'Zona: Occidental',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15
                      ),
                      child: Text(
                        'Horas Laborales: 8 Horas',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  Spacer(),
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
                  ),
                ],
              ),
              ),


        )

    );
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:tecnicos_cm/pages/orden_page.dart';
import 'package:tecnicos_cm/pages/ordenes_page.dart';
import 'package:tecnicos_cm/pages/tab_page.dart';
import 'package:flutter_session/flutter_session.dart';

//void main() => runApp(LoginApp());
dynamic token = FlutterSession().get('token');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //dynamic token = FlutterSession().get('token');
  runApp(LoginApp());
}



int codigoTecnico = 0;
String nombreTecnico = '';
String cargoTecnico = '';

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tecnicos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: LoginPage(),
      home: token == '' ? TabPage() : LoginPage(),
      routes: <String, WidgetBuilder>{
        '/login_page': (BuildContext context) => new LoginPage(),
        '/tab_page' : (BuildContext context) => new TabPage(codigoTecnico: codigoTecnico,nombreTecnico: nombreTecnico, cargoTecnico: cargoTecnico,),
        '/orden_page' : (BuildContext context) => new OrdenPage(idOrden: idOrden, direccionOrden: direccionOrden, nombresApellidos: nombresApellidos, identificacionAbon: identificacionAbon, actividadNombre: actividadNombre,)
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {

  TextEditingController controllerUser = new TextEditingController();
  TextEditingController controllerPass = new TextEditingController();

  String mensaje = '';

  Future login() async{
    http.Response response = await http.post("http://ns212.cablebox.co:5510/appmovil/iniciarsesion.php",
        body: {
          "username": controllerUser.text
        });

    var datauser = json.decode(response.body);

    if(datauser[0]['tecnico'] == 'No se encontro registros en BD'){
      setState(() {
        mensaje = "Usuario Incorrecto";
      });
    }else{
      if(datauser[0]['password'] == controllerPass.text){
        await FlutterSession().set('token', controllerUser.text);

        Navigator.pushReplacementNamed(context, '/tab_page');
      }else{
        setState(() {
          mensaje = "Contraseña Incorrecta";
        });
      }
      setState(() {
        codigoTecnico =  int.parse(datauser[0]['id_empleado']);
        nombreTecnico = datauser[0]['nombre'];
        cargoTecnico = datauser[0]['cargo'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/fondo.png'),
                fit: BoxFit.cover
            )
        ),
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              height: MediaQuery.of(context).size.height / 1.3,
              width: MediaQuery.of(context).size.width /1.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                      image: AssetImage('assets/images/fondo_blue.jpg'),
                      fit: BoxFit.cover
                  )
              ),
              child: Scaffold(
                resizeToAvoidBottomPadding: false,
                backgroundColor: Colors.transparent,
                body: Form(
                  child: Container(

                    child: Column(

                      children: <Widget>[
                        Flexible(
                          child: Container(
                            height: MediaQuery.of(context).size.height/3,
                            width: MediaQuery.of(context).size.width/1.6,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/logo_azul.png'),
                                    fit: BoxFit.contain
                                )
                            ),
                          ),

                        ),
                        Flexible(
                          child: Container(
                            height: MediaQuery.of(context).size.height/2,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: <Widget>[

                                Container(

                                    width: MediaQuery.of(context).size.width / 1.2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                      ),
                                      child: Text(
                                          'Usuario'
                                      ),
                                    )
                                ),

                                Container(
                                  height: 30,
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    controller: controllerUser,
                                  ),
                                ),

                                Container(
                                    width: MediaQuery.of(context).size.width / 1.2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 11
                                      ),
                                      child: Text(
                                          'Contraseña'
                                      ),
                                    )
                                ),

                                Container(
                                  height: 30,
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: TextFormField(
                                    controller: controllerPass,
                                    obscureText: true,
                                  ),
                                ),

                                Container(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30
                                    ),
                                    child: new RaisedButton(
                                      child: new Text(
                                        'Iniciar',
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                      ),
                                      color: Colors.lightBlue,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(10.0)),
                                      onPressed: () {
                                        login();
                                      },
                                    ),
                                  ),
                                ),

                                Container(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: Center(
                                    child: Text(
                                      mensaje,
                                      style: TextStyle(fontSize: 20, color: Colors.red),
                                    ),
                                  ),

                                )
                              ],
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              ),
            ),

          ),

        ),
      ),

    );
  }
}


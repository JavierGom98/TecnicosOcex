import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:tecnicos_cm/pages/ordenRealizada_page.dart';
import 'package:tecnicos_cm/pages/orden_page.dart';
import 'package:tecnicos_cm/pages/ordenesRealizadas_page.dart';
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
        '/orden_page' : (BuildContext context) => new OrdenPage(idOrden: idOrden, direccionOrden: direccionOrden, nombresApellidos: nombresApellidos, identificacionAbon: identificacionAbon, actividadNombre: actividadNombre,),
        '/ordenRealizada_page' : (BuildContext context) => new OrdenRealizadaPage(idOrden: idOrdenR, direccionOrden: direccionOrdenR, nombresApellidos: nombresApellidosR, identificacionAbon: identificacionAbonR, actividadNombre: actividadNombreR,)
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

  //String mensaje = '';

  String errorPass = null;
  String errorUser = null;
  Icon iconViewPass = new Icon(Icons.remove_red_eye);
  bool verContra = true;


  Future login() async{
    /*http.Response response = await http.post("http://ns212.cablebox.co:5510/appmovil/iniciarsesion.php",
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
    }*/
    errorPass = null;
    errorUser = null;
    if(controllerUser.text == '' || controllerPass.text == ''){
      if(controllerUser.text == ''){
        setState(() {
          errorUser = "Campo Vacio";
        });
      }
      if(controllerPass.text == ''){
        setState(() {
          errorPass = "Campo Vacio";
        });
      }
    }else{
      http.Response response = await http.post("http://ns212.cablebox.co:5510/appmovil/iniciarsesion.php",
          body: {
            "username": controllerUser.text
          });

      var datauser = json.decode(response.body);
      errorUser = null;
      if(datauser[0]['tecnico'] == 'No se encontro registros en BD'){
        setState(() {
          errorUser = "Usuario Incorrecto";
        });
      }else{
        if(datauser[0]['password'] == controllerPass.text){
          errorPass = null;
          await FlutterSession().set('token', controllerUser.text);
          Navigator.pushReplacementNamed(context, '/tab_page');
        }else{
          setState(() {
            errorPass = "Contraseña Incorrecta";
          });
        }
        setState(() {
          codigoTecnico =  int.parse(datauser[0]['id_empleado']);
          nombreTecnico = datauser[0]['nombre'];
          cargoTecnico = datauser[0]['cargo'];
        });
      }
    }
  }

  Future viewPass() async{
    Icon icon = new Icon(Icons.remove_red_eye);
    bool bolean = true;
    //debugPrint(iconViewPass.icon.toString());
    if(iconViewPass.icon.toString() == 'IconData(U+0E974)'){
      icon = new Icon(Icons.remove_red_eye_outlined);
      bolean = false;
    }
    setState(() {
      iconViewPass = icon;
      verContra = bolean;
    });
  }

  Future controlInputUser(text) async{
    setState(() {
      if(text == ''){
        errorUser = "Campo Vacio";
      }else{
        errorUser = null;
      }
    });
  }

  Future controlInputPass(text) async{
    setState(() {
      if(text == ''){
        errorPass = "Campo Vacio";
      }else{
        errorPass = null;
      }
    });
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
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 5), // changes position of shadow
                    ),
                  ],
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
                            height: MediaQuery.of(context).size.height/1,
                            width: MediaQuery.of(context).size.width/1.5,
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
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              children: <Widget>[
                                /*
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
                                  */
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: TextFormField(
                                    controller: controllerUser,
                                    cursorColor: Theme.of(context).cursorColor,
                                    decoration: InputDecoration(
                                      labelText: 'Usuario',
                                      errorText: errorUser,
                                      labelStyle: TextStyle(
                                        color: Color(0xFF4B4B4D),
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (text) {
                                      controlInputUser(text);
                                    },
                                  ),
                                ),

                                /*
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
                                */
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: TextFormField(
                                    controller: controllerPass,
                                    cursorColor: Theme.of(context).cursorColor,
                                    decoration: InputDecoration(
                                      labelText: 'Contraseña',
                                      errorText: errorPass,
                                      labelStyle: TextStyle(
                                        color: Color(0xFF4B4B4D),
                                      ),
                                      border: OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          viewPass();
                                        },
                                        icon: iconViewPass,
                                      ),
                                    ),
                                    obscureText: verContra,
                                    onChanged: (text) {
                                      controlInputPass(text);
                                    },
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20
                                    ),
                                    child: new ElevatedButton(
                                      child: new Text(
                                        'Iniciar',
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                        ),
                                      ),
                                      onPressed: () {
                                        login();
                                      },
                                    ),
                                  ),
                                ),
                                /*Container(
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
                                ),*/
                                /*
                                Container(
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  child: Center(
                                    child: Text(
                                      mensaje,
                                      style: TextStyle(fontSize: 20, color: Colors.red),
                                    ),
                                  ),

                                )*/
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


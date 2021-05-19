import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:tecnicos_cm/pages/firmar_orden_page.dart';
import 'package:tecnicos_cm/pages/material_page.dart';
import 'package:tecnicos_cm/pages/ordenRealizada_page.dart';
import 'package:tecnicos_cm/pages/orden_page.dart';
import 'package:tecnicos_cm/pages/profile_page.dart';
import 'package:tecnicos_cm/pages/ordenesRealizadas_page.dart';
import 'package:tecnicos_cm/pages/ordenes_page.dart';
import 'package:tecnicos_cm/pages/tab_page.dart';
import 'package:tecnicos_cm/pages/map_orden.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket;

String ip_base = '51.161.73.194';
String puerto_base = '5510';
//Socket
String hostName = '51.161.73.204';
String puertoServer = '4012';
final client = socket.io("http://"+hostName+":"+puertoServer, <String, dynamic>{ 'transports': ['websocket'], });
//void main() => runApp(LoginApp());
dynamic token = FlutterSession().get('token');

String userTecnico = '';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_){
    runApp(LoginApp());
  });
  //dynamic token = FlutterSession().get('token');
  //runApp(LoginApp());
}



int codigoTecnico = 0;
String nombreTecnico = '';
String cargoTecnico = '';
int numOrdenesInicial = 0;

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tecnicos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: token == '' ? TabPage() : LoginPage(),
      routes: <String, WidgetBuilder>{
        '/login_page': (BuildContext context) => new LoginPage(),
        '/tab_page' : (BuildContext context) => new TabPage(codigoTecnico: codigoTecnico,nombreTecnico: nombreTecnico, cargoTecnico: cargoTecnico, numOrdenes: numOrdenesInicial,),
        '/orden_page' : (BuildContext context) => new OrdenPage(idOrden: idOrden, direccionOrden: direccionOrden, nombresApellidos: nombresApellidos, identificacionAbon: identificacionAbon, actividadNombre: actividadNombre, telefono: telefono, duracionA: duracionActividad),
        '/firma_page' : (BuildContext context) => new FirmaPage(),
        '/map_orden' : (BuildContext context) => new MapScreen(),
        '/material_page' : (BuildContext context) => new MaterialesPage(),
        '/ordenRealizada_page' : (BuildContext context) => new OrdenRealizadaPage(idOrden: idOrdenR, direccionOrden: direccionOrdenR, nombresApellidos: nombresApellidosR, identificacionAbon: identificacionAbonR, actividadNombre: actividadNombreR,),
        '/profile_page' : (BuildContext context) => new ProfilePage(codigoTecnico: codigoTecnico, nombreTecnico: nombreTecnico, cargoTecnico: cargoTecnico),
      },
    );
  }
}

getCredenciales(user) async {
  return http.post(Uri.parse("http://"+ip_base+":"+puerto_base+"/appmovil/iniciarsesion.php"),
    body: {
      "username": user
    });
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController controllerUser = new TextEditingController();
  TextEditingController controllerPass = new TextEditingController();

  String errorPass = null;
  String errorUser = null;
  Icon iconViewPass = new Icon(Icons.remove_red_eye);
  bool verContra = true;


  Future login() async{
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
      http.Response response = await getCredenciales(controllerUser.text);
      var datauser = json.decode(response.body);

      errorUser = null;
      if(datauser['tecnico'][0] == 'No se encontro registros en BD'){
        setState(() {
          errorUser = "Usuario Incorrecto";
        });
      }else{
        if(datauser['tecnico'][0]['password'] == controllerPass.text){
          userTecnico = controllerUser.text;
          setState(() {
            codigoTecnico =  int.parse(datauser['tecnico'][0]['id_empleado']);
            nombreTecnico = datauser['tecnico'][0]['nombre'];
            cargoTecnico = datauser['tecnico'][0]['cargo'];
            numOrdenesInicial = datauser['numOrdenes'];
          });
          initConectSocket();
          errorPass = null;
          await FlutterSession().set('token', controllerUser.text);
          Navigator.pushReplacementNamed(context, '/tab_page');
        }else{
          setState(() {
            errorPass = "Contraseña Incorrecta";
          });
        }
      }
    }
  }

  Future viewPass() async{
    Icon icon = new Icon(Icons.remove_red_eye);
    bool bolean = true;
    if(verContra){
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

  void initConectSocket(){
    client.onConnect((_) {
      print('Connected!');
      client.emit('join', codigoTecnico);
    });

    client.on('if_conectado', (data) {
      print('Mensaje Masivo '+data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          resizeToAvoidBottomInset: false,
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
                resizeToAvoidBottomInset: false,
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


import 'dart:async';
import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:tecnicos_cm/pages/ordenes_page.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tecnicos_cm/main.dart';
import 'package:http/http.dart' as http;
import 'package:tecnicos_cm/pages/tab_page.dart';

import 'package:cool_alert/src/constants/images.dart';
import 'package:flare_flutter/flare_actor.dart';

import 'orden_page.dart';

String passTecnico = '';

class FirmaPage extends StatefulWidget {
  FirmaPage();
  @override
  _FirmaPageState createState() => _FirmaPageState();
}

class _FirmaPageState extends State<FirmaPage>{

  GlobalKey<SfSignaturePadState> _firmaPadKey = GlobalKey();
  bool firmado = false;

  LocalAuthentication _localAut;
  bool _isBiometricAvailable = false;

  TextEditingController controllerPass = new TextEditingController();
  
  String animEstado = AppAnim.loading;

  @override
  void initState() {
    super.initState();
    _localAut = LocalAuthentication();
    _localAut.canCheckBiometrics.then((value) {
      setState((){
        _isBiometricAvailable = value;
      });
    });
    getPass();
  }
  
  Future<bool> _onBackPressed() {
    Navigator.pushReplacementNamed(context, '/orden_page');
  }
  
  _onBackTabMenu() {
    tabNum = 1;
    Navigator.of(context).pushNamedAndRemoveUntil('/tab_page', (Route<dynamic> route) => false);
  }

  getPass() async {
    http.Response response = await getCredenciales(userTecnico);
    var datauser = json.decode(response.body);
    passTecnico = datauser['tecnico'][0]['password'];
  }
  
  showSuccess(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Container(
          height: 200,
          width: 200,
          child: FlareActor(
            animEstado,
            animation: "play",
          )
        ),
      )
    );
  }

  finalizarOrden() async {
    String enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/appMovilController.php?funcion=finalizarOrden&idOrden="+int.parse(idOrden).toString()+"&tipoOrden="+ordenFromBD+"&fueraTiempo="+fueraTiempo.toString()+"&fechaInicio="+fechaInicio.toString();
    http.Response response = await http.get(Uri.parse(enlace));

    enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/postOrden.php";
    response = await http.post(Uri.parse(enlace),
    body: {
      "materialesUsados":matarialesOrden,
      "cablemodemUsado": valorElegido.idCablemodem.toString(),
      "idOrdenAfiliacion" : idOrden
    });

    final firma = await _firmaPadKey.currentState.toImage(pixelRatio: 3.0);
    ByteData firmaBytes = await firma.toByteData(format: ui.ImageByteFormat.png);//ByteData
    
    /*
    final _picker = ImagePicker();
    final PickedFile  image = await _picker.getImage(firma.toByteData())
    final String path = await getApplicationDocumentsDirectory().path;
    final File newImage = await image.copy('$path/image1.png');

    print(lookupMimeType('assets/images/Ocex.png', headerBytes: [0xFF, 0xD8]));
    print(firmaBytes.buffer);
    print(firmaBytes);
    
    String enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/appMovilController.php?funcion=finalizarOrden&idOrden="+int.parse(idOrden).toString()+"&tipoOrden="+ordenFromBD+"&fueraTiempo="+fueraTiempo.toString()+"&firmaBytes="+firmaBytes.toString()+"&fechaInicio="+fechaInicio.toString();
    print(enlace);
    http.Response response = await http.get(Uri.parse(enlace));*/

    setState((){
      animEstado = AppAnim.success;
    });
    Timer(Duration(seconds: 2, milliseconds: 100), () {
      _onBackTabMenu();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: new AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/orden_page');
            },
            icon: Icon(Icons.close),
          ),
          centerTitle: true,
          title: Image.asset('assets/images/Ocex.png', width: 100, fit: BoxFit.fitWidth,),
          backgroundColor: Color(0xFF0277bc),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            /*mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,*/
            children: <Widget>[

              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 20, bottom: 15),
                padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: Center(
                  child: AutoSizeText(
                    "Confirmar!",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0277bc), fontFamily: 'ArialRounded',),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 0),
                padding: EdgeInsets.fromLTRB(4, 4, 4, 0),
                child: Center(
                  child: AutoSizeText(
                    "Firma para dar por terminada la Orden.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF636363), fontFamily: 'ArialRounded',),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 30,
                  height: 30,
                  margin: EdgeInsets.only(top: 0, right: 15),
                  child: Tooltip(
                    message: 'Limpiar',
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () { 
                          this.setState(() {
                            _firmaPadKey.currentState.clear();
                            firmado = false;
                          });
                        },
                        icon: Icon(FontAwesomeIcons.eraser, size: 15,),
                      ),
                    ),
                  ),
                
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width/ 1.1,
                margin: EdgeInsets.only(top: 0, bottom: 25),
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFdbdbdb), Color(0xFFdbdbdb)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 0,
                      blurRadius: 0,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: SfSignaturePad(
                  key:_firmaPadKey,
                  minimumStrokeWidth: 1,
                  maximumStrokeWidth: 3,
                  /*strokeColor: Colors.blue,
                  backgroundColor: Colors.grey,*/
                  onSignStart: (){
                    firmado = true;
                  },
                ),
              ),

              Flexible(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: 45,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 2
                    ),
                    child: new ElevatedButton(
                      child: new AutoSizeText(
                        'Identifícate',
                        style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        setState(() {
                          controllerPass.text = '';
                        });
                        if(firmado){
                          showDialog(
                            context: context,
                            builder: (context) {
                              String errorPassConfirmar = null;
                              String contentText = "Content of Dialog";
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    content: TextFormField(
                                      controller: controllerPass,
                                      //cursorColor: Theme.of(context).cursorColor,
                                      decoration: InputDecoration(
                                        labelText: 'Contraseña',
                                        errorText: errorPassConfirmar,
                                        labelStyle: TextStyle(
                                          color: Color(0xFF4B4B4D),
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                      obscureText: true,
                                      onChanged: (text) {
                                        if(text == passTecnico){
                                          setState(() {
                                            errorPassConfirmar = null;
                                          });
                                          Navigator.of(context).pop();
                                          showSuccess();
                                          finalizarOrden();
                                        }
                                      },
                                    ),
                                    actions: <Widget>[
                                      Container(
                                        width: MediaQuery.of(context).size.width / 1.3,
                                        margin: EdgeInsets.only(left: 20, right: 20),
                                        child: ElevatedButton(
                                          child: Text(
                                            'Confirmar',
                                            style: new TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                          onPressed: () {                     
                                            if(controllerPass.text != passTecnico){
                                              setState(() {
                                                errorPassConfirmar = "Contraseña Incorrecta";
                                              });
                                            }
                                          },
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(50.0),
                                              )
                                            )
                                          )
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        }else{
                          showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Text("Debes firmar."),
                                actions: <Widget>[
                                  FlatButton(
                                    textColor: Color(0xFF0277bc),
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                          ));
                        }

                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )
                        )
                      )
                    ),
                  ),
                ),
              ),

              if(_isBiometricAvailable)
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 25, bottom: 10),
                  padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                  child: Center(
                    child: Container(
                      height: 130,
                      width: 130,
                      child: ElevatedButton(
                        onPressed: () async {
                          if(firmado){
                            // ignore: deprecated_member_use
                            bool didAuthenticate = await _localAut.authenticateWithBiometrics(
                              localizedReason: "¡Identifíquese!",
                            );
                            if (didAuthenticate) { 
                              showSuccess();
                              finalizarOrden();
                            } else {
                              showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: Text("Necesitas identificarte."),
                                    actions: <Widget>[
                                      FlatButton(
                                        textColor: Color(0xFF0277bc),
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                              ));
                            }
                          }else{
                            showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Text("Debes firmar."),
                                  actions: <Widget>[
                                    FlatButton(
                                      textColor: Color(0xFF0277bc),
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                            ));
                          }
                            
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFcecece)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            )
                          )
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 20, bottom: 12.5),
                              child: Center(
                                child: Icon(FontAwesomeIcons.fingerprint, size: 40, color: Color(0xFF2b2b2b))
                              ),
                            ),
                            Center(
                              child: AutoSizeText(
                                "Identifícate con huella",
                                style: TextStyle(fontSize: 15,  fontWeight: FontWeight.normal, color: Color(0xFF2b2b2b), fontFamily: 'ArialRounded',),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ]
                        ),
                      ),
                    ),
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }
}
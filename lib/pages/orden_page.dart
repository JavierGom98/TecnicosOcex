import 'dart:math';
import 'dart:ui';
import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiver/async.dart';
import 'package:tecnicos_cm/cusicon_icons.dart';
import 'package:tecnicos_cm/main.dart';
import 'package:tecnicos_cm/pages/ordenes_page.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tecnicos_cm/pages/tab_page.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';

double sliderTimeValue = 0;
double duracionOrden = 0;
bool fueraTiempo = false;
String ordenFromBD = '';
String matarialesOrden = '';
Item valorElegido;
var fechaInicio;

class OrdenPage extends StatefulWidget {
  OrdenPage({this.idOrden, this.direccionOrden, this.nombresApellidos, this.identificacionAbon, this.actividadNombre, this.telefono, this.telefonoFijo, this.duracionA});
  final String idOrden;
  final String direccionOrden;
  final String nombresApellidos;
  final String identificacionAbon;
  final String actividadNombre;
  final String telefono;
  final String telefonoFijo;
  final double duracionA;
  @override
  _OrdenPageState createState() => _OrdenPageState();
}

class MaterialModel{
  int idMaterial;
  String nombre;
  int cantidadMinima;
  MaterialModel({this.idMaterial, this.nombre, this.cantidadMinima});
}

class ControlInventarioModel{
  int idMaterial;
  int cantControl;
  ControlInventarioModel(this.idMaterial, this.cantControl);

  Map toJson() => {
    'idMaterial' : idMaterial,
    'cantControl' : cantControl,
  };
}

class Item{
  int idCablemodem;
  String mac;
  Item({this.idCablemodem, this.mac});
}

class _OrdenPageState extends State<OrdenPage> with TickerProviderStateMixin{

  String nombresAbon = '';
  String identidadAbon = '';
  String actividadOrden = '';
  String telefonoUs = '';
  String fijoUs = '';
  int tamanioMateriales = 0;
  double duracionA = 0;

  bool timerIniciado = false;
  bool visibleButtonTimer = true;
  bool visibleBarTimer = false;
  String minutosRestantes = "00";
  String segundosRestantes = "00";
  Timer _timer;
  Color colorTimerBar = Colors.white;
  Color colorTimerNumberOn = Colors.white;
  Color colorTimerNumberOff = Color(0xFFed5565);

  bool nextPageBool = false;
  String nextPage = '';

  List<ControlInventarioModel> _controlList = [];

  List<Item> selectList;

  List<Offset> points = [];

  bool loopTimerNumber = false;
  TextStyle textstyledur;
  
  final scaffoldMain = new GlobalKey<ScaffoldState>();

  bool verificar_materiales = false;
  bool verificar_ordenIniciada = false;

  @override
  void initState() {
    super.initState();
    verificarOrdenIniciada();
    verificarMateriales();
    setState(() {
      identidadAbon = "Abonado: "+identificacionAbon;
      nombresAbon = "Nombres: "+nombresApellidos;
      actividadOrden = "Actividad: "+actividadNombre;
      telefonoUs = telefono;
      fijoUs = telefonoFijo;
      duracionA = duracionActividad*60;
      sliderTimeValue = duracionA;
      ordenFromBD = ordenBD;
      duracionOrden = duracionA;
    });
    textstyledur = TextStyle(
      color: colorTimerNumberOn, 
      fontSize: 17, 
      fontFamily: 'DsDigital', 
      fontWeight: FontWeight.bold,
    );
    _obtenerCablemodems();
    _obtenerHoraInicio();
  }

  Future<bool> _onBackPressed() {
    nextPageBool = true;
    nextPage = "/tab_page";
    goNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: scaffoldMain,
        appBar: new AppBar(
          backgroundColor: Color(0xFF0277bc),
          leading: IconButton(
            onPressed: () {
              _onBackPressed();
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Visibility(
            visible: visibleBarTimer,
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 13),
                        child: AnimatedDefaultTextStyle(
                          child: Text(minutosRestantes.toString()+":"+segundosRestantes.toString()),
                          textAlign: TextAlign.center,
                          style: textstyledur, //TextStyle( color: colorTimerNumber, fontSize: 17, fontFamily: 'DsDigital', fontWeight: FontWeight.bold,),
                          duration: Duration(milliseconds: 800),
                          onEnd: loopTimerNumber ? endCallback2 : null,
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 13),
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: colorTimerBar.withOpacity(1),
                            inactiveTrackColor: Colors.white.withOpacity(.5),
                            trackHeight: 4.0,
                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
                          ),
                          child: Slider(
                            value: sliderTimeValue,
                            min: 0,
                            max: duracionA,
                            label: '$sliderTimeValue',
                            onChanged: (value) { },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ),
          ),
          actions: <Widget>[
            Visibility(
              child: IconButton(
                onPressed: () { 
                  //Confirmacion del timer
                  if(verificar_ordenIniciada)
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Orden ya Iniciada'),
                        content: Text('Ya hay una Orden en transcurso, terminala antes de continuar con una nueva Orden.'),
                        actions: [
                          FlatButton(
                            textColor: Color(0xFF0277bc),
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text('Ok'),
                          ),
                        ],
                      )
                    );
                  else if(verificar_materiales)
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Iniciar Orden?'),
                        content: Text('Esta seguro de iniciar de la Orden.'),
                        actions: [
                          FlatButton(
                            textColor: Color(0xFF0277bc),
                            onPressed: () {Navigator.of(context).pop();},
                            child: Text('Cancelar'),
                          ),
                          FlatButton(
                            textColor: Color(0xFF0277bc),
                            onPressed: () {
                              setState(() {
                                visibleBarTimer = true;
                                visibleButtonTimer = false;
                                timerIniciado = true;
                                _setHoraInicio();
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text('Iniciar'),
                          ),
                        ],
                      )
                    );
                  else 
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Materiales insuficientes'),
                        content: Text('Ve al panel de Materiales y solicitalos!'),
                        actions: [
                          FlatButton(
                            textColor: Color(0xFF0277bc),
                            onPressed: () {
                              setState(() {
                                tabNum = 3;
                                Navigator.of(context).pushNamedAndRemoveUntil('/tab_page', (Route<dynamic> route) => false);
                              });
                            },
                            child: Text('Ir'),
                          ),
                        ],
                      )
                    );
                },
                icon: Icon(FontAwesomeIcons.stopwatch),
              ),
              visible: visibleButtonTimer, 
            ),
            
            IconButton(
              onPressed: () {
                nextPageBool = true;
                nextPage = "/map_orden";
                goNextPage();
              },
              icon: Icon(FontAwesomeIcons.mapMarkedAlt),
            ),
          ],
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: Container(
                    width: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[ Icon(Icons.location_on, color: Color(0xFF0277bc)), ],
                    ),
                  ),
                  title: AutoSizeText( "Ubicación", style: TextStyle( color: Color(0xFF606060), fontSize: 13 ), 
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText( direccionOrden, style: TextStyle( color: Colors.black, fontSize: 15 ), 
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: (){ 
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Ubicación'),
                        content: Text(direccionOrden),
                        actions: [
                          FlatButton(
                            textColor: Color(0xFF0277bc),
                            onPressed: () {Navigator.of(context).pop();},
                            child: Text('OK'),
                          ),
                        ],
                      )
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 0),
                margin: EdgeInsets.only(left: 70, top: 0),
                width: MediaQuery.of(context).size.width,
                child: Divider( height: 0.5, color: Colors.black, ),
              ),

              Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: Container(
                    width: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[ Icon(Icons.info_outline, color: Color(0xFF0277bc)), ],
                    ),
                  ),
                  title: AutoSizeText( "Info.", style: TextStyle( color: Color(0xFF606060), fontSize: 13 ), 
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText( '${identidadAbon}\n${nombresAbon}\n${actividadOrden}', style: TextStyle( color: Colors.black, fontSize: 15 ), 
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: (){ 
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Información'),
                        content: Text('${identidadAbon}\n${nombresAbon}\n${actividadOrden}'),
                        actions: [
                          FlatButton(
                            textColor: Color(0xFF0277bc),
                            onPressed: () {Navigator.of(context).pop();},
                            child: Text('OK'),
                          ),
                        ],
                      )
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 0),
                margin: EdgeInsets.only(left: 70, top: 0),
                width: MediaQuery.of(context).size.width,
                child: Divider( height: 0.5, color: Colors.black, ),
              ),

              Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: Container(
                    width: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[ Icon(Icons.phone, color: Color(0xFF0277bc)), ],
                    ),
                  ),
                  title: AutoSizeText( "Contacto", style: TextStyle( color: Color(0xFF606060), fontSize: 13 ), 
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText( telefonoUs+" - "+telefonoFijo, style: TextStyle( color: Colors.black, fontSize: 15 ), 
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  /*trailing: Tooltip(
                    message: 'Copiar',
                    child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: () { },
                          icon: Icon(Icons.copy_outlined, color: Color(0xFF0277bc)),
                        ),
                      ),
                  ),*/
                  onTap: (){ 
                    showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: Text('Contacto'),
                        children: <Widget>[
                          Column(
                            children: [
                              if(telefonoUs != '' || telefonoUs != null || telefonoUs.toString().length == 10)
                                Container(
                                  padding: EdgeInsets.only(right: 20, left: 20),
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(telefonoUs, style: TextStyle(fontSize: 15),),
                                      Container(
                                        child: Row(
                                          children: [
                                            Tooltip(
                                              message: 'Llamar',
                                              child: Material(
                                                color: Colors.transparent,
                                                child: IconButton(
                                                  onPressed: () {
                                                    launch('tel://$telefonoUs');
                                                  },
                                                  icon: Icon(Icons.phone, color: Color(0xFF0277bc)),
                                                ),
                                              ),
                                            ),
                                            Tooltip(
                                              message: 'Copiar',
                                              child: Material(
                                                color: Colors.transparent,
                                                child: IconButton(
                                                  onPressed: () {
                                                    Clipboard.setData(new ClipboardData(text: telefonoUs));
                                                    scaffoldMain.currentState.showSnackBar(new SnackBar(
                                                      behavior: SnackBarBehavior.floating,
                                                      content: new AutoSizeText("Celular copiado al portapapeles.", 
                                                        //style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ), 
                                                      duration: Duration(milliseconds: 100),)
                                                    );
                                                  },
                                                  icon: Icon(Icons.copy_outlined, color: Color(0xFF0277bc)),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                  
                              Container(
                                padding: EdgeInsets.only(top: 0),
                                margin: EdgeInsets.only(left: 10, right: 10),
                                width: MediaQuery.of(context).size.width,
                                child: Divider( height: 0.5, color: Colors.black, ),
                              ),

                              if(telefonoFijo != '' || telefonoFijo != null)
                                Container(
                                  padding: EdgeInsets.only(right: 20, left: 20),
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(telefonoFijo, style: TextStyle(fontSize: 15),),
                                      Container(
                                        child: Tooltip(
                                          message: 'Copiar',
                                          child: Material(
                                            color: Colors.transparent,
                                            child: IconButton(
                                              onPressed: () {
                                                Clipboard.setData(new ClipboardData(text: telefonoFijo));
                                                scaffoldMain.currentState.showSnackBar(new SnackBar(
                                                  behavior: SnackBarBehavior.floating,
                                                  content: new AutoSizeText("Fijo copiado al portapapeles.", 
                                                    //style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ), 
                                                  duration: Duration(milliseconds: 100),)
                                                );
                                              },
                                              icon: Icon(Icons.copy_outlined, color: Color(0xFF0277bc)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          )
                        ],
                      )
                    );
                  },
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFd6d6d6),
                  border: new Border(
                    bottom: BorderSide(width: 1, color: Color(0xFFadadad)),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(10, 4, 4, 4),
                child: AutoSizeText(
                  "Dispositivo",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF636363)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Container(child: _crearSelect(context)),

              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFd6d6d6),
                  border: new Border(
                    bottom: BorderSide(width: 1, color: Color(0xFFadadad)),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(10, 4, 4, 4),
                child: AutoSizeText(
                  "Materiales usados",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF636363)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Expanded(flex: 6,child: _crearListado(context)),

              Container(
                padding: EdgeInsets.only(top: 0),
                margin: EdgeInsets.only(left: 0, top: 0),
                width: MediaQuery.of(context).size.width,
                child: Divider( height: 0.5, color: Colors.black, ),
              ),

              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 2
                          ),
                          child: new ElevatedButton(
                            child: new AutoSizeText(
                              'Finalizar Orden',
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onPressed: () {
                              if(timerIniciado){
                                if(verificar_materiales){
                                  finalizarOrden();
                                  nextPageBool = true;
                                  nextPage = "/firma_page";
                                  goNextPage();
                                }else
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Materiales insuficientes'),
                                      content: Text('Ve al panel de Materiales y solicitalos!'),
                                      actions: [
                                        FlatButton(
                                          textColor: Color(0xFF0277bc),
                                          onPressed: () {
                                            setState(() {
                                              tabNum = 3;
                                              Navigator.of(context).pushNamedAndRemoveUntil('/tab_page', (Route<dynamic> route) => false);
                                            });
                                          },
                                          child: Text('Ir'),
                                        ),
                                      ],
                                    )
                                  );
                              }
                              else
                                showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  //title: Text('Reset settings?'),
                                  content: Text('Debes inciar el Contador de la Orden.'),
                                  actions: [
                                    FlatButton(
                                      textColor: Color(0xFF0277bc),
                                      onPressed: () {Navigator.of(context).pop();},
                                      child: Text('OK'),
                                    ),
                                  ],
                                ));
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )
                              )
                            )
                          ),
                        ),
                      )
                    ),
                  ]
                ),
              )

            ],
          ),

        ),
      ),
    );

  }

  verificarOrdenIniciada() async {
    String id = codigoTecnico.toString();
    String enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/appMovilController.php?funcion=validarOrdenInit&codigoTecnico="+id;
    print(enlace);
    http.Response response = await http.get(Uri.parse(enlace));
    var data = json.decode(response.body);
    verificar_ordenIniciada = data;
  }

  verificarMateriales() async {
    String id = codigoTecnico.toString();
    String enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/appMovilController.php?funcion=validarMateriales&codigoTecnico="+id+"&tipoA="+tipoActividad;
    http.Response response = await http.get(Uri.parse(enlace));
    var data = json.decode(response.body);
    verificar_materiales = data;
  }

  endCallback2(){
    animateState();
  }

  void animateState(){
    if(colorTimerNumberOn.toString() == textstyledur.color.toString()){
      setState(() {
        textstyledur = TextStyle(
          color: colorTimerNumberOff,
          fontSize: 17, 
          fontFamily: 'DsDigital', 
          fontWeight: FontWeight.bold,
        );
      });
    }else{
      setState(() {
        textstyledur = TextStyle(
          color: colorTimerNumberOn,
          fontSize: 17, 
          fontFamily: 'DsDigital', 
          fontWeight: FontWeight.bold,
        );
      });
    }
  }

  Widget _crearListado(BuildContext context){
    return  Container(
      margin: EdgeInsets.only(top: 0),
      child: FutureBuilder(
        future: _obtenerMateriales(),
        builder: (BuildContext context, AsyncSnapshot<List<MaterialModel>> snapshot){
          if(snapshot.hasData){
            List<MaterialModel> materiales = snapshot.data;
            return Container(
              margin: EdgeInsets.only(top: 0, bottom: 0),
              child: Scrollbar(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: materiales.length,
                  itemBuilder: (context, i){
                    _controlList.add( new ControlInventarioModel(materiales[i].idMaterial, materiales[i].cantidadMinima) );
                    return _crearItem(context, materiales[i], i);
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 0,
                    color: Color(0xFF707070),
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _crearItem(BuildContext context, MaterialModel material, int i){
    return ListTile(
      title: AutoSizeText('${material.nombre}', style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold, ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: _cajaNum(context, i, material.idMaterial),
      onTap: (){ },
    );
  }

  Widget _cajaNum(BuildContext context, int i, int idMaterial){
    return SizedBox(
      width: 60,
      height: 30,
      child: Container(
        child: TextField(
          controller: TextEditingController()
            ..text = _controlList
                .firstWhere(
                    (element) => element.idMaterial == idMaterial)
                .cantControl ==
                null
                ? ''
                : _controlList
                .firstWhere((element) => element.idMaterial == idMaterial)
                .cantControl
                .toString(),
          onChanged: (value){
            _controlList[i].cantControl = int.parse(value);
          },
          onEditingComplete: (){
            FocusScope.of(context).unfocus();
          },
          onSubmitted: (value) {},
          style: TextStyle( fontSize: 15,),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<List<MaterialModel>> _obtenerMateriales() async{
    String id = codigoTecnico.toString();
    String enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/getMaterialesOrden.php?codigoTecnico="+id+"&tipoA="+tipoActividad;
    http.Response response = await http.get(Uri.parse(enlace));
    var data = json.decode(response.body);
    List materiales = data['materiales'];

    var MyArray = [new MaterialModel( idMaterial: int.parse(materiales[0]['id_material_tecnico']), nombre: materiales[0]['nombre'], cantidadMinima: int.parse(materiales[0]['cantidadMinimaOrden']))];
    int tamanio = materiales.length;
    for(var i = 1; i < tamanio; i++){
      MaterialModel temp = new MaterialModel(idMaterial: int.parse(materiales[i]['id_material_tecnico']), nombre: materiales[i]['nombre'], cantidadMinima: int.parse(materiales[i]['cantidadMinimaOrden']));
      MyArray.add(temp);
    }
    tamanioMateriales = tamanio;

    /*return Future.delayed(
      Duration(seconds: 2),
        () => MyArray,
    );*/
    return MyArray;
  }


  Widget _crearSelect(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[ ListTile(
        title: AutoSizeText('CABLEMODEM', style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold,), 
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Container(
            child: DropdownButton<Item>(
              value: valorElegido,
              onChanged: (Item newValue){
                setState(() {
                  valorElegido = newValue;
                });
              },
              items: selectList?.map((Item valueItem) {
                return new DropdownMenuItem<Item>(
                  value: valueItem,
                  child: AutoSizeText(valueItem.mac, style: TextStyle( fontSize: 14,),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              })?.toList(),
              /*hint: AutoSizeText("Seleccione", style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold,),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),*/
            )
        ),
      ),],
    );
  }

  Future<List<Item>> _obtenerCablemodems() async{
    String id = codigoTecnico.toString();
    String enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/getCablemodemsOrden.php?codigoTecnico="+id;
    http.Response response = await http.get(Uri.parse(enlace));
    var data = json.decode(response.body);

    List cablemodems = data['cablemodems'];
    var MyArray = [new Item(idCablemodem: int.parse(cablemodems[0]['idCablemodem']), mac: cablemodems[0]['mac'])];
    int tamanio = cablemodems.length;
    for(var i = 1; i < tamanio; i++){
      Item temp = new Item(idCablemodem: int.parse(cablemodems[i]['idCablemodem']), mac: cablemodems[i]['mac']);
      MyArray.add(temp);
    }

    setState(() {
      selectList = MyArray;
      valorElegido = selectList[0];
    });
  }

  _obtenerHoraInicio() async {
    String enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/appMovilController.php?idOrden="+int.parse(idOrden).toString()+"&funcion=getFechaInicio&tipoOrden="+ordenFromBD;
    print(enlace);
    http.Response response = await http.get(Uri.parse(enlace));
    var data = json.decode(response.body);
    if(data['diff'] != 'null'){
      fechaInicio = data['ok'][0]['fecha_inicio'];
      if(fechaInicio != null){
        setState(() {
          visibleBarTimer = true;
          visibleButtonTimer = false;
          timerIniciado = true;
        });
        int difSegundos = (data['time_dif']['d']*86400)+(data['time_dif']['h']*3600)+(data['time_dif']['i']*60)+(data['time_dif']['s']);
        if(difSegundos > duracionA)
          sliderTimeValue = 0;
        else
          sliderTimeValue = duracionA - difSegundos;
        timerOnOrden();
      }
    }
  }

  _setHoraInicio() async {
    String enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/appMovilController.php?idOrden="+int.parse(idOrden).toString()+"&funcion=setFechaInicio&tipoOrden="+ordenFromBD;
    print(enlace);
    http.Response response = await http.get(Uri.parse(enlace));
    _obtenerHoraInicio();
  }

  timerOnOrden() {
    _timer = null;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if(nextPageBool){
        _timer.cancel();
        if(mounted)
          Navigator.pushReplacementNamed(context, nextPage);
      }else if(sliderTimeValue > 0){
        setState(() {
          sliderTimeValue--;
          if(sliderTimeValue < 120)
            colorTimerBar = Colors.red;
        });
      }
      if(sliderTimeValue < 1){
        fueraTiempo = true;
        setState(() {
          loopTimerNumber = true;
        });
        endCallback2();
        _timer.cancel();
      }
      converMinutosSegundos(sliderTimeValue);
    });
  }

  converMinutosSegundos(valor) {
    int minutos = (valor/60).toInt();
    int segundos = (valor%60).toInt();
    setState(() {
      if(minutos.toString().length < 2)
        minutosRestantes = "0"+minutos.toString();
      else
        minutosRestantes = minutos.toString();

      if(segundos.toString().length < 2)
        segundosRestantes = "0"+segundos.toString();
      else
        segundosRestantes = segundos.toString();
    });
  }

  goNextPage() {
    if(!timerIniciado || fueraTiempo)
      Navigator.pushReplacementNamed(context, nextPage);
  }

  Future finalizarOrden() async{
    //"https://tecnicoscm.herokuapp.com/tecnico/tecnicos/pruebaDatos"
    //"http://ns212.cablebox.co:5510/appmovil/postOrden.php"
    String jsonMateriales = "";
    var arrayP = [];
    for(int i = 0;i < tamanioMateriales; i++){
      if(i == (tamanioMateriales-1)){
        jsonMateriales += jsonEncode(_controlList[i]);
      }
      else{
        jsonMateriales += jsonEncode(_controlList[i]);
        jsonMateriales += ",";
      }
    }
    arrayP.add(jsonMateriales);
    matarialesOrden = arrayP.toString();

    /*var datauser = json.decode(response.body);

    print(datauser);
    if(datauser['ok'] == 'Orden Finalizada Correctamente'){
      _onBackPressed();
    }*/
  }

}

class MyCustomPainter extends CustomPainter{

  List<Offset> points;

  MyCustomPainter({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Color(0xFFdbdbdb);
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);

    Paint paint = Paint();
    paint.color = Colors.black;
    paint.strokeWidth = 2.0;
    paint.isAntiAlias = true;
    paint.strokeCap = StrokeCap.round;

    for(int x = 0; x<points.length-1; x++){
      if(points[x] != null && points[x+1] != null){
        canvas.drawLine(points[x], points[x+1], paint);
      } else if(points[x] != null && points[x+1] == null){
        canvas.drawPoints(PointMode.points, [points[x]], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tecnicos_cm/main.dart';
import 'package:tecnicos_cm/cusicon_icons.dart';
import 'package:tecnicos_cm/pages/ordenesRealizadas_page.dart';
import 'package:tecnicos_cm/pages/ordenes_page.dart';
import 'tab_page.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrdenRealizadaPage extends StatefulWidget {
  OrdenRealizadaPage({this.idOrden, this.direccionOrden, this.nombresApellidos, this.identificacionAbon, this.actividadNombre, this.telefono});
  final String idOrden;
  final String direccionOrden;
  final String nombresApellidos;
  final String identificacionAbon;
  final String actividadNombre;
  final String telefono;
  @override
  _OrdenRealizadaPageState createState() => _OrdenRealizadaPageState();
}

class MaterialModel{
  int idMaterial;
  String nombre;
  String cantidadUsada;
  MaterialModel({this.idMaterial, this.nombre, this.cantidadUsada});
}

class ControlInventarioModel{
  int idMaterial;
  String cantControl;
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

class _OrdenRealizadaPageState extends State<OrdenRealizadaPage> {

  String nombresAbon = '';
  String identidadAbon = '';
  String actividadOrden = '';
  String telefonoUs = '';
  int tamanioMateriales = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      identidadAbon = "Abonado: " + identificacionAbonR;
      nombresAbon = "Nombres: " + nombresApellidosR;
      actividadOrden = "Actividad: " + actividadNombreR;
      telefonoUs = telefonoOrdenCompleta;
    });
    _obtenerMateriales();
  }

  List<ControlInventarioModel> _controlList = [];

  Item valorElegido;
  List<Item> selectList;

  Future<bool> _onBackPressed() {
    tabNum = 1;
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
                _onBackPressed();
              },
              icon: Icon(Icons.arrow_back),
            ),
            //title:
            backgroundColor: Color(0xFF0277bc),
            /*actions: <Widget>[
              IconButton(
                onPressed: () {
                  //googleMaps
                },
                icon: Icon(FontAwesomeIcons.mapMarkedAlt),
              ),
            ],*/
          ),
          resizeToAvoidBottomInset: false,
          body: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.white],
                  //colors: [Colors.black26, Colors.white60],
                )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ListTile(
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
                  subtitle: AutoSizeText( direccionOrdenR, style: TextStyle( color: Colors.black, fontSize: 15 ), 
                    maxLines: 2,
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
                      children: <Widget>[ Icon(Icons.phone, color: Color(0xFF0277bc)), ],
                    ),
                  ),
                  title: AutoSizeText( "Teléfono", style: TextStyle( color: Color(0xFF606060), fontSize: 13 ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: AutoSizeText( telefonoUs, style: TextStyle( color: Colors.black, fontSize: 15 ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  /*trailing: IconButton(
                    onPressed: () { },
                    icon: Icon(Icons.copy_outlined, color: Color(0xFF0277bc)),
                  ),*/
                  onTap: (){ },
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
                    "Materiales usados",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF636363)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                Expanded(flex: 6,child: _crearListado(context)),

              ],
            ),
          )
      ),
    );
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
                    _controlList.add(
                        new ControlInventarioModel(materiales[i].idMaterial, materiales[i].cantidadUsada));
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
      title: AutoSizeText('${material.nombre}', style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold,),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: _cajaNum(context, i, material.idMaterial),
      onTap: (){ },
    );
  }

  Widget _cajaNum(BuildContext context, int i, int idMaterial){
    return SizedBox(
      width: 130,
      child: Container(
        child: TextField(
          enabled: false,
          focusNode: FocusNode(),
          enableInteractiveSelection: false,
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
          style: TextStyle( fontSize: 15,),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }



  Future<List<MaterialModel>> _obtenerMateriales() async{
    String id = idOrdenR.toString();
    String enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/getMaterialesOrdenR.php?idOrden="+id;
    http.Response response = await http.get(Uri.parse(enlace));
    var data = json.decode(response.body);
    //print(data);

    List materiales = data['materiales'];
 
    List<MaterialModel> MyArray = [];
    if(materiales.length > 0){
      MyArray = [new MaterialModel( idMaterial: int.parse(materiales[0]['id_material']), nombre: materiales[0]['nombre'], cantidadUsada: materiales[0]['cantidad'])];
      int tamanio = materiales.length;
      for(var i = 1; i < tamanio; i++){
        MaterialModel temp = new MaterialModel(idMaterial: int.parse(materiales[i]['id_material']), nombre: materiales[i]['nombre'], cantidadUsada: materiales[i]['cantidad']);
        MyArray.add(temp);
      }
      tamanioMateriales = tamanio;
    }else{
      tamanioMateriales = 0;
    }

    return Future.delayed(
      Duration(seconds: 2),
          () => MyArray,
    );
  }

}

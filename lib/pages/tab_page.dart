import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tecnicos_cm/main.dart';
import 'package:tecnicos_cm/pages/estadisticas_page.dart';
import 'package:tecnicos_cm/pages/material_page.dart';
import 'package:tecnicos_cm/pages/ordenesRealizadas_page.dart';
import 'package:tecnicos_cm/pages/ordenes_page.dart';
import 'package:tecnicos_cm/pages/profile_page.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:badges/badges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

int numOrdenes = 0;
bool notiOrdenes = true;
double padBadg = 5;
double topPosBadg = -10;

int tabNum = 0;

class TabPage extends StatefulWidget {
  TabPage({this.codigoTecnico, this.nombreTecnico, this.cargoTecnico, this.numOrdenes});
  final int codigoTecnico;
  final String nombreTecnico;
  final String cargoTecnico;
  final int numOrdenes;
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  TabController tabController;
  List<Tab> myTabs = <Tab>[
    new Tab(icon: Badge(
      badgeColor: Color(0xFFed5565),
      badgeContent: AutoSizeText(
        "${numOrdenes}",
        style: TextStyle(color: Colors.white),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ), //Text( "${numOrdenes}", style: TextStyle(color: Colors.white), ),
      child: Icon(FontAwesomeIcons.clipboard),
    ),),
    new Tab(icon: Icon(FontAwesomeIcons.clipboardCheck),),
    new Tab(icon: Icon(FontAwesomeIcons.chartPie),),
    new Tab(icon: Icon(FontAwesomeIcons.tools),),
    //new Tab(icon: Icon(Icons.portrait),)
  ];

  @override
  void initState() {
    super.initState();
    numOrdenes = numOrdenesInicial;
    tabController = new TabController(length: myTabs.length, vsync: this);
    tabController.index = tabNum;
    tabNum = 0;
    tabController.addListener(() {
      setState(() {
        print("index ${tabController.index}");
      });
    });
    
    funcionesSocket();
    actualizarOrdebesDisponibles();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void cerrarSesion(){
    FlutterSession().set('token', '');
    Navigator.pushReplacementNamed(context, '/login_page');
  }

  void goPerfil(){
    setState(() {
      codigoTecnico = codigoTecnico;
      nombreTecnico = nombreTecnico;
      cargoTecnico = cargoTecnico;
    });
    Navigator.pushReplacementNamed(context, '/profile_page');
  }

  //Socket
  void funcionesSocket() {
    client.on('actualizar_ordenes', (data) {
      print('actualizar_ordenes');
      actualizarOrdebesDisponibles();
    });
  }

  void actualizarOrdebesDisponibles() async {
    String id = codigoTecnico.toString();
    String enlace = "http://"+ip_base+":"+puerto_base+"/appmovil/getOrdenes.php?codigoTecnico="+id;
    http.Response response = await http.get(Uri.parse(enlace));
    var data = json.decode(response.body);
    ordenes = data['ordenes'];
    if (mounted) {
      setState(() {
        numOrdenes = ordenes.length;
        if(numOrdenes > 0)
          notiOrdenes = true;
        else
          notiOrdenes = false;
      });
      print("Actualizar num ordenes "+numOrdenes.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          title: Image.asset('assets/images/Ocex.png', width: 100, fit: BoxFit.fitWidth,),
          backgroundColor: Color(0xFF0277bc),
          actions: <Widget>[
            PopupMenuButton(
              padding: const EdgeInsets.only(top: 0, right: 0, bottom: 0, left: 0),
              onSelected: (result) {
                if (result == 0) {
                  goPerfil();
                }
                else if (result == 1) {
                  cerrarSesion();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                const PopupMenuItem(
                  value: 0,
                  child: Text('Perfil'),
                ),
                const PopupMenuItem(
                  value: 1,
                  child: Text('Cerrar sesión'),
                ),
              ],
            ),
          ],

          bottom: new TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Badge(
                badgeColor: Colors.white,
                badgeContent: AutoSizeText(
                  "${numOrdenes}",
                  style: TextStyle(color: Color(0xFF0277bc), fontSize: 12, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ), //Text( "${numOrdenes}", style: TextStyle(color: Color(0xFF0277bc), fontSize: 12, fontWeight: FontWeight.bold),),
                showBadge: notiOrdenes,
                child: Icon(FontAwesomeIcons.clipboard),
              ),),
              Tab(icon: Icon(FontAwesomeIcons.clipboardCheck),),
              Tab(icon: Icon(FontAwesomeIcons.chartPie),),
              Tab(icon: Icon(FontAwesomeIcons.tools),),
            ],
            controller: tabController,
          ),
        ),
        body: new TabBarView(
          children: [
            new OrdenesPage(),
            new OrdenesRealizadasPage(),
            new EstadisticasPage(),
            new MaterialesPage(codigoTecnico: codigoTecnico,),
          ],
          controller: tabController,
        ),
      ),
    );
  }
}
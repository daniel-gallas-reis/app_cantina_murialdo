import 'package:app_cantina_murialdo/models/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAdminBottomNavigationBar extends StatefulWidget {
  @override
  _CustomAdminBottomNavigationBarState createState() =>
      _CustomAdminBottomNavigationBarState();
}

class _CustomAdminBottomNavigationBarState extends State<CustomAdminBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final int currentPage = context.watch<PageManager>().page;

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromRGBO(69, 55, 39, 1.0)),
            title: Text('Início')),
        BottomNavigationBarItem(
            icon: Icon(Icons.fastfood, color: Color.fromRGBO(69, 55, 39, 1.0)),
            title: Text('Produtos')),
        BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add_check,
                color: Color.fromRGBO(69, 55, 39, 1.0)),
            title: Text('Meus Pedidos')),
        BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Color.fromRGBO(69, 55, 39, 1.0)),
            title: Text('Minha Conta')),
        BottomNavigationBarItem(
            icon: Icon(Icons.people,
                color: Color.fromRGBO(69, 55, 39, 1.0)),
            title: Text('Usuários')),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Color.fromRGBO(69, 55, 39, 1.0)),
            title: Text('Pedidos')),
      ],
      currentIndex: currentPage,
      selectedItemColor: const Color.fromRGBO(69, 55, 39, 1.0),
      onTap: (int index) {
        setState(() {
          context.read<PageManager>().setPage(index);
        });
      },
    );
  }
}

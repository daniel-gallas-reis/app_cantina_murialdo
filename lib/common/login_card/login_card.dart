import 'package:app_cantina_murialdo/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Theme.of(context).primaryColor,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 100,
              ),
              const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Faça login para acessar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white
                    ),
                  ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: RaisedButton(
                    onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginScreen()));
                    },
                    color: Colors.white,
                    textColor: Theme.of(context).primaryColor,
                    child: const Text(
                      'Fazer Login'
                    ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

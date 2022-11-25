import 'package:app_cantina_murialdo/models/page_manager.dart';
import 'package:app_cantina_murialdo/models/user_manager.dart';
import 'package:app_cantina_murialdo/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
      height: 220,
      child: Consumer<UserManager>(
          builder: (_,userManager, __){
            return Container(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              height: 100,
              width: 1000,
              color: Theme.of(context).primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.zero,
                        padding: const EdgeInsets.only(bottom: 10,),
                        child: Image.asset('images/logo_cantina_branco.png', /*scale: 40,*/)
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text(
                      'Olá, ${userManager.user?.name ?? ''}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2,),
                  GestureDetector(
                    onTap: (){
                      if(userManager.isLoggedIn){
                        context.read<PageManager>().setPage(0);
                        userManager.signOut();
                      }else{
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => LoginScreen()));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 50),
                      child: Text(
                        userManager.isLoggedIn ? 'Sair' : 'Entre ou Cadastre-se >',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,)
                ],
              ),
            );
          },
      ),
    );
  }
}

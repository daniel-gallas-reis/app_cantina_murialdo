import 'package:app_cantina_murialdo/models/user_manager.dart';
import 'package:app_cantina_murialdo/screens/login/login_screen.dart';
import 'package:app_cantina_murialdo/screens/my_account_screen/update_user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(
      builder: (_, userManager, __) {
        return !userManager.isLoggedIn
            ? Center(
                child: ListView(
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 150,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Você ainda não está logado!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          padding: const EdgeInsets.only(right: 85),
                          icon: const Icon(
                            Icons.person_add,
                            size: 100,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => LoginScreen()));
                          },
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => LoginScreen()));
                          },
                          child: const Text(
                            'Entre ou Cadastre-se >',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 40,),
                        const Divider(),
                        const Text('Confira também nossas redes sociais:', textAlign: TextAlign.center,),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () async{
                                const url = 'https://api.whatsapp.com/send?phone=5554991147919&text=Ol%C3%A1%20Cantina%20Murialdo%2C%20gostaria%20de%20pedir%3A%20';
                                if (await canLaunch(url)) {
                                  await launch(
                                    url,
                                    universalLinksOnly: true,
                                  );
                                } else {
                                  throw 'Não foi possivel acessar: $url';
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                height: 50,
                                child: Image.asset('images/whatsapp-logo-1-1.png'),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async{
                                const url = 'https://www.instagram.com/cantina_murialdo/';
                                if (await canLaunch(url)) {
                                  await launch(
                                    url,
                                    universalLinksOnly: true,
                                  );
                                } else {
                                  throw 'Não foi possivel acessar: $url';
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                height: 50,
                                child: Image.asset('images/instagram-logo-11.png'),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async{
                                const url = 'https://www.facebook.com/cantinamurialdo/';
                                if (await canLaunch(url)) {
                                  await launch(
                                    url,
                                    universalLinksOnly: true,
                                  );
                                } else {
                                  throw 'Não foi possivel acessar: $url';
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                height: 50,
                                child: Image.asset('images/facebook-logo-5.png'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
            : Center(
              child: ListView(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      //TODO: Imagem do usuário
                      Icons.account_circle,
                      size: 150,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Informações Pessoais',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20,),
                    Card(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Nome: ${userManager.user.name}', style: const TextStyle(fontSize: 25, color: Colors.white),),
                            const SizedBox(height: 5,),
                            Text('E-mail: ${userManager.user.email ?? ''}', style: const TextStyle(fontSize: 25, color: Colors.white)),
                            const SizedBox(height: 5,),
                            Text('Turma/Setor: ${userManager.user.serie ?? ''}', style: const TextStyle(fontSize: 25, color: Colors.white)),
                            const SizedBox(height: 5,),
                            Text('Crédito: R\$${userManager.user.credit.toStringAsFixed(2).replaceAll('.', ',') ?? ''}', style: const TextStyle(fontSize: 25, color: Colors.white)),
                            const SizedBox(height: 5,),
                            Text('E-mail do Responsável: ${userManager.user.parental_email ?? ''}', style: const TextStyle(fontSize: 25, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: RaisedButton(
                        padding: const EdgeInsets.all(20),
                        color: Theme.of(context).primaryColor,
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => UpdateUserScreen()));
                          },
                          child: const Text('Editar dados', style: TextStyle(color: Colors.white, fontSize: 18),),
                      ),
                    ),
                    const SizedBox(height: 40,),
                    const Divider(),
                    const Text('Confira também nossas redes sociais:', textAlign: TextAlign.center,),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async{
                            const url = 'https://api.whatsapp.com/send?phone=5554991147919&text=Ol%C3%A1%20Cantina%20Murialdo%2C%20gostaria%20de%20pedir%3A%20';
                            if (await canLaunch(url)) {
                              await launch(
                                url,
                                universalLinksOnly: true,
                              );
                            } else {
                              throw 'Não foi possivel acessar: $url';
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            height: 50,
                            child: Image.asset('images/whatsapp-logo-1-1.png'),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async{
                            const url = 'https://www.instagram.com/cantina_murialdo/';
                            if (await canLaunch(url)) {
                              await launch(
                                url,
                                universalLinksOnly: true,
                              );
                            } else {
                              throw 'Não foi possivel acessar: $url';
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            height: 50,
                            child: Image.asset('images/instagram-logo-11.png'),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async{
                            const url = 'https://www.facebook.com/cantinamurialdo/';
                            if (await canLaunch(url)) {
                              await launch(
                                url,
                                universalLinksOnly: true,
                              );
                            } else {
                              throw 'Não foi possivel acessar: $url';
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            height: 50,
                            child: Image.asset('images/facebook-logo-5.png'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
            );
      },
    );
  }
}

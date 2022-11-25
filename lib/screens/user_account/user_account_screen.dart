import 'package:app_cantina_murialdo/models/user.dart';
import 'package:app_cantina_murialdo/models/user_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class UserAccountScreen extends StatelessWidget {

  UserAccountScreen(this.user);

  final User user;

  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(
      builder: (_, userManager, __) {
        return Scaffold(
          appBar:  AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: const Color.fromRGBO(69, 55, 39, 1.0),
            //rgb(69, 55, 39)
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  child: Image.asset('images/logo_pequeno.png'),
                ),
                Container(
                  width: 150,
                  child: Text(
                    user.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                  icon: const Icon(Icons.file_download),
                  onPressed: () async{
                    final file = await screenshotController.capture();
                    await GallerySaver.saveImage(file.path);
                  },
              )
            ],
          ),
          body: Center(
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
                Screenshot(
                  controller: screenshotController,
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Nome: ${user.name}', style: const TextStyle(fontSize: 25, color: Colors.white),),
                          const SizedBox(height: 5,),
                          Text('E-mail: ${user.email ?? ''}', style: const TextStyle(fontSize: 25, color: Colors.white)),
                          const SizedBox(height: 5,),
                          Text('Turma/Setor: ${user.serie ?? ''}', style: const TextStyle(fontSize: 25, color: Colors.white)),
                          const SizedBox(height: 5,),
                          Text('Crédito: R\$${user.credit.toStringAsFixed(2).replaceAll('.', ',') ?? ''}', style: const TextStyle(fontSize: 25, color: Colors.white)),
                          const SizedBox(height: 5,),
                          Text('E-mail do Responsável: ${user.parental_email ?? ''}', style: const TextStyle(fontSize: 25, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

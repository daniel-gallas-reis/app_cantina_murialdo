import 'package:app_cantina_murialdo/helpers/validators.dart';
import 'package:app_cantina_murialdo/models/user.dart';
import 'package:app_cantina_murialdo/models/user_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateUserScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();


  final User user = User();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: false,
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
            const Text(
              'Editar Usuário',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __){
                return ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'Nome Completo'),
                      onSaved: (name) => user.name = name,
                      validator: (name) {
                        if (name.isEmpty) {
                          return 'Campo Obrigatório!';
                        } else if (name.trim().split(' ').length <= 1) {
                          return 'Insira seu nome comleto!';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'E-mail do Responsável'),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (email) {
                        if (email.isEmpty) {
                          return null;
                        } else if (!emailValid(email)) {
                          return 'E-mail inválido!';
                        }else{
                          return null;
                        }
                      },
                      onSaved: (email) => user.parental_email = email,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'Turma/setor'),
                      validator: (pass) {
                        if (pass.isEmpty) {
                          return null;
                        }else {
                          return null;
                        }
                      },
                      onSaved: (pass) => user.serie = pass,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Consumer<UserManager>(
                        builder: (_, userManager, __) {
                          return SizedBox(
                            height: 60,
                            width:  75,
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              disabledColor:
                              Theme.of(context).primaryColor.withAlpha(100),
                              textColor: Colors.white,
                              onPressed: userManager.loading ? null : () {
                                if (formKey.currentState.validate()) {
                                  user.id = userManager.user.id;
                                  user.credit = userManager.user.credit;
                                  user.email = userManager.user.email;
                                  formKey.currentState.save();

                                  context.read<UserManager>().editUser(
                                    user: user,
                                    onFail: (e) {
                                      scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text('Falha ao cadastrar: $e'),
                                        backgroundColor: Colors.red,
                                      ));
                                    },
                                    onSuccess: () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }
                              },
                              child: userManager.loading
                                  ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              )
                                  : const Text(
                                'Salvar',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:app_cantina_murialdo/helpers/validators.dart';
import 'package:app_cantina_murialdo/models/page_manager.dart';
import 'package:app_cantina_murialdo/models/user_manager.dart';
import 'package:app_cantina_murialdo/screens/base/base_screen.dart';
import 'package:app_cantina_murialdo/screens/login/widgets/stagger_animation.dart';
import 'package:app_cantina_murialdo/screens/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  AnimationController _animationController1;
  AnimationController _animationController2;

  @override
  void initState() {
    super.initState();

    _animationController1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController2 =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _animationController2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => BaseScreen(
                )));
      }
    });
  }

  @override
  void dispose() {
    _animationController1.dispose();
    _animationController2.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
        //drawer: CustomDrawer(pageController: pageController,),
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: const Color.fromRGBO(69, 55, 39, 1.0),
          //rgb(69, 55, 39)
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 50,
                child: Image.asset('images/logo_pequeno.png'),
              ),
              const Text(
                'Entrar',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            FlatButton(
                onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SignUpScreen()));
                },
                child: const Text('CRIAR CONTA', style: TextStyle(fontSize: 14, color: Colors.white),),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: ListView(
          children: [
            Center(
                child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.zero,
                  margin: const EdgeInsets.only(top: 25),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    // ignore: avoid_unnecessary_containers
                    child: Container(
                      child: Image.asset(
                        'images/logo_cantina_branco.png',
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Card(
                    margin: EdgeInsets.only(right: 16, left: 16, top: heightScreen * 0.33),
                    child: Form(
                      key: formKey,
                      child: Consumer<UserManager>(
                          builder: (_, userManager, __){
                            if(userManager.fbLoading){
                              return Padding(
                                padding: const EdgeInsets.all(32),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                                ),
                              );
                            }
                        return Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: emailController,
                                enabled: !userManager.loading,
                                decoration: const InputDecoration(hintText: 'E-mail'),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                validator: (email) {
                                  if (!emailValid(email)) {
                                    return 'Email Inválido';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: passwordController,
                                enabled: !userManager.loading,
                                decoration: const InputDecoration(hintText: 'Senha'),
                                autocorrect: false,
                                obscureText: true,
                                validator: (password) {
                                  if (password.isEmpty || password.length < 6) {
                                    return 'Senha inválida';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: FlatButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {},
                                  child: const Text('Esqueci minha senha!'),
                                ),
                              ),
                              /*const SizedBox(
                                height: 20,
                              ),*/
                              // ignore: avoid_unnecessary_containers
                              Container(
                                  //margin: EdgeInsets.only(top: heightScreen * 0.7),
                                  child: Center(
                                    child: StaggerAnimation(
                                      controller: _animationController1,
                                      controller2: _animationController2,
                                      formKey: formKey,
                                      passwordController: passwordController,
                                      emailController: emailController,
                                      scaffoldKey: scaffoldKey,
                                    ),
                                  )
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: SignInButton(
                                    Buttons.FacebookNew,
                                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                                    text: 'Entrar com Facebook',
                                    onPressed: (){
                                      userManager.facebookLogin(
                                          onFail: (e) {
                                            print(e);
                                            scaffoldKey.currentState.showSnackBar(SnackBar(
                                              content: Text('Falha ao entrar: $e'),
                                              backgroundColor: Colors.red,
                                            ));
                                          },
                                          onSuccess: (){
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => BaseScreen()));
                                          }
                                      );
                                    },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),

              ],
            )),
          ],
        ));
  }
}

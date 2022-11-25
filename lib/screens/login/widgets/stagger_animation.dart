import 'package:app_cantina_murialdo/models/user.dart';
import 'package:app_cantina_murialdo/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {
  final AnimationController controller;
  final AnimationController controller2;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<ScaffoldState> scaffoldKey;

  StaggerAnimation(
      {@required this.controller,
      @required this.controller2,
      @required this.formKey,
      @required this.passwordController,
      @required this.emailController,
      @required this.scaffoldKey})
      : buttonSqueeze = Tween<double>(begin: 320, end: 60).animate(
            CurvedAnimation(parent: controller, curve: const Interval(0, 0.150))),
        buttonZoomOut = Tween<double>(
          begin: 60,
          end: 1000,
        ).animate(CurvedAnimation(
            parent: controller2,
            curve: const Interval(0.50, 1.0, curve: Curves.bounceOut)));

  final Animation<double> buttonSqueeze;
  final Animation<double> buttonZoomOut;
  final GlobalKey<FormState> formKey;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: InkWell(
          onTap: () {
            if (!formKey.currentState.validate()) {
              return null;
            } else {
              controller.forward();
              context.read<UserManager>().sigIn(
                  user: User(
                    email: emailController.text,
                    password: passwordController.text,
                  ),
                  onFail: (e) {
                    controller.reverse();
                    passwordController.clear();
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text('Falha ao entrar: $e'),
                      backgroundColor: Colors.red,
                    ));
                  },
                  onSuccess: (){
                    controller2.forward();
                  });
            }
          },
          child: Hero(
            tag: 'fadeScreen',
            child: buttonZoomOut.value <= 60
                ? Container(
                    width: buttonSqueeze.value,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(69, 55, 39, 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: _buildInside(context),
                  )
                : Container(
                    width: buttonZoomOut.value,
                    height: buttonZoomOut.value,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(69, 55, 39, 1.0),
                        shape: buttonZoomOut.value < 500
                            ? BoxShape.circle
                            : BoxShape.rectangle),
                  ),
          ),
        ));
  }

  Widget _buildInside(BuildContext context) {
    if (buttonSqueeze.value < 75) {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        strokeWidth: 1.0,
      );
    } else {
      return const Text(
        'Entrar',
        style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: _buildAnimation,
    );
  }
}

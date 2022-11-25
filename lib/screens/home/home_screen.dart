import 'package:app_cantina_murialdo/common/custom_bottom_navigation_bar/custom_admin_bottom_navigation_bar.dart';
import 'package:app_cantina_murialdo/common/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:app_cantina_murialdo/common/custom_drawer/custom_drawer.dart';
import 'package:app_cantina_murialdo/models/home_manager.dart';
import 'package:app_cantina_murialdo/models/user_manager.dart';
import 'package:app_cantina_murialdo/screens/cart/cart_screen.dart';
import 'package:app_cantina_murialdo/screens/home/components/add_section_widgets.dart';
import 'package:app_cantina_murialdo/screens/home/components/section_list.dart';
import 'package:app_cantina_murialdo/screens/home/components/section_staggered.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(
      builder: (_, userManager, __) {
        return Scaffold(
            bottomNavigationBar: userManager.adminEnabled
                ? CustomAdminBottomNavigationBar()
                : CustomBottomNavigationBar(),
            drawer: CustomDrawer(),
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(69, 55, 39, 1.0),
                        Color.fromRGBO(69, 55, 39, 0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      snap: true,
                      floating: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      //Theme.of(context).primaryColor,
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: const EdgeInsets.only(top: 20),
                        centerTitle: true,
                        title: Container(
                          //height: 75,
                          child: Image.asset('images/logo_cantina_branco.png'),
                        ),
                      ),
                      actions: [
                        IconButton(
                          padding: const EdgeInsets.only(right: 10),
                          icon: const Icon(CupertinoIcons.shopping_cart),
                          color: Colors.white,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => CartScreen())),
                        ),
                        Consumer2<UserManager, HomeManager>(
                            builder: (_, userManager, homeManager, __) {
                          if (userManager.adminEnabled && !homeManager.loading) {
                            if (homeManager.editing) {
                              return PopupMenuButton(
                                onSelected: (e) {
                                  if (e == 'Salvar') {
                                    print('vou salvar');
                                    homeManager.saveEditing();
                                  } else {
                                    homeManager.discardEditing();
                                  }
                                },
                                itemBuilder: (_) {
                                  return ['Salvar', 'Descartar'].map((e) {
                                    return PopupMenuItem(
                                      value: e,
                                      child: Text(e),
                                    );
                                  }).toList();
                                },
                              );
                            } else {
                              return IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: homeManager.enterEditing,
                              );
                            }
                          } else {
                            return Container();
                          }
                        })
                      ],
                    ),
                    Consumer<HomeManager>(
                      builder: (_, homeManager, __) {
                        if (homeManager.loading) {
                          return const SliverToBoxAdapter(
                            child: LinearProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                              backgroundColor: Colors.transparent,
                            ),
                          );
                        }

                        final List<Widget> children =
                            homeManager.sections.map<Widget>((section) {
                          switch (section.type) {
                            case 'List':
                              return SectionList(section: section);
                            case 'Staggered':
                              return SectionStaggered(section: section);
                            default:
                              return Container();
                          }
                        }).toList();

                        if (homeManager.editing) {
                          children.add(AddSectionWidgets(
                            homeManager: homeManager,
                          ));
                        }

                        return SliverList(
                          delegate: SliverChildListDelegate(children),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }
}

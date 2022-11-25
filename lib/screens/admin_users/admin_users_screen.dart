import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:app_cantina_murialdo/models/admin_orders_manager.dart';
import 'package:app_cantina_murialdo/models/admin_users_manager.dart';
import 'package:app_cantina_murialdo/models/page_manager.dart';
import 'package:app_cantina_murialdo/screens/user_account/user_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AdminUsersManager>(
      builder: (_, adminUsersManager, __) {
        return AlphabetListScrollView(
          itemBuilder: (_, index) {
            return ListTile(
              title: Text(
                adminUsersManager.users[index].name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              subtitle: Text(
                adminUsersManager.users[index].email,
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
              onTap: (){
                context.read<AdminOrdersManager>().setUserFilter(
                  adminUsersManager.users[index]
                );
                context.read<PageManager>().setPage(5);
              },
              onLongPress: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => UserAccountScreen(adminUsersManager.users[index])));
              },
            );
          },
          highlightTextStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 20
          ),
          strList: adminUsersManager.names,
          indexedHeight: (index) => 80,
          showPreview: true,
        );
      },
    );
  }
}

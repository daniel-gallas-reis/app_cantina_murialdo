import 'package:app_cantina_murialdo/models/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerTile extends StatelessWidget {

  final IconData iconData;
  final String title;
  final int page;

  const DrawerTile({@required this.iconData, @required this.title, @required this.page});

  @override
  Widget build(BuildContext context) {

    final int currentPage = context.watch<PageManager>().page;

    return InkWell(
      onTap: (){
        context.read<PageManager>().setPage(page);
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Icon(
                  iconData,
                size: 32,
                color: currentPage == page ? const Color.fromRGBO(69, 55, 39, 1.0) : Colors.grey[700],
              ),
            ),
            const SizedBox(
              width: 32,
            ),
            Text(
                title,
              style: TextStyle(
                fontSize: 16,
                color: currentPage == page ? const Color.fromRGBO(69, 55, 39, 1.0) : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:app_cantina_murialdo/models/home_manager.dart';
import 'package:app_cantina_murialdo/models/section.dart';
import 'package:app_cantina_murialdo/screens/home/components/add_tile_widget.dart';
import 'package:app_cantina_murialdo/screens/home/components/item_tile.dart';
import 'package:app_cantina_murialdo/screens/home/components/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class SectionStaggered extends StatelessWidget {
  const SectionStaggered({@required this.section});

  final Section section;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(),
            Consumer<Section>(
              builder: (_, section, __){
                return StaggeredGridView.countBuilder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  itemCount: homeManager.editing
                      ? section.items.length + 1
                      : section.items.length,
                  itemBuilder: (_, index) {
                    if(index < section.items.length) {
                      return ItemTile(
                        item: section.items[index],
                      );
                    }else{
                      return AddTileWidget();
                    }
                  },
                  staggeredTileBuilder: (index) =>
                      StaggeredTile.count(2, index.isEven ? 2 : 1),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

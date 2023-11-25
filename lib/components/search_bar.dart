import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final String searchTarget;
  const SearchBarWidget({required this.searchTarget, super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SearchAnchor(
        suggestionsBuilder: (context, controller) {
          // TODO(searchBar) : do full text search on db items
          // var res = (db.artists.select()
          //       ..where(
          //           (tbl) => tbl.name.contains(controller.value.text)))
          //     .watch();
          return List<ListTile>.generate(5, (index) {
            final String item = 'item $index for ${widget.searchTarget}';
            return ListTile(
              title: Text(item),
              onTap: () {
                setState(() {
                  controller.closeView(item);
                });
              },
            );
          });
        },
        builder: (context, controller) {
          return SearchBar(
            controller: controller,
            onTap: () => controller.openView(),
            onChanged: (_) => controller.openView(),
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            leading: const Icon(Icons.search),
          );
        },
      ),
    );
  }
}

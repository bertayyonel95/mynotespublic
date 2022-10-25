import 'package:flutter/material.dart';

typedef TagCallBack = void Function(String tag);

class TagsListView extends StatelessWidget {
  final List<String> tagsList;
  final TagCallBack onTap;

  const TagsListView({
    Key? key,
    required this.tagsList,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tagListSetted = tagsList.toSet().toList();
    return ListView.builder(
      itemCount: tagListSetted.length,
      itemBuilder: (context, index) {
        final tag = tagListSetted.elementAt(index);
        return ListTile(
          onTap: () {
            onTap(tag);
          },
          title: Text(
            '#' + tag,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
              tagsList.where((element) => element == tag).length.toString()),
        );
      },
    );
  }
}

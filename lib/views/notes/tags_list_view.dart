import 'package:flutter/material.dart';

typedef TagCallBack = void Function(String tag);
typedef ResetCallBack = void Function();

class TagsListView extends StatelessWidget {
  final List<String> tagsList;
  final TagCallBack onTap;
  final ResetCallBack resetCallBack;

  const TagsListView({
    Key? key,
    required this.tagsList,
    required this.onTap,
    required this.resetCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tagListSetted = tagsList.toSet().toList();
    return Column(
      children: [
        Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 8.0),
            width: MediaQuery.of(context).size.width,
            child: TextButton(
                onPressed: resetCallBack, child: const Text('All Tags'))),
        Expanded(
          child: ListView.builder(
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
                trailing: Text(tagsList
                    .where((element) => element == tag)
                    .length
                    .toString()),
              );
            },
          ),
        ),
      ],
    );
  }
}

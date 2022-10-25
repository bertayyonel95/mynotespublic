import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';
import 'package:mynotes/views/notes/tags_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);
  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;
  FilterMenuAction _value = FilterMenuAction.ascending;
  late final TextEditingController _textEditingController;
  late final TextEditingController _searchController;
  late String _selectedTags;
  bool _selected = false;
  late final List<String> allTags;

  double startPos = -1.0;
  double endPos = 0.0;
  Curve curve = Curves.elasticOut;

  void hideWidget() {
    setState(() {
      _selected = !_selected;
      _searchController.clear();
    });
  }

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _searchController = TextEditingController();
    _notesService = FirebaseCloudStorage();
    allTags = [];
    _selectedTags = '';
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: hideWidget,
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton<FilterMenuAction>(
            icon: const Icon(Icons.sort),
            tooltip: 'Filter',
            onSelected: (value) {
              setState(() {
                _value = value;
              });
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<FilterMenuAction>(
                  value: FilterMenuAction.ascending,
                  child: Text('Ascending'),
                ),
                PopupMenuItem<FilterMenuAction>(
                  value: FilterMenuAction.descending,
                  child: Text('Descending'),
                ),
                PopupMenuItem<FilterMenuAction>(
                  value: FilterMenuAction.dateAscending,
                  child: Text('Older first'),
                ),
                PopupMenuItem<FilterMenuAction>(
                  value: FilterMenuAction.dateDescending,
                  child: Text('Newer first'),
                ),
              ];
            },
          ),
          IconButton(
            onPressed: () {
              _selectedTags = '';
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogout(),
                        );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 6, left: 6),
            child: TextField(
              enabled: _selected ? true : false,
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
            ),
            curve: Curves.fastOutSlowIn,
            height: _selected ? 50.0 : 0.0,
            alignment:
                _selected ? const Alignment(0, 0) : const Alignment(-1, -1),
          ),
          StreamBuilder(
            stream: _notesService.allNotes(ownerUserId: userId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting: //implicit fall through
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    List<CloudNote> allNotes = snapshot.data as List<CloudNote>;

                    final dummySearchList = allNotes;

                    if (_selectedTags == '') {
                      if (_searchController.text.isNotEmpty) {
                        List<CloudNote> dummyListData = <CloudNote>[];
                        for (var element in dummySearchList) {
                          if (element.text
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase())) {
                            dummyListData.add(element);
                          }
                        }
                        allNotes.clear();
                        allNotes.addAll(dummyListData);
                      }
                    } else {
                      if (_searchController.text.isNotEmpty) {
                        List<CloudNote> dummyListData = <CloudNote>[];
                        for (var element in dummySearchList) {
                          if (element.text.toLowerCase().contains(
                                  _searchController.text.toLowerCase()) &&
                              element.tags
                                  .toLowerCase()
                                  .contains(_selectedTags.toLowerCase())) {
                            dummyListData.add(element);
                          }
                        }
                        allNotes.clear();
                        allNotes.addAll(dummyListData);
                      } else {
                        List<CloudNote> dummyListData = <CloudNote>[];
                        for (var element in dummySearchList) {
                          if (element.tags
                              .toLowerCase()
                              .contains(_selectedTags.toLowerCase())) {
                            dummyListData.add(element);
                          }
                        }
                        allNotes.clear();
                        allNotes.addAll(dummyListData);
                      }
                    }

                    return Expanded(
                      child: NotesListView(
                        sortVar: _value,
                        notes: allNotes,
                        onDeleteNote: (note) async {
                          await _notesService.deleteNote(
                              documentId: note.documentId);
                        },
                        onTap: (note) {
                          Navigator.of(context).pushNamed(
                            createOrUpdateNoteRoute,
                            arguments: note,
                          );
                        },
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                default:
                  return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(children: [
          Spacer(),
          SizedBox(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _selectedTags = '';
                  Navigator.of(context).pop();
                });
              },
              child: const Text('All'),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _notesService.allNotes(ownerUserId: userId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting: //implicit fall through
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      List<CloudNote> allNotes =
                          snapshot.data as List<CloudNote>;
                      List<String> allTags = <String>[];
                      if (allNotes.isNotEmpty) {
                        for (var i = 0; i < allNotes.length; i++) {
                          if (allNotes[i].tags.isNotEmpty) {
                            allTags.add(allNotes[i].tags);
                          }
                        }
                      }
                      return TagsListView(
                        tagsList: allTags,
                        onTap: (tag) {
                          setState(() {
                            _selectedTags = tag;
                            Navigator.of(context).pop();
                          });
                        },
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  default:
                    return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}

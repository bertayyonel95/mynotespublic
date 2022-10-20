import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final String date;
  final String tags;

  const CloudNote({
    required this.date,
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    required this.tags,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : date = snapshot.data()[dateFieldName] as String,
        documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        tags = snapshot.data()[tagsFieldName],
        text = snapshot.data()[textFieldName] as String;
}

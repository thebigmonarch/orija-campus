// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ItemsFAQStruct extends BaseStruct {
  ItemsFAQStruct({
    String? id,
    String? answer,
    String? audience,
    String? question,
  })  : _id = id,
        _answer = answer,
        _audience = audience,
        _question = question;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "answer" field.
  String? _answer;
  String get answer => _answer ?? '';
  set answer(String? val) => _answer = val;

  bool hasAnswer() => _answer != null;

  // "audience" field.
  String? _audience;
  String get audience => _audience ?? '';
  set audience(String? val) => _audience = val;

  bool hasAudience() => _audience != null;

  // "question" field.
  String? _question;
  String get question => _question ?? '';
  set question(String? val) => _question = val;

  bool hasQuestion() => _question != null;

  static ItemsFAQStruct fromMap(Map<String, dynamic> data) => ItemsFAQStruct(
        id: data['id'] as String?,
        answer: data['answer'] as String?,
        audience: data['audience'] as String?,
        question: data['question'] as String?,
      );

  static ItemsFAQStruct? maybeFromMap(dynamic data) =>
      data is Map ? ItemsFAQStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'answer': _answer,
        'audience': _audience,
        'question': _question,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'answer': serializeParam(
          _answer,
          ParamType.String,
        ),
        'audience': serializeParam(
          _audience,
          ParamType.String,
        ),
        'question': serializeParam(
          _question,
          ParamType.String,
        ),
      }.withoutNulls;

  static ItemsFAQStruct fromSerializableMap(Map<String, dynamic> data) =>
      ItemsFAQStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        answer: deserializeParam(
          data['answer'],
          ParamType.String,
          false,
        ),
        audience: deserializeParam(
          data['audience'],
          ParamType.String,
          false,
        ),
        question: deserializeParam(
          data['question'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ItemsFAQStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ItemsFAQStruct &&
        id == other.id &&
        answer == other.answer &&
        audience == other.audience &&
        question == other.question;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, answer, audience, question]);
}

ItemsFAQStruct createItemsFAQStruct({
  String? id,
  String? answer,
  String? audience,
  String? question,
}) =>
    ItemsFAQStruct(
      id: id,
      answer: answer,
      audience: audience,
      question: question,
    );

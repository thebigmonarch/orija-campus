// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReviewsStruct extends BaseStruct {
  ReviewsStruct({
    String? id,
    String? comment,
    String? orderId,
    int? packaging,
    String? createdAt,
    String? reviewerId,
    String? reviewerName,
    int? overallRating,
    int? valueForMoney,
    int? productAccuracy,
    int? communicationSpeed,
    String? reviewerAvatarUrl,
  })  : _id = id,
        _comment = comment,
        _orderId = orderId,
        _packaging = packaging,
        _createdAt = createdAt,
        _reviewerId = reviewerId,
        _reviewerName = reviewerName,
        _overallRating = overallRating,
        _valueForMoney = valueForMoney,
        _productAccuracy = productAccuracy,
        _communicationSpeed = communicationSpeed,
        _reviewerAvatarUrl = reviewerAvatarUrl;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "comment" field.
  String? _comment;
  String get comment => _comment ?? '';
  set comment(String? val) => _comment = val;

  bool hasComment() => _comment != null;

  // "order_id" field.
  String? _orderId;
  String get orderId => _orderId ?? '';
  set orderId(String? val) => _orderId = val;

  bool hasOrderId() => _orderId != null;

  // "packaging" field.
  int? _packaging;
  int get packaging => _packaging ?? 0;
  set packaging(int? val) => _packaging = val;

  void incrementPackaging(int amount) => packaging = packaging + amount;

  bool hasPackaging() => _packaging != null;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "reviewer_id" field.
  String? _reviewerId;
  String get reviewerId => _reviewerId ?? '';
  set reviewerId(String? val) => _reviewerId = val;

  bool hasReviewerId() => _reviewerId != null;

  // "reviewer_name" field.
  String? _reviewerName;
  String get reviewerName => _reviewerName ?? '';
  set reviewerName(String? val) => _reviewerName = val;

  bool hasReviewerName() => _reviewerName != null;

  // "overall_rating" field.
  int? _overallRating;
  int get overallRating => _overallRating ?? 0;
  set overallRating(int? val) => _overallRating = val;

  void incrementOverallRating(int amount) =>
      overallRating = overallRating + amount;

  bool hasOverallRating() => _overallRating != null;

  // "value_for_money" field.
  int? _valueForMoney;
  int get valueForMoney => _valueForMoney ?? 0;
  set valueForMoney(int? val) => _valueForMoney = val;

  void incrementValueForMoney(int amount) =>
      valueForMoney = valueForMoney + amount;

  bool hasValueForMoney() => _valueForMoney != null;

  // "product_accuracy" field.
  int? _productAccuracy;
  int get productAccuracy => _productAccuracy ?? 0;
  set productAccuracy(int? val) => _productAccuracy = val;

  void incrementProductAccuracy(int amount) =>
      productAccuracy = productAccuracy + amount;

  bool hasProductAccuracy() => _productAccuracy != null;

  // "communication_speed" field.
  int? _communicationSpeed;
  int get communicationSpeed => _communicationSpeed ?? 0;
  set communicationSpeed(int? val) => _communicationSpeed = val;

  void incrementCommunicationSpeed(int amount) =>
      communicationSpeed = communicationSpeed + amount;

  bool hasCommunicationSpeed() => _communicationSpeed != null;

  // "reviewer_avatar_url" field.
  String? _reviewerAvatarUrl;
  String get reviewerAvatarUrl => _reviewerAvatarUrl ?? '';
  set reviewerAvatarUrl(String? val) => _reviewerAvatarUrl = val;

  bool hasReviewerAvatarUrl() => _reviewerAvatarUrl != null;

  static ReviewsStruct fromMap(Map<String, dynamic> data) => ReviewsStruct(
        id: data['id'] as String?,
        comment: data['comment'] as String?,
        orderId: data['order_id'] as String?,
        packaging: castToType<int>(data['packaging']),
        createdAt: data['created_at'] as String?,
        reviewerId: data['reviewer_id'] as String?,
        reviewerName: data['reviewer_name'] as String?,
        overallRating: castToType<int>(data['overall_rating']),
        valueForMoney: castToType<int>(data['value_for_money']),
        productAccuracy: castToType<int>(data['product_accuracy']),
        communicationSpeed: castToType<int>(data['communication_speed']),
        reviewerAvatarUrl: data['reviewer_avatar_url'] as String?,
      );

  static ReviewsStruct? maybeFromMap(dynamic data) =>
      data is Map ? ReviewsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'comment': _comment,
        'order_id': _orderId,
        'packaging': _packaging,
        'created_at': _createdAt,
        'reviewer_id': _reviewerId,
        'reviewer_name': _reviewerName,
        'overall_rating': _overallRating,
        'value_for_money': _valueForMoney,
        'product_accuracy': _productAccuracy,
        'communication_speed': _communicationSpeed,
        'reviewer_avatar_url': _reviewerAvatarUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'comment': serializeParam(
          _comment,
          ParamType.String,
        ),
        'order_id': serializeParam(
          _orderId,
          ParamType.String,
        ),
        'packaging': serializeParam(
          _packaging,
          ParamType.int,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'reviewer_id': serializeParam(
          _reviewerId,
          ParamType.String,
        ),
        'reviewer_name': serializeParam(
          _reviewerName,
          ParamType.String,
        ),
        'overall_rating': serializeParam(
          _overallRating,
          ParamType.int,
        ),
        'value_for_money': serializeParam(
          _valueForMoney,
          ParamType.int,
        ),
        'product_accuracy': serializeParam(
          _productAccuracy,
          ParamType.int,
        ),
        'communication_speed': serializeParam(
          _communicationSpeed,
          ParamType.int,
        ),
        'reviewer_avatar_url': serializeParam(
          _reviewerAvatarUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static ReviewsStruct fromSerializableMap(Map<String, dynamic> data) =>
      ReviewsStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        comment: deserializeParam(
          data['comment'],
          ParamType.String,
          false,
        ),
        orderId: deserializeParam(
          data['order_id'],
          ParamType.String,
          false,
        ),
        packaging: deserializeParam(
          data['packaging'],
          ParamType.int,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.String,
          false,
        ),
        reviewerId: deserializeParam(
          data['reviewer_id'],
          ParamType.String,
          false,
        ),
        reviewerName: deserializeParam(
          data['reviewer_name'],
          ParamType.String,
          false,
        ),
        overallRating: deserializeParam(
          data['overall_rating'],
          ParamType.int,
          false,
        ),
        valueForMoney: deserializeParam(
          data['value_for_money'],
          ParamType.int,
          false,
        ),
        productAccuracy: deserializeParam(
          data['product_accuracy'],
          ParamType.int,
          false,
        ),
        communicationSpeed: deserializeParam(
          data['communication_speed'],
          ParamType.int,
          false,
        ),
        reviewerAvatarUrl: deserializeParam(
          data['reviewer_avatar_url'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ReviewsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ReviewsStruct &&
        id == other.id &&
        comment == other.comment &&
        orderId == other.orderId &&
        packaging == other.packaging &&
        createdAt == other.createdAt &&
        reviewerId == other.reviewerId &&
        reviewerName == other.reviewerName &&
        overallRating == other.overallRating &&
        valueForMoney == other.valueForMoney &&
        productAccuracy == other.productAccuracy &&
        communicationSpeed == other.communicationSpeed &&
        reviewerAvatarUrl == other.reviewerAvatarUrl;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        comment,
        orderId,
        packaging,
        createdAt,
        reviewerId,
        reviewerName,
        overallRating,
        valueForMoney,
        productAccuracy,
        communicationSpeed,
        reviewerAvatarUrl
      ]);
}

ReviewsStruct createReviewsStruct({
  String? id,
  String? comment,
  String? orderId,
  int? packaging,
  String? createdAt,
  String? reviewerId,
  String? reviewerName,
  int? overallRating,
  int? valueForMoney,
  int? productAccuracy,
  int? communicationSpeed,
  String? reviewerAvatarUrl,
}) =>
    ReviewsStruct(
      id: id,
      comment: comment,
      orderId: orderId,
      packaging: packaging,
      createdAt: createdAt,
      reviewerId: reviewerId,
      reviewerName: reviewerName,
      overallRating: overallRating,
      valueForMoney: valueForMoney,
      productAccuracy: productAccuracy,
      communicationSpeed: communicationSpeed,
      reviewerAvatarUrl: reviewerAvatarUrl,
    );

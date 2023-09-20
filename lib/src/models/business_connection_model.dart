import "package:equatable/equatable.dart";

class ConnectionRequestType {
  static String storeTostore = "Store-Store";
  static String repTorep = "Representative-Representative";
}

class ConnectionStatus {
  static String pending = "Pending";
  static String active = "Active";
  static String rejected = "Rejected";
  static String inactive = "Inactive";
}

class BusinessConnectionModel extends Equatable {
  String? id;
  String? requestType;
  String? requestedId;
  String? recepientId;
  String? status;
  String? note;
  String? rejectNote;

  BusinessConnectionModel({
    this.id,
    this.requestType = "",
    this.requestedId = "",
    this.recepientId = "",
    this.status = "",
    this.note = "",
    this.rejectNote = "",
  });

  factory BusinessConnectionModel.fromJson(Map<String, dynamic> map) {
    return BusinessConnectionModel(
      id: map["_id"] ?? null,
      requestType: map["requestType"] ?? "",
      requestedId: map["requestedId"] ?? "",
      recepientId: map["recepientId"] ?? "",
      status: map["status"] ?? "",
      note: map["note"] ?? "",
      rejectNote: map["rejectNote"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "requestType": requestType ?? "",
      "requestedId": requestedId ?? "",
      "recepientId": recepientId ?? "",
      "status": status ?? "",
      "note": note ?? "",
      "rejectNote": rejectNote ?? "",
    };
  }

  factory BusinessConnectionModel.copy(BusinessConnectionModel model) {
    return BusinessConnectionModel(
      id: model.id,
      requestType: model.requestType,
      requestedId: model.requestedId,
      recepientId: model.recepientId,
      status: model.status,
      note: model.note,
      rejectNote: model.rejectNote,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        requestType!,
        requestedId!,
        recepientId!,
        status!,
        note!,
        rejectNote!,
      ];

  @override
  bool get stringify => true;
}

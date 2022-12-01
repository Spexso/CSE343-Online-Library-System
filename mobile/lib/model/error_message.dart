class ErrorMessage {

  String kind;
  String message;

  ErrorMessage(this.kind, this.message);

  factory ErrorMessage.fromJson(Map<String, dynamic> json){
    return ErrorMessage(
        json["kind"] as String,
        json["message"] as String
    );
  }
}

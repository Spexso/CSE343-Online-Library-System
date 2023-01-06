class SuspendUntil
{
  String timestamp;

  SuspendUntil( this.timestamp);

  factory SuspendUntil.fromJson(Map<String, dynamic> json){
    return SuspendUntil(
      json["timestamp"] as String,

    );
  }

}
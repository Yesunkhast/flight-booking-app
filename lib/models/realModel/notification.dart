class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String? payload;
  final DateTime sentAt;
  final String? type;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    required this.sentAt,
    this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      payload: json['payload'],
      sentAt: DateTime.parse(json['sentAt']),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'payload': payload,
      'sentAt': sentAt.toIso8601String(),
      'type': type,
    };
  }

  @override
  String toString() {
    return '''
      NotificationModel(
        id: $id,
        title: $title,
        body: $body,
        payload: $payload,
        sentAt: $sentAt,
        type: $type,
      )
      ''';
  }
}

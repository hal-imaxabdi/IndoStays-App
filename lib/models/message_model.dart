class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final List<String> participants;
  final String? propertyName;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    List<String>? participants,
    this.propertyName,
  }) : participants = participants ?? [senderId, receiverId];

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
      participants: json['participants'] != null
          ? List<String>.from(json['participants'])
          : [json['senderId'] ?? '', json['receiverId'] ?? ''],
      propertyName: json['propertyName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'participants': participants,
      'propertyName': propertyName,
    };
  }


  MessageModel copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? receiverId,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    List<String>? participants,
    String? propertyName,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      participants: participants ?? this.participants,
      propertyName: propertyName ?? this.propertyName,
    );
  }
}

class ConversationModel {
  final String id;
  final String userId;
  final String hostId;
  final String propertyId;
  final String propertyName;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final List<String> participants;

  ConversationModel({
    required this.id,
    required this.userId,
    required this.hostId,
    required this.propertyId,
    required this.propertyName,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    List<String>? participants,
  }) : participants = participants ?? [userId, hostId];

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      hostId: json['hostId'] ?? '',
      propertyId: json['propertyId'] ?? '',
      propertyName: json['propertyName'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'])
          : DateTime.now(),
      unreadCount: json['unreadCount'] ?? 0,
      participants: json['participants'] != null
          ? List<String>.from(json['participants'])
          : [json['userId'] ?? '', json['hostId'] ?? ''],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'hostId': hostId,
      'propertyId': propertyId,
      'propertyName': propertyName,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'unreadCount': unreadCount,
      'participants': participants,
    };
  }


  ConversationModel copyWith({
    String? id,
    String? userId,
    String? hostId,
    String? propertyId,
    String? propertyName,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    List<String>? participants,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      hostId: hostId ?? this.hostId,
      propertyId: propertyId ?? this.propertyId,
      propertyName: propertyName ?? this.propertyName,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      participants: participants ?? this.participants,
    );
  }
}
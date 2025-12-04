import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message_model.dart';
import '../services/firebase_service.dart';
import '../services/ai_response_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MessageController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  final AIResponseService _aiResponseService = AIResponseService();

  RxList<ConversationModel> conversations = <ConversationModel>[].obs;
  RxList<MessageModel> messages = <MessageModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isAITyping = false.obs;
  RxString currentConversationId = ''.obs;
  String currentPropertyName = '';
  String currentPropertyId = '';

  @override
  void onInit() {
    super.onInit();
    print('MessageController initialized');
    loadConversations();
  }

  void loadConversations() {
    try {
      User? user = _firebaseService.getCurrentUser();
      if (user != null) {
        print('Loading conversations for user: ${user.uid}');
        isLoading.value = true;

        _firebaseService.getUserConversations(user.uid).listen(
              (convList) {
            print('Received ${convList.length} conversations');
            conversations.value = convList;
            isLoading.value = false;
          },
          onError: (error) {
            print('Error loading conversations: $error');
            isLoading.value = false;
            conversations.value = [];
          },
        );
      } else {
        print('No user logged in for messages');
        conversations.value = [];
      }
    } catch (e) {
      print('Exception in loadConversations: $e');
      isLoading.value = false;
      conversations.value = [];
    }
  }

  void loadMessages(String conversationId) {
    try {
      currentConversationId.value = conversationId;

      _firebaseService.getMessages(conversationId).listen(
            (messageList) {
          messages.value = messageList;
        },
        onError: (error) {
          print('Error loading messages: $error');
          messages.value = [];
        },
      );
    } catch (e) {
      print('Exception in loadMessages: $e');
      messages.value = [];
    }
  }

  Future<void> sendMessage(String receiverId, String message) async {
    try {
      User? user = _firebaseService.getCurrentUser();
      if (user != null && message.trim().isNotEmpty) {
        // Ensure conversation exists first
        if (currentConversationId.value.isEmpty) {
          await createConversation(
            hostId: receiverId,
            propertyId: currentPropertyId,
            propertyName: currentPropertyName,
          );
        }


        List<String> participants = [user.uid, receiverId];


        MessageModel newMessage = MessageModel(
          id: '',
          conversationId: currentConversationId.value,
          senderId: user.uid,
          receiverId: receiverId,
          message: message.trim(),
          timestamp: DateTime.now(),
          participants: participants,
        );

        await _firebaseService.sendMessage(newMessage);
        print('✅ User message sent successfully');


        _generateAIResponse(receiverId, message.trim(), participants);
      }
    } catch (e) {
      print('❌ Error sending message: $e');
      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Failed to send message: ${e.toString()}',
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        ),
      );
    }
  }

  Future<void> _generateAIResponse(
      String hostId,
      String userMessage,
      List<String> participants
      ) async {
    try {

      isAITyping.value = true;


      await Future.delayed(Duration(seconds: 2));


      List<String> conversationHistory = messages
          .take(10)
          .map((msg) => '${msg.senderId == hostId ? "Host" : "Guest"}: ${msg.message}')
          .toList()
          .reversed
          .toList();


      String aiResponse = await _aiResponseService.generateResponse(
        userMessage: userMessage,
        propertyName: currentPropertyName,
        conversationHistory: conversationHistory,
      );


      isAITyping.value = false;


      MessageModel aiMessage = MessageModel(
        id: '',
        conversationId: currentConversationId.value,
        senderId: hostId,
        receiverId: _firebaseService.getCurrentUser()!.uid,
        message: aiResponse,
        timestamp: DateTime.now(),
        participants: participants,
      );


      await _firebaseService.sendMessage(aiMessage);
      print('✅ AI response sent successfully');

    } catch (e) {
      print('❌ Error generating AI response: $e');
      isAITyping.value = false;
    }
  }

  Future<void> createConversation({
    required String hostId,
    required String propertyId,
    required String propertyName,
  }) async {
    try {
      User? user = _firebaseService.getCurrentUser();
      if (user != null) {
        String conversationId = '${user.uid}_${hostId}_$propertyId';
        currentConversationId.value = conversationId;
        currentPropertyName = propertyName;
        currentPropertyId = propertyId;


        List<String> participants = [user.uid, hostId];

        await _firebaseService.firestore
            .collection('conversations')
            .doc(conversationId)
            .set({
          'id': conversationId,
          'userId': user.uid,
          'hostId': hostId,
          'propertyId': propertyId,
          'propertyName': propertyName,
          'lastMessage': '',
          'lastMessageTime': DateTime.now().toIso8601String(),
          'unreadCount': 0,
          'participants': participants,
        }, SetOptions(merge: true));

        print('✅ Conversation created with participants: $participants');
      }
    } catch (e) {
      print('❌ Error creating conversation: $e');
      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Failed to create conversation',
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void setPropertyName(String name) {
    currentPropertyName = name;
  }

  void setPropertyId(String id) {
    currentPropertyId = id;
  }
}
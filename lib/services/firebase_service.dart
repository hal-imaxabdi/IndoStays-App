import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/property_model.dart';
import '../models/user_model.dart';
import '../models/booking_model.dart';
import '../models/message_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  FirebaseFirestore get firestore => _firestore;



  Future<void> ensureUserDocumentExists(User user) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        print('User document does not exist, creating one...');
        await _firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'email': user.email ?? '',
          'name': user.displayName ?? user.email?.split('@')[0] ?? 'User',
          'phoneNumber': user.phoneNumber ?? '',
          'favoriteProperties': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
        print('User document created successfully');
      } else {
        print('User document already exists');
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null && data['email'] != user.email) {
          await _firestore.collection('users').doc(user.uid).update({
            'email': user.email,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      print('Error ensuring user document exists: $e');
      throw e;
    }
  }

  Future<void> createUserDocument(
      String userId, String email, String name) async {
    try {
      DocumentSnapshot existingDoc =
      await _firestore.collection('users').doc(userId).get();

      if (existingDoc.exists) {
        print('User document already exists, updating...');
        await _firestore.collection('users').doc(userId).update({
          'email': email,
          'name': name,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        print('Creating new user document...');
        await _firestore.collection('users').doc(userId).set({
          'id': userId,
          'email': email,
          'name': name,
          'phoneNumber': '',
          'favoriteProperties': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
        print('User document created successfully');
      }
    } catch (e) {
      print('Error creating/updating user document: $e');
      throw e;
    }
  }



  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<User?> registerWithEmailPassword(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        await createUserDocument(result.user!.uid, email, name);
      }

      return result.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<UserModel?> getUserData(String userId) async {
    try {
      print('Fetching user data for: $userId');
      DocumentSnapshot doc =
      await _firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        print('User document found');
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          if (!data.containsKey('favoriteProperties')) {
            await _firestore.collection('users').doc(userId).update({
              'favoriteProperties': [],
            });
            data['favoriteProperties'] = [];
          }

          return UserModel.fromJson(data);
        }
      } else {
        print('User document does not exist');
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }



  Stream<List<PropertyModel>> getProperties() {
    return _firestore.collection('properties').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => PropertyModel.fromJson(doc.data()))
            .toList());
  }

  Stream<List<PropertyModel>> getPropertiesByCity(String city) {
    return _firestore
        .collection('properties')
        .where('city', isEqualTo: city)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PropertyModel.fromJson(doc.data()))
        .toList());
  }

  Future<PropertyModel?> getPropertyById(String propertyId) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('properties').doc(propertyId).get();
      if (doc.exists) {
        return PropertyModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  Future<void> toggleFavorite(String userId, String propertyId) async {
    try {
      DocumentReference userRef = _firestore.collection('users').doc(userId);
      DocumentSnapshot userDoc = await userRef.get();

      if (!userDoc.exists) {
        throw Exception('User document not found. Please login again.');
      }

      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      List<String> favorites = [];

      if (data != null && data.containsKey('favoriteProperties')) {
        favorites = List<String>.from(data['favoriteProperties'] ?? []);
      }

      if (favorites.contains(propertyId)) {
        favorites.remove(propertyId);
      } else {
        favorites.add(propertyId);
      }

      await userRef.update({
        'favoriteProperties': favorites,
      });
    } catch (e) {
      print('Error in toggleFavorite: $e');
      throw Exception(e.toString());
    }
  }

  Stream<List<PropertyModel>> getFavoriteProperties(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().asyncMap(
          (userDoc) async {
        if (!userDoc.exists) {
          print('User document does not exist');
          return [];
        }

        final data = userDoc.data();
        if (data == null) {
          print('User document data is null');
          return [];
        }

        if (!data.containsKey('favoriteProperties')) {
          print('favoriteProperties field does not exist, initializing...');
          await _firestore.collection('users').doc(userId).update({
            'favoriteProperties': [],
          });
          return [];
        }

        List<String> favoriteIds =
        List<String>.from(data['favoriteProperties'] ?? []);
        print('Found ${favoriteIds.length} favorite IDs');

        if (favoriteIds.isEmpty) return [];

        List<PropertyModel> properties = [];
        for (String id in favoriteIds) {
          try {
            PropertyModel? property = await getPropertyById(id);
            if (property != null) {
              properties.add(property);
            }
          } catch (e) {
            print('Error loading property $id: $e');
          }
        }

        return properties;
      },
    );
  }



  Future<String> createBooking(BookingModel booking) async {
    try {
      Map<String, dynamic> bookingData = booking.toJson();
      bookingData['checkIn'] = Timestamp.fromDate(booking.checkIn);
      bookingData['checkOut'] = Timestamp.fromDate(booking.checkOut);
      bookingData['createdAt'] = Timestamp.fromDate(booking.createdAt);

      DocumentReference docRef =
      await _firestore.collection('bookings').add(bookingData);

      await docRef.update({'id': docRef.id});

      print('✅ Booking created successfully: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error creating booking: $e');
      throw Exception(e.toString());
    }
  }

  Stream<List<BookingModel>> getUserBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      print('📋 Fetched ${snapshot.docs.length} bookings for user: $userId');
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        if (!data.containsKey('id') || data['id'] == null || data['id'] == '') {
          data['id'] = doc.id;
        }
        return BookingModel.fromJson(data);
      }).toList();
    });
  }

  Future<void> confirmBookingPayment(String bookingId) async {
    try {
      print('💳 Updating booking status to confirmed: $bookingId');
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': 'confirmed',
        'paidAt': FieldValue.serverTimestamp(),
      });
      print('✅ Booking payment confirmed successfully');
    } catch (e) {
      print('❌ Error confirming booking payment: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      print('❌ Cancelling booking: $bookingId');
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
      });
      print('✅ Booking cancelled successfully');
    } catch (e) {
      print('❌ Error cancelling booking: $e');
      throw Exception(e.toString());
    }
  }


  Future<void> sendMessage(MessageModel message) async {
    try {
      print('💬 Sending message in conversation: ${message.conversationId}');

      Map<String, dynamic> messageData = message.toJson();


      if (!messageData.containsKey('participants') || messageData['participants'] == null) {
        messageData['participants'] = [message.senderId, message.receiverId];
        print('⚠️ Added missing participants field: ${messageData['participants']}');
      }


      messageData['conversationId'] = message.conversationId;
      messageData['senderId'] = message.senderId;
      messageData['receiverId'] = message.receiverId;

      print('📤 Message data being sent: ${messageData.keys.toList()}');

      DocumentReference msgRef = await _firestore.collection('messages').add(messageData);
      print('✅ Message added with ID: ${msgRef.id}');

      String currentUserId = getCurrentUser()?.uid ?? '';
      bool currentUserIsSender = message.senderId == currentUserId;

      String userId = currentUserIsSender ? message.senderId : message.receiverId;
      String hostId = currentUserIsSender ? message.receiverId : message.senderId;


      await _firestore
          .collection('conversations')
          .doc(message.conversationId)
          .set({
        'id': message.conversationId,
        'userId': userId,
        'hostId': hostId,
        'lastMessage': message.message,
        'lastMessageTime': message.timestamp.toIso8601String(),
        'unreadCount': 0,
        'participants': [userId, hostId], // CRITICAL: Always include participants
      }, SetOptions(merge: true));

      print('✅ Conversation updated: ${message.conversationId}');
    } catch (e) {
      print('❌ Error sending message: $e');
      throw Exception(e.toString());
    }
  }
  Stream<List<MessageModel>> getMessages(String conversationId) {
    print('📨 Setting up message stream for conversation: $conversationId');

    return _firestore
        .collection('messages')
        .where('conversationId', isEqualTo: conversationId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .handleError((error) {
      print('❌ Stream error: $error');

      if (error.toString().contains('index') ||
          error.toString().contains('FAILED_PRECONDITION')) {
        print('⚠️ FIRESTORE INDEX MISSING OR BUILDING');
        print('⚠️ The composite index is required but not ready.');
      }


      throw error;
    })
        .map((snapshot) {
      print('📨 Received ${snapshot.docs.length} messages');
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return MessageModel.fromJson(data);
      }).toList();
    });
  }

  Stream<List<ConversationModel>> getUserConversations(String userId) {
    print('💬 Setting up conversations stream for user: $userId');

    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .handleError((error) {
      print('❌ Conversation stream error: $error');

      if (error.toString().contains('index') ||
          error.toString().contains('FAILED_PRECONDITION')) {
        print('⚠️ FIRESTORE INDEX MISSING OR BUILDING');

      }

      throw error;
    })
        .map((snapshot) {
      print('💬 Received ${snapshot.docs.length} conversations');
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        if (!data.containsKey('id')) data['id'] = doc.id;
        if (!data.containsKey('lastMessage')) data['lastMessage'] = '';
        if (!data.containsKey('unreadCount')) data['unreadCount'] = 0;

        return ConversationModel.fromJson(data);
      }).toList();
    });
  }


  Future<bool> checkMessageIndexStatus() async {
    try {
      print('🔍 Checking if message index exists...');

      await _firestore
          .collection('messages')
          .where('conversationId', isEqualTo: '_test_index_check_')
          .orderBy('timestamp')
          .limit(1)
          .get();

      print('✅ Message index exists and is ready');
      return true;
    } catch (e) {
      if (e.toString().contains('index') ||
          e.toString().contains('FAILED_PRECONDITION')) {
        print('❌ Message index does not exist or is still building');
        return false;
      }
      print('⚠️ Other error (not index-related): $e');
      return true;
    }
  }

  Future<bool> checkConversationIndexStatus() async {
    try {
      print('🔍 Checking if conversation index exists...');

      await _firestore
          .collection('conversations')
          .where('participants', arrayContains: '_test_index_check_')
          .orderBy('lastMessageTime', descending: true)
          .limit(1)
          .get();

      print('✅ Conversation index exists and is ready');
      return true;
    } catch (e) {
      if (e.toString().contains('index') ||
          e.toString().contains('FAILED_PRECONDITION')) {
        print('❌ Conversation index does not exist or is still building');
        return false;
      }
      print('⚠️ Other error (not index-related): $e');
      return true;
    }
  }
}
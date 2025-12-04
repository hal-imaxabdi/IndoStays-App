import 'package:google_generative_ai/google_generative_ai.dart';

class AIResponseService {
  static const String geminiApiKey = 'AIzaSyCNzED9wfOj_ENFpEypD2g7KXxM-o8oIqg';

  late final GenerativeModel _model;
  bool _useAI = true;

  AIResponseService() {
    try {

      _model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: geminiApiKey,
      );
    } catch (e) {
      print('Failed to initialize Gemini model: $e');
      _useAI = false;
    }
  }


  Future<String> generateResponse({
    required String userMessage,
    required String propertyName,
    List<String>? conversationHistory,
  }) async {

    if (geminiApiKey == 'YOUR_GEMINI_API_KEY' ||
        geminiApiKey.isEmpty ||
        !_useAI) {
      print('Using fallback responses (no API)');
      return _getFallbackResponse(userMessage);
    }

    try {

      String prompt = _buildPrompt(userMessage, propertyName, conversationHistory);


      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          print('⏱️ Gemini API timeout');
          throw Exception('Timeout');
        },
      );

      if (response.text != null && response.text!.isNotEmpty) {
        print('✅ AI Response generated successfully');
        return response.text!.trim();
      } else {
        print('⚠️ Empty AI response, using fallback');
        return _getFallbackResponse(userMessage);
      }
    } catch (e) {
      print('❌ Gemini AI Error: $e');
      print('🔄 Using smart fallback response');
      return _getFallbackResponse(userMessage);
    }
  }


  String _buildPrompt(String userMessage, String propertyName, List<String>? history) {
    StringBuffer prompt = StringBuffer();

    prompt.writeln('You are a helpful and friendly property host for "$propertyName".');
    prompt.writeln('Respond to guest inquiries professionally and warmly.');
    prompt.writeln('Keep responses concise (2-3 sentences).');
    prompt.writeln('');

    if (history != null && history.isNotEmpty) {
      prompt.writeln('Recent conversation:');
      for (var msg in history.take(5)) {
        prompt.writeln(msg);
      }
      prompt.writeln('');
    }

    prompt.writeln('Guest says: "$userMessage"');
    prompt.writeln('');
    prompt.writeln('Respond as the property host:');

    return prompt.toString();
  }


  String _getFallbackResponse(String userMessage) {
    String lowerMessage = userMessage.toLowerCase();

    // Greetings
    if (_containsAny(lowerMessage, ['hello', 'hi', 'hey', 'good morning', 'good afternoon', 'good evening'])) {
      return _randomChoice([
        'Hello! Thank you for your interest in our property. How can I assist you today?',
        'Hi there! Welcome! What would you like to know about our property?',
        'Hello! It\'s great to hear from you. How may I help you?',
      ]);
    }

    // Pricing inquiries
    if (_containsAny(lowerMessage, ['price', 'cost', 'rate', 'how much', 'expensive', 'cheap', 'afford'])) {
      return _randomChoice([
        'Thank you for asking about pricing! Our rates vary by season and length of stay. Could you share your preferred dates so I can provide accurate pricing?',
        'Great question! I\'d be happy to discuss pricing. When are you planning to visit?',
        'Our pricing is competitive and depends on your booking dates. What dates did you have in mind?',
      ]);
    }

    // Availability and booking
    if (_containsAny(lowerMessage, ['available', 'book', 'reserve', 'reservation', 'stay', 'check in', 'check-in'])) {
      return _randomChoice([
        'I\'d love to help you book! What dates are you considering for your stay?',
        'Great! Let me check availability for you. Which dates work best for you?',
        'I\'m excited to host you! Please share your preferred check-in and check-out dates.',
      ]);
    }

    // Amenities
    if (_containsAny(lowerMessage, ['amenity', 'amenities', 'facility', 'facilities', 'feature', 'include', 'have', 'offer'])) {
      return _randomChoice([
        'Our property offers excellent amenities! We have WiFi, kitchen facilities, parking, and more. What specific amenities are you interested in?',
        'We provide many great features for our guests. Is there a particular amenity you\'re looking for?',
        'Great question! Our property is well-equipped. What amenities are most important to you?',
      ]);
    }

    // Location
    if (_containsAny(lowerMessage, ['where', 'location', 'address', 'nearby', 'close to', 'distance', 'far'])) {
      return _randomChoice([
        'Our property is conveniently located with easy access to local attractions. What specific locations or landmarks are you interested in?',
        'The location is excellent! We\'re close to many popular spots. What would you like to be near?',
        'Great question about location! What places or activities are you planning to visit?',
      ]);
    }

    // WiFi/Internet
    if (_containsAny(lowerMessage, ['wifi', 'wi-fi', 'internet', 'connection', 'online'])) {
      return 'Yes, we provide high-speed WiFi throughout the property. You\'ll have reliable internet access during your stay!';
    }

    // Parking
    if (_containsAny(lowerMessage, ['park', 'parking', 'car', 'vehicle'])) {
      return 'Yes, we offer convenient parking facilities for our guests. Your vehicle will be safe and secure!';
    }

    // Pets
    if (_containsAny(lowerMessage, ['pet', 'dog', 'cat', 'animal'])) {
      return 'Thank you for asking! Please let me check our pet policy for you. Do you have a specific type of pet?';
    }

    // Check-in/Check-out times
    if (_containsAny(lowerMessage, ['check in time', 'check out time', 'arrival', 'departure', 'what time'])) {
      return 'Our standard check-in time is 2:00 PM and check-out is 11:00 AM. We can discuss flexible timing if needed!';
    }

    // Cancellation
    if (_containsAny(lowerMessage, ['cancel', 'cancellation', 'refund', 'policy'])) {
      return 'Our cancellation policy is flexible and guest-friendly. I\'ll share the full details with you. When are you planning to book?';
    }

    // Thank you
    if (_containsAny(lowerMessage, ['thank', 'thanks', 'appreciate'])) {
      return _randomChoice([
        'You\'re very welcome! Feel free to ask anything else.',
        'My pleasure! I\'m here to help with any other questions.',
        'Happy to help! Let me know if you need anything else.',
      ]);
    }

    // Questions
    if (lowerMessage.contains('?')) {
      return _randomChoice([
        'That\'s a great question! Let me provide you with accurate information. Could you give me a bit more detail?',
        'Thank you for asking! I want to give you the best answer. Can you elaborate a bit more?',
        'I\'d be happy to help with that! Could you provide a few more details so I can assist you better?',
      ]);
    }

    // Default responses
    return _randomChoice([
      'Thank you for your message! I\'m here to help. Could you tell me more about what you\'re looking for?',
      'Thanks for reaching out! I\'d love to assist you. What would you like to know about the property?',
      'Hello! I appreciate your interest. How can I help make your stay perfect?',
      'Thank you for contacting us! I\'m happy to answer any questions you have about the property.',
    ]);
  }


  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }

  String _randomChoice(List<String> options) {
    return options[DateTime.now().millisecond % options.length];
  }
}
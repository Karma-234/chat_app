import 'package:chat_app/core/models/payloads/chat_payload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageModel {
  final String? userEmail;
  final String? message;

  final DateTime? createdAt;

  MessageModel({
    this.userEmail,
    this.createdAt,
    this.message,
  });
  Map<String, dynamic> toJson() =>
      {'email': userEmail, 'message': message, 'time': createdAt};

  static MessageModel fromPayLoad(ChatPayload chatPayload) {
    return MessageModel(
      userEmail: chatPayload.userEmail,
      message: chatPayload.message,
      createdAt: chatPayload.createdAt,
    );
  }

  static MessageModel fromJson(Map json) {
    return MessageModel(
      userEmail: json['email'],
      message: json['message'],
      createdAt: json['time'],
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_cl/models/user_model.dart';
import 'package:whatsapp_cl/utils/utils.dart';

final contactsRepositoryProvider = Provider(
  (ref) {
    return ContactsRepository(
      firestore: FirebaseFirestore.instance,
    );
  },
);

class ContactsRepository {
  final FirebaseFirestore firestore;

  ContactsRepository({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(BuildContext context, Contact contact) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectNumber = Platform.isIOS
            ? contact.phones[0].number.replaceAll(' ', '')
            : contact.phones[0].number.replaceAllMapped(
                RegExp(r'[ -]'),
                (match) => '',
              );
        if (selectNumber == userData.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(context, '/chat', arguments: {
            'name': userData.name,
            'uid': userData.uid,
          });
        }
      }

      if (!isFound) {
        showSnackbar(
          context: context,
          content: 'User not found',
        );
      }
    } catch (e) {
      showSnackbar(
        context: context,
        content: e.toString(),
      );
    }
  }
}
